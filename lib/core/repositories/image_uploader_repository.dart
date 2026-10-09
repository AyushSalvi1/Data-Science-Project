import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class ImageUploaderRepository {
  Future<String> uploadImage({required File imageFile});
}

class ImageUploaderRepositoryI implements ImageUploaderRepository {
  final SupabaseClient _client;
  ImageUploaderRepositoryI({required SupabaseClient client}) : _client = client;
  @override
  Future<String> uploadImage({required File imageFile}) async {
    final fileName = imageFile.path.split('/').last;
    final currentDate = DateTime.now();
    final filePath = 'images/$currentDate$fileName';
    try {
      return await _client.storage
          .from('ecommerce-storage')
          .upload(filePath, imageFile);
    } on StorageException catch (e) {
      debugPrint("Error uploading image: $e");
      throw e.message;
    } catch (e) {
      debugPrint("Error uploading image: $e");
      rethrow;
    }
  }
}
