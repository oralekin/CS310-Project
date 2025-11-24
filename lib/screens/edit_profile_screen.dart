import 'dart:io';
import 'package:flutter/material.dart';
import '../utils/app_styles.dart';

class EditProfileScreen extends StatefulWidget {
  //Named route for main.dart
  static const routeName = '/editProfile';

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
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
    //Navigate and wait for the result (the image path)
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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Text("Edit Profile", style: AppStyles.pageTitleStyle),

                SizedBox(height: 30),

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
                            ? Icon(Icons.person, size: 60, color: Colors.grey[600])
                            : null,
                      ),

                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppStyles.primaryColor, // Uses your Green/Theme color
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Icon(Icons.edit, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 40),

                _buildTextField("Full Name", _nameController),
                SizedBox(height: 15),
                _buildTextField("University", _uniController),
                SizedBox(height: 15),


                TextField(
                  controller: _bioController,
                  maxLines: 3,
                  decoration: InputDecoration(

                    hintText: "Tell others about your interests and what clubs you love!",
                    hintMaxLines: 3,

                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),

                SizedBox(height: 40),


                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {

                      Navigator.pop(context);
                    },
                    style: AppStyles.primaryButtonStyle.copyWith(
                      backgroundColor: WidgetStateProperty.all(Colors.blue),
                    ),
                    child: Text("Save Changes"),
                  ),
                ),

                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper for cleaner code
  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      ),
    );
  }
}