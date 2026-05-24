import 'package:my_supabase_app/presentation/widgets/snackbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  final supabase = Supabase.instance.client;
  final String bucketName = 'uploads';

  // Changed return type to a List of Maps containing both path and url
  Future<List<Map<String, String>>> fetchUserImages() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return [];
    try {
      final List<FileObject> files = await supabase.storage
          .from(bucketName)
          .list(path: userId);

      if (files.isEmpty) return [];

      final List<String> filePaths = files
          .map((file) => '$userId/${file.name}')
          .toList();

      // Temporary URLs, valid for 60 minutes
      final List<SignedUrl> signedUrls = await supabase.storage
          .from(bucketName)
          .createSignedUrls(filePaths, 3600);

      // Pair each path with its signed URL
      List<Map<String, String>> imageData = [];
      for (int i = 0; i < filePaths.length; i++) {
        imageData.add({'path': filePaths[i], 'url': signedUrls[i].signedUrl});
      }
      return imageData;
    } catch (e) {
      mySnackBar(e.toString(), null);
      return [];
    }
  }

  Future<void> deleteImage(String filePath) async {
    try {
      // Expects: 'USER_ID/filename.jpg'
      await supabase.storage.from(bucketName).remove([filePath]);
    } catch (e) {
      mySnackBar(e.toString(), null);
      rethrow;
    }
  }
}
