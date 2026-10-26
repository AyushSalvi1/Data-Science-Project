import 'package:dartz/dartz.dart';
import 'package:flutter_ecommerce/common/utils/typedef.dart';
import 'package:flutter_ecommerce/core/exception.dart';
import 'package:flutter_ecommerce/core/repositories/image_uploader_repository.dart';
import 'package:flutter_ecommerce/core/repositories/user_local_data_repository.dart';
import 'package:flutter_ecommerce/features/product/models/product.dart';
import 'package:flutter_ecommerce/features/product/models/product_form.dart';
import 'package:flutter_ecommerce/features/product/models/product_image.dart';
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

  static final List<Product> _fallbackProducts = [
    Product(
      id: "prod_1",
      name: "Apple iPhone 15 Pro Max (256GB)",
      description: "Titanium design with A17 Pro chip, 48MP camera, and 5x Telephoto lens.",
      price: 134900.0,
      discountPrice: 129999.0,
      stockQuantity: 15,
      images: [
        ProductImage(id: "img_1", url: "https://images.unsplash.com/photo-1510557880182-3d4d3cba35a5?w=500&q=80"),
      ],
    ),
    Product(
      id: "prod_2",
      name: "Sony WH-1000XM5 Wireless ANC Headphones",
      description: "Industry-leading noise cancellation with 30-hour battery life and multi-point connection.",
      price: 29990.0,
      discountPrice: 24990.0,
      stockQuantity: 28,
      images: [
        ProductImage(id: "img_2", url: "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500&q=80"),
      ],
    ),
    Product(
      id: "prod_3",
      name: "ASUS ROG Zephyrus G16 (2024) Gaming Laptop",
      description: "Intel Core Ultra 9, RTX 4080, 2.5K 240Hz OLED Nebula display, 32GB LPDDR5X.",
      price: 189990.0,
      discountPrice: 169990.0,
      stockQuantity: 8,
      images: [
        ProductImage(id: "img_3", url: "https://images.unsplash.com/photo-1593642632823-8f785ba67e45?w=500&q=80"),
      ],
    ),
    Product(
      id: "prod_4",
      name: "Apple Watch Series 9 GPS 45mm",
      description: "S9 SiP with Double Tap gesture, brighter display, and advanced health tracking.",
      price: 41900.0,
      discountPrice: 36990.0,
      stockQuantity: 22,
      images: [
        ProductImage(id: "img_4", url: "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500&q=80"),
      ],
    ),
    Product(
      id: "prod_5",
      name: "Samsung Galaxy S24 Ultra 5G (Titanium Gray)",
      description: "Galaxy AI powered with 200MP camera, Snapdragon 8 Gen 3, and built-in S-Pen.",
      price: 129999.0,
      discountPrice: 119999.0,
      stockQuantity: 19,
      images: [
        ProductImage(id: "img_5", url: "https://images.unsplash.com/photo-1610945415295-d9bbf067e59c?w=500&q=80"),
      ],
    ),
    Product(
      id: "prod_6",
      name: "Nothing Ear (2) TWS ANC Earbuds",
      description: "Ultra-light transparent design, Hi-Res Audio certification, and personalized sound profile.",
      price: 9999.0,
      discountPrice: 7999.0,
      stockQuantity: 40,
      images: [
        ProductImage(id: "img_6", url: "https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=500&q=80"),
      ],
    ),
  ];

  @override
  FutureEither<List<Product>> getProducts() async {
    try {
      final productsMap =
          await _client.from('products').select('*, images:product_images(*)');
      if (productsMap.isNotEmpty) {
        final products =
            List.from(productsMap).map((e) => Product.fromJson(e)).toList();
        return Right(products);
      }
    } catch (_) {}
    return Right(_fallbackProducts);
  }

  @override
  FutureEither<List<Product>> searchProducts(ProductSearchParams params) async {
    try {
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
      if (productsMap.isNotEmpty) {
        final products =
            List.from(productsMap).map((e) => Product.fromJson(e)).toList();
        return Right(products);
      }
    } catch (_) {}

    // Fallback filtering
    final filtered = _fallbackProducts.where((p) {
      if (params.minPrice != null && p.price < params.minPrice!) return false;
      if (params.maxPrice != null && p.price > params.maxPrice!) return false;
      if (params.hasDiscount == true && p.discountPrice == null) return false;
      if (params.query != null && params.query!.isNotEmpty) {
        final q = params.query!.toLowerCase();
        return p.name.toLowerCase().contains(q) ||
            p.description.toLowerCase().contains(q);
      }
      return true;
    }).toList();

    return Right(filtered);
  }

  Future<String> _getUserId() async {
    final failureOrUser = await _userRepository.getData();
    return failureOrUser.fold((failure) => throw failure, (user) => user.id);
  }
}
