import 'package:flutter/material.dart';
import 'invite_friend_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "My Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // USER INFO
            Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.black87,
                  child: Text(
                    "M",
                    style: TextStyle(color: Colors.white, fontSize: 28),
                  ),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Mehmet Kaya",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text("mehmet@sabanciuniv.edu",
                        style: TextStyle(color: Colors.grey)),
                  ],
                )
              ],
            ),

            SizedBox(height: 35),

            const Text(
              "Settings",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 10),

            _profileButton(
              context,
              icon: Icons.event_note,
              label: "My Events",
              route: "/myEvents",
            ),

            _profileButton(
              context,
              icon: Icons.person_add_alt_1,
              label: "Invite a Friend",
              route: "/inviteFriend",
            ),

            _profileButton(
              context,
              icon: Icons.logout,
              label: "Log Out",
              route: "/adminLogin",
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileButton(BuildContext context,
      {required IconData icon, required String label, required String route}) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22),
            SizedBox(width: 10),
            Text(label, style: TextStyle(fontSize: 16)),
            Spacer(),
            Icon(Icons.arrow_forward_ios, size: 16)
          ],
        ),
      ),
    );
  }
}
