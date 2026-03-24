import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseHelperStorage {
  static final _client = Supabase.instance.client;
  static final ImagePicker _picker = ImagePicker();

  Future<File?> pickImage(ImageSource source) async {
    // 1. Determine which permission to check
    Permission permission =
        (source == ImageSource.camera)
            ? Permission.camera
            : (Platform.isIOS ? Permission.photos : Permission.storage);

    // 2. Request/Check Permission
    PermissionStatus status = await permission.request();

    if (status.isGranted) {
      // 3. Pick the Image
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80, // Integrated compression
        maxWidth: 1024, // Resize on the fly
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
    } else if (status.isPermanentlyDenied) {
      // User rejected multiple times; they must go to settings manually
      await openAppSettings();
    }

    return null;
  }

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
