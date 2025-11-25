import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/app_styles.dart';

class GalleryPreviewScreen extends StatefulWidget {
  static const routeName = "/galleryPreview";

  final String imagePath;

  const GalleryPreviewScreen({super.key, required this.imagePath});

  @override
  _GalleryPreviewScreenState createState() => _GalleryPreviewScreenState();
}

class _GalleryPreviewScreenState extends State<GalleryPreviewScreen> {
  late String currentImagePath;

  @override
  void initState() {
    super.initState();
    currentImagePath = widget.imagePath;
  }

  // Pick another image
  Future<void> _pickAnotherImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        currentImagePath = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 70),
              Text("Select a Photo", style: AppStyles.pageTitleStyle),
              const SizedBox(height: 60),

              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(currentImagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 50),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _pickAnotherImage,
                  style: AppStyles.flatButtonStyle.copyWith(
                    backgroundColor:
                        WidgetStateProperty.all(Colors.grey[500]),
                  ),
                  child: const Text("Select Another"),
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, currentImagePath);
                  },
                  style: AppStyles.flatButtonStyle.copyWith(
                    backgroundColor:
                        WidgetStateProperty.all(Colors.grey[400]),
                  ),
                  child: const Text("Confirm Changes"),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
