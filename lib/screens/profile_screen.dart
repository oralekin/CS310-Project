import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'edit_profile_screen.dart';
import 'my_events_screen.dart';
import 'invite_friend_screen.dart';
import 'login_screen.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = "/profile";

  const ProfileScreen({super.key});

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = Colors.black,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 14),
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
            const Icon(Icons.chevron_right, color: Colors.black45),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      /// 🔹 APP BAR
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
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),

      /// 🔹 BODY
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),

            /// PROFILE AVATAR
            const CircleAvatar(
              radius: 55,
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 14),

            /// NAME
            const Text(
              "Name Surname",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            /// EMAIL BADGE
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "student@sabanciuniv.edu",
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),

            const SizedBox(height: 35),

            /// MENU CARD
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8,
                    color: Colors.black.withOpacity(0.06),
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.edit,
                    label: "Edit Profile",
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        EditProfileScreen.routeName,
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.bookmark_border,
                    label: "My Events",
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        MyEventsScreen.routeName,
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.person_add_alt_1,
                    label: "Invite a Friend",
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        InviteFriendScreen.routeName,
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.logout,
                    label: "Logout",
                    color: Colors.red,
                    onTap: () async {
                      await context.read<AuthProvider>().signOut();
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        LoginScreen.routeName,
                            (_) => false,
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
