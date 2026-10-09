import 'package:flutter_ecommerce/common/utils/typedef.dart';
import 'package:flutter_ecommerce/core/exception.dart';
import 'package:flutter_ecommerce/core/repositories/image_uploader_repository.dart';
import 'package:flutter_ecommerce/core/repositories/user_local_data_repository.dart';
import 'package:flutter_ecommerce/features/product/models/product.dart';
import 'package:flutter_ecommerce/features/product/models/product_form.dart';
import 'package:flutter_ecommerce/features/search/models/product_search_params.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

abstract interface class ProductRepository {
  FutureEither<List<Product>> getProducts();
  FutureEither<List<Product>> searchProducts(ProductSearchParams params);
  FutureEither<String> addProduct(ProductForm product);
  FutureEither<String> updateProduct(ProductForm product);
}

class ProductRepositoryI implements ProductRepository {
  final SupabaseClient _client;
  final ImageUploaderRepository _imageUploaderRepository;
  final UserLocalDataRepository _userRepository;
  ProductRepositoryI(
      {required SupabaseClient client,
      required ImageUploaderRepository imageUploaderRepo,
      required UserLocalDataRepository userRepository})
      : _client = client,
        _imageUploaderRepository = imageUploaderRepo,
        _userRepository = userRepository;

  @override
  FutureEither<String> addProduct(ProductForm product) async {
    return await handleApplicationException(() async {
      final productId = Uuid().v4();
      await _client.from('products').insert({
        'id': productId,
        'name': product.name,
        'description': product.description,
        'price': product.price,
        'category_id': product.categoryId,
        'quantity': product.quantity,
        'discount_price': product.discountPrice,
        'vendor_id': await _getUserId()
      });

      // Logger().d(response.toString());

      final imageUrls = await Future.wait(
        product.imageFiles.map((file) async {
          final imageUrl = await _imageUploaderRepository.uploadImage(
            imageFile: file,
          );
          return imageUrl;
        }),
      );

      await Future.wait(imageUrls.map((url) async {
        await _client.from('product_images').insert([
          {
            'image_url': url,
            'product_id': productId,
          }
        ]);
      }).toList());

      return "Product added successfully";
    });
  }

  @override
  FutureEither<String> updateProduct(ProductForm product) {
    // TODO: implement updateProduct
    throw UnimplementedError();
  }

  @override
  FutureEither<List<Product>> getProducts() async {
    return await handleApplicationException(() async {
      final productsMap =
          await _client.from('products').select('*, images:product_images(*)');
      final products =
          List.from(productsMap).map((e) => Product.fromJson(e)).toList();
      return products;
    });
  }

  @override
  FutureEither<List<Product>> searchProducts(ProductSearchParams params) async {
    return await handleApplicationException(() async {
      var query =
          _client.from('products').select('*, images:product_images(*)');

      if (params.categoryId != null) {
        query = query.eq('category_id', params.categoryId!);
      }

      if (params.minPrice != null && params.minPrice! > 0) {
        query = query.gte('price', params.minPrice!);
      }

      if (params.maxPrice != null && params.maxPrice! > 0) {
        query = query.lte('price', params.maxPrice!);
      }

      if (params.hasDiscount == true) {
        query = query.gt('discount_price', 0);
      }

      if (params.query != null && params.query!.isNotEmpty) {
        query = query.or(
            'name.ilike.%${params.query}%,description.ilike.%${params.query}%');
      }

      final productsMap = await query;
      final products =
          List.from(productsMap).map((e) => Product.fromJson(e)).toList();
      return products;
    });
  }

  Future<String> _getUserId() async {
    final failureOrUser = await _userRepository.getData();
    return failureOrUser.fold((failure) => throw failure, (user) => user.id);
  }
}
