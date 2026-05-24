import 'package:flutter/material.dart';
import 'package:my_supabase_app/presentation/widgets/snackbar.dart';
import 'package:my_supabase_app/service/file_storage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GalleryWidget extends StatefulWidget {
  const GalleryWidget({super.key});

  @override
  State<GalleryWidget> createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget> {
  final StorageService _storageService = StorageService();
  late Future<List<String>> _imagesFuture;
  String? userId = Supabase.instance.client.auth.currentUser?.id;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refreshGallery();
  }

  @override
  void initState() {
    super.initState();
    _imagesFuture = _storageService.fetchUserImages();
  }

  void _refreshGallery() {
    setState(() {
      _imagesFuture = _storageService.fetchUserImages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _imagesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final imageUrls = snapshot.data ?? [];

        if (imageUrls.isEmpty) {
          return const Center(child: Text('No images uploaded yet.'));
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text(
                'Gallery',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 550,
                child: GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: imageUrls.length,
                  itemBuilder: (context, index) {
                    final url = imageUrls[index];
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black45, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: GestureDetector(
                        onLongPress: () async {
                          try {
                            final uri = Uri.parse(url);
                            final String fileName = uri.pathSegments.last;

                            final String properStoragePath =
                                '$userId/$fileName';

                            await _storageService.deleteImage(
                              properStoragePath,
                            );
                            _refreshGallery();
                          } catch (e) {
                            mySnackBar(e.toString(), null);
                          }
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            url,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey,
                                child: Icon(
                                  Icons.broken_image,
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
