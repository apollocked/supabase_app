import 'package:flutter/material.dart';
import 'package:my_supabase_app/presentation/widgets/custom_confirmation.dart';
import 'package:my_supabase_app/presentation/widgets/empty_state/empty_gallery.dart';
import 'package:my_supabase_app/service/file_storage_service.dart';

class GalleryWidget extends StatefulWidget {
  const GalleryWidget({super.key});

  @override
  State<GalleryWidget> createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget> {
  final StorageService _storageService = StorageService();

  List<Map<String, String>> _images = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchImages();
  }

  Future<void> _fetchImages() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final images = await _storageService.fetchUserImages();
      setState(() {
        _images = images;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _handleDelete(int index) async {
    final imageToDelete = _images[index];
    final path = imageToDelete['path']!;
    setState(() {
      _images.removeAt(index);
    });

    try {
      await _storageService.deleteImage(path);
    } catch (e) {
      setState(() {
        _images.insert(index, imageToDelete);
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to delete: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.pinkAccent),
      );
    }

    if (_errorMessage != null) {
      return Center(child: Text('Error: $_errorMessage'));
    }

    if (_images.isEmpty) {
      return const EmptyGalleryWidget();
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
              itemCount: _images.length,
              itemBuilder: (context, index) {
                final url = _images[index]['url']!;

                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.pinkAccent, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: GestureDetector(
                    onLongPress: () => customConfirmationDialog(
                      context,
                      "Delete Image",
                      "Are you sure you want to delete this image?",
                      "Delete",
                      () {
                        _handleDelete(index);
                      },
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        url,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey,
                            child: const Icon(
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
          Text(
            'Long press on a image to delete it.',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
