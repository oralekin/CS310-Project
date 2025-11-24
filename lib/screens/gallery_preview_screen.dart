import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/app_styles.dart';

class GalleryPreviewScreen extends StatefulWidget {
  final String imagePath;
  const GalleryPreviewScreen({required this.imagePath});

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

  //to change the photo if Select Another
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
              SizedBox(height: 70),
              Text("Select a Photo", style: AppStyles.pageTitleStyle),

              SizedBox(height: 60),

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

              SizedBox(height: 50),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _pickAnotherImage,
                  style: AppStyles.flatButtonStyle.copyWith(
                    backgroundColor: WidgetStateProperty.all(Colors.grey[500]),
                  ),
                  child: Text("Select Another"),
                ),
              ),

              SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    //Pass the image path back to the previous screen
                    Navigator.pop(context, widget.imagePath);
                  },
                  style: AppStyles.flatButtonStyle.copyWith(
                    backgroundColor: WidgetStateProperty.all(Colors.grey[400]),
                  ),
                  child: Text("Confirm Changes"),
                ),
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}