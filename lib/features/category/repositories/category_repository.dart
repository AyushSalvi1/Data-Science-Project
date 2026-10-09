import 'dart:io';
import 'package:flutter_ecommerce/common/utils/typedef.dart';
import 'package:flutter_ecommerce/core/exception.dart';
import 'package:flutter_ecommerce/core/repositories/image_uploader_repository.dart';
import 'package:flutter_ecommerce/features/category/models/category.dart';
import 'package:logger/web.dart';
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

  @override
  FutureEither<List<Category>> getCategories() async {
    return await handleApplicationException(() async {
      final response = await _client.from("categories").select();
      if (response.isEmpty) {
        return [];
      }
      Logger().d("Categories: $response");
      return List.from(response)
          .map((category) => Category.fromJson(category))
          .toList();
    });
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
