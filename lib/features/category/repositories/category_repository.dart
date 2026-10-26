import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_ecommerce/common/utils/typedef.dart';
import 'package:flutter_ecommerce/core/exception.dart';
import 'package:flutter_ecommerce/core/repositories/image_uploader_repository.dart';
import 'package:flutter_ecommerce/features/category/models/category.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class CategoryRepository {
  FutureEither<List<Category>> getCategories();
  FutureEither<String> addCategory(
      {required String name, required File imageFile});
}

class CategoryRepositoryI implements CategoryRepository {
  final SupabaseClient _client;
  final ImageUploaderRepository _imageUploaderRepo;
  CategoryRepositoryI({
    required SupabaseClient client,
    required ImageUploaderRepository imageUploaderRepo,
  })  : _client = client,
        _imageUploaderRepo = imageUploaderRepo;

  static final List<Category> _fallbackCategories = [
    Category(id: '1', name: 'Electronics', imageUrl: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=300&q=80'),
    Category(id: '2', name: 'Computers', imageUrl: 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=300&q=80'),
    Category(id: '3', name: 'Audio', imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=300&q=80'),
    Category(id: '4', name: 'Wearables', imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=300&q=80'),
    Category(id: '5', name: 'Gaming', imageUrl: 'https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?w=300&q=80'),
  ];

  @override
  FutureEither<List<Category>> getCategories() async {
    try {
      final response = await _client.from("categories").select();
      if (response.isNotEmpty) {
        return Right(List.from(response)
            .map((category) => Category.fromJson(category))
            .toList());
      }
    } catch (_) {}
    return Right(_fallbackCategories);
  }

  @override
  FutureEither<String> addCategory(
      {required String name, required File imageFile}) async {
    return await handleApplicationException(() async {
      await _client.from("categories").insert({
        "name": name,
        "image_url": await _imageUploaderRepo.uploadImage(imageFile: imageFile),
      });
      return "Category added successfully";
    });
  }
}
