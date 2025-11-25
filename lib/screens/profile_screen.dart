import 'package:flutter/material.dart';
import 'edit_profile_screen.dart';
import 'my_events_screen.dart';
import 'invite_friend_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = "/profile";

  const ProfileScreen({super.key});

  Widget buildMenu({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = Colors.black,
  }) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12)),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          alignment: Alignment.centerLeft,
        ),
        onPressed: onTap,
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ),
            const Text(">", style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),


      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.black),
        ),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 55,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),

            const SizedBox(height: 15),

            const Text(
              "Name Surname",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "student@sabanciuniv.edu",
                style: TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(height: 35),

            // MENU BOX
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 6,
                    color: Colors.black.withOpacity(0.07),
                  ),
                ],
              ),
              child: Column(
                children: [
                  buildMenu(
                    icon: Icons.edit,
                    label: "Edit Profile",
                    onTap: () {
                      Navigator.pushNamed(context, EditProfileScreen.routeName);
                    },
                  ),
                  buildMenu(
                    icon: Icons.bookmark,
                    label: "My Events",
                    onTap: () {
                      Navigator.pushNamed(context, MyEventsScreen.routeName);
                    },
                  ),
                  buildMenu(
                    icon: Icons.person_add,
                    label: "Invite a Friend",
                    onTap: () {
                      Navigator.pushNamed(context, InviteFriendScreen.routeName);
                    },
                  ),
                  buildMenu(
                    icon: Icons.logout,
                    color: Colors.red,
                    label: "Logout",
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        LoginScreen.routeName,
                            (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
