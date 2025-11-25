import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../utils/app_styles.dart';

class CameraPreviewScreen extends StatefulWidget {
  static const routeName = "/camera";

  const CameraPreviewScreen({super.key});

  @override
  _CameraPreviewScreenState createState() => _CameraPreviewScreenState();
}

class _CameraPreviewScreenState extends State<CameraPreviewScreen> {
  CameraController? _controller;
  List<CameraDescription>? cameras;
  int selectedCameraIndex = 0;
  XFile? capturedImage; // frozen photo

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    cameras = await availableCameras();

    if (cameras != null && cameras!.isNotEmpty) {
      _controller = CameraController(
        cameras![selectedCameraIndex],
        ResolutionPreset.high,
      );

      await _controller!.initialize();
      if (mounted) setState(() {});
    }
  }

  void _flipCamera() {
    if (cameras == null || cameras!.length < 2) return;

    selectedCameraIndex = (selectedCameraIndex == 0) ? 1 : 0;

    // reset frozen image when flipping camera
    setState(() {
      capturedImage = null;
    });

    _initCamera();
  }

  Future<void> _takePicture() async {
    if (!_controller!.value.isInitialized) return;
    if (_controller!.value.isTakingPicture) return;

    try {
      final image = await _controller!.takePicture();
      setState(() {
        capturedImage = image; // freeze image
      });
    } catch (e) {
      print(e);
    }
  }

  void _onSave() {
    if (capturedImage != null) {
      Navigator.pop(context, capturedImage!.path);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please take a photo first!")),
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Take a Photo", style: AppStyles.pageTitleStyle),
                  const SizedBox(height: 10),

                  // flip camera
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.flip_camera_ios, color: Colors.black),
                      onPressed: _flipCamera,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // camera preview or frozen image
                  AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: capturedImage != null
                          ? Image.file(
                              File(capturedImage!.path),
                              fit: BoxFit.cover,
                            )
                          : CameraPreview(_controller!),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // capture button
                  GestureDetector(
                    onTap: _takePicture,
                    child: Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey, width: 2),
                      ),
                      child: const Icon(Icons.camera_alt, size: 30, color: Colors.black),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // save
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _onSave,
                      style: AppStyles.primaryButtonStyle.copyWith(
                        backgroundColor: WidgetStateProperty.all(Colors.blue),
                      ),
                      child: const Text("Save Changes"),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // cancel
                  SizedBox(
                    width: 150,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[400],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
