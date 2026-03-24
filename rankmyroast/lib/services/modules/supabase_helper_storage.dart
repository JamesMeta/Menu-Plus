import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

class SupabaseHelperStorage {
  static final _client = Supabase.instance.client;

  Future<void> uploadFileToFolder({
    required String bucketName,
    required String folderName,
    required File file,
    required String fileName,
  }) async {
    final supabase = Supabase.instance.client;

    // Construct the full path: "folder/filename.ext"
    final String path = '$folderName/$fileName';

    try {
      await supabase.storage
          .from(bucketName)
          .upload(
            path,
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
          );
      print('Upload successful to $bucketName/$path');
    } on StorageException catch (error) {
      print('Storage Error: ${error.message}');
    } catch (error) {
      print('Unexpected Error: $error');
    }
  }
}
