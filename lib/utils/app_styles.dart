import 'package:flutter/material.dart';

class AppStyles {
  static const Color primaryColor = Color(0xFF4CAF50); // Green from wireframe
  static const Color secondaryColor = Colors.grey;

  // Custom Header Text Style (for the "Above Center" titles)
  static const TextStyle pageTitleStyle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    color: Colors.black87,
  );

  //Square with Small Corners Button Style
  static ButtonStyle flatButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.grey[400],
    foregroundColor: Colors.white,
    padding: EdgeInsets.symmetric(vertical: 15),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8), //Small rounded corners
    ),
    minimumSize: Size(double.infinity, 50),
    elevation: 0,
  );

  static ButtonStyle primaryButtonStyle = flatButtonStyle.copyWith(
    backgroundColor: MaterialStateProperty.all(primaryColor),
  );
}