import 'dart:io';
import 'package:flutter/material.dart';
import '../utils/app_styles.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = '/editProfile';

  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _profileImage;

  final _nameController = TextEditingController();
  final _uniController = TextEditingController();
  final _bioController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _uniController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _navigateToChangeProfile() async {
    final result = await Navigator.pushNamed(context, '/changeProfile');

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

      /// 🔹 APP BAR (GERİ OK + BAŞLIK)
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "Edit Profile",
          style: AppStyles.pageTitleStyle.copyWith(color: Colors.black),
        ),
      ),

      /// 🔹 BODY
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            children: [
              /// PROFILE IMAGE
              GestureDetector(
                onTap: _navigateToChangeProfile,
                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
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
                          ? Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.grey[600],
                      )
                          : null,
                    ),

                    /// EDIT ICON
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppStyles.primaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              /// FULL NAME
              _buildTextField("Full Name", _nameController),
              const SizedBox(height: 15),

              /// UNIVERSITY
              _buildTextField("University", _uniController),
              const SizedBox(height: 15),

              /// BIO
              TextField(
                controller: _bioController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText:
                  "Tell others about your interests and what clubs you love!",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  contentPadding: const EdgeInsets.all(14),
                ),
              ),

              const SizedBox(height: 40),

              /// SAVE BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // 🔜 Firebase gelince burada save işlemi olacak
                    Navigator.pop(context);
                  },
                  style: AppStyles.primaryButtonStyle.copyWith(
                    backgroundColor:
                    WidgetStateProperty.all(Colors.blue),
                  ),
                  child: const Text("Save Changes"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 TEXT FIELD HELPER
  Widget _buildTextField(
      String label,
      TextEditingController controller,
      ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      ),
    );
  }
}
