import 'package:flutter/material.dart';
import 'package:my_supabase_app/presentation/widgets/snackbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  final supabase = Supabase.instance.client;
  final String bucketName = 'uploads';

  Future<List<String>> fetchUserImages() async {
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
      // temporary URLs ,valid for 60 minutes
      final List<SignedUrl> signedUrls = await supabase.storage
          .from(bucketName)
          .createSignedUrls(filePaths, 3600);
      return signedUrls.map((e) => e.signedUrl).toList();
    } catch (e) {
      mySnackBar(e.toString(), null);
      return [];
    }
  }

  Future<void> deleteImage(String filePath) async {
    try {
      // filePath must look like: 'USER_ID/filename.jpg'
      await supabase.storage.from(bucketName).remove([filePath]);
      mySnackBar('File deleted ', null, color: Colors.red);
    } catch (e) {
      mySnackBar(e.toString(), null);
      rethrow;
    }
  }
}
