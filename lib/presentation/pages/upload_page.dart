import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_supabase_app/presentation/widgets/snackbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  // Image Picker
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
    final filename = DateTime.now().millisecondsSinceEpoch.toString();
    final path =
        '${Supabase.instance.client.auth.currentUser!.id}/$filename.jpg';

    await Supabase.instance.client.storage
        .from('uploads')
        .upload(path, imageFile!)
        .then((value) async {
          mySnackBar("Image uploaded successfuly", context);
          await Future.delayed(const Duration(seconds: 2));
          Navigator.pop(context);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: imageFile != null
                ? [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54, width: 2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.file(imageFile!, fit: BoxFit.cover),
                        ),
                      ),
                    ),

                    ElevatedButton(
                      onPressed: uploadImage,
                      child: const Text('Upload'),
                    ),
                  ]
                : [
                    const Text('No Image Uploaded yet'),

                    ElevatedButton(
                      onPressed: pickImage,
                      child: const Text('Pick Image'),
                    ),
                  ],
          ),
        ),
      ),
    );
  }
}
