import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'gallery_preview_screen.dart';
import '../utils/app_styles.dart';

class ChangeProfileScreen extends StatefulWidget {
  static const routeName = "/changeProfile";

  const ChangeProfileScreen({super.key});

  @override
  _ChangeProfileScreenState createState() => _ChangeProfileScreenState();
}

class _ChangeProfileScreenState extends State<ChangeProfileScreen> {
  File? _profileImage;

  // Helper to update image when returning from other screens
  Future<void> _updateProfileImage(Future<dynamic> navigationCall) async {
    final result = await navigationCall;
    if (result != null && result is String) {
      setState(() {
        _profileImage = File(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Change Profile Picture", style: AppStyles.pageTitleStyle),
                    const SizedBox(height: 50),
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                        image: _profileImage != null
                            ? DecorationImage(
                                image: FileImage(_profileImage!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: _profileImage == null
                          ? const Text(
                              "current photo\nplaceholder",
                              textAlign: TextAlign.center,
                            )
                          : null,
                    ),
                    const SizedBox(height: 60),

                    ElevatedButton(
                      onPressed: () {
                        _updateProfileImage(_pickFromGallery(context));
                      },
                      style: AppStyles.flatButtonStyle,
                      child: const Text("Select From Gallery"),
                    ),

                    const SizedBox(height: 15),

                    ElevatedButton(
                      onPressed: () {
                        _updateProfileImage(
                          Navigator.pushNamed(context, '/camera'),
                        );
                      },
                      style: AppStyles.flatButtonStyle,
                      child: const Text("Take a Photo"),
                    ),

                    const SizedBox(height: 30),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> _pickFromGallery(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => GalleryPreviewScreen(imagePath: image.path),
        ),
      );
      return result;
    }
    return null;
  }
}
