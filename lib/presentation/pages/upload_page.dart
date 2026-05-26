// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_supabase_app/presentation/widgets/gallery_widget.dart';
import 'package:my_supabase_app/presentation/widgets/my_widgets/snackbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  bool _isUploading = false;
  File? imageFile;
  Future<void> pickImage() async {
    final imagePicker = ImagePicker();
    final XFile? image = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      imageFile = File(image.path);
      setState(() {});
    }
  }

  // upload image
  Future uploadImage() async {
    if (imageFile == null) {
      return;
    }
    setState(() {
      _isUploading = true;
    });
    final filename = DateTime.now().millisecondsSinceEpoch.toString();
    final path =
        '${Supabase.instance.client.auth.currentUser!.id}/$filename.jpg';

    try {
      await Supabase.instance.client.storage
          .from('uploads')
          .upload(path, imageFile!);
      if (!mounted) return;
      mySnackBar("Image uploaded successfully", context, color: Colors.green);
      setState(() {
        imageFile = null;
      });
    } catch (e) {
      if (mounted) {
        mySnackBar("Upload failed: $e", context, color: Colors.red);
      }
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: imageFile != null
                  ? [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54, width: 2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.file(imageFile!, fit: BoxFit.cover),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          uploadImage();
                        },
                        child: _isUploading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.purpleAccent,
                                ),
                              )
                            : const Text('Upload'),
                      ),
                    ]
                  : [
                      Container(
                        height: 630,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54, width: 2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: GalleryWidget(),
                      ),
                      ElevatedButton(
                        onPressed: pickImage,
                        child: const Text('Pick Image'),
                      ),
                    ],
            ),
          ),
        ),
      ),
    );
  }
}
