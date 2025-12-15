import 'package:flutter/material.dart';
import '../utils/app_styles.dart';

class InvitedFriend {
  final String email;
  final String status;

  InvitedFriend({required this.email, required this.status});
}

class InviteFriendScreen extends StatefulWidget {
  static const routeName = "/inviteFriend";

  const InviteFriendScreen({super.key});

  @override
  State<InviteFriendScreen> createState() => _InviteFriendScreenState();
}

class _InviteFriendScreenState extends State<InviteFriendScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  final List<InvitedFriend> _invitedFriends = [
    InvitedFriend(email: "ali@sabanciuniv.edu", status: "Pending"),
    InvitedFriend(email: "saima@sabanciuniv.edu", status: "Accepted"),
  ];

  void _sendInvite() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _invitedFriends.insert(
          0,
          InvitedFriend(
            email: _emailController.text.trim(),
            status: "Sent",
          ),
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Invitation sent to ${_emailController.text}"),
          duration: const Duration(seconds: 2),
        ),
      );

      _emailController.clear();
    }
  }

  void _removeInvite(int index) {
    setState(() {
      _invitedFriends.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// 🔹 APP BAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "Invite a Friend",
          style: AppStyles.pageTitleStyle.copyWith(color: Colors.black),
        ),
      ),

      /// 🔹 BODY
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Invite your friends to join UniConnect by entering their email address.",
              style: TextStyle(color: Colors.black54),
            ),

            const SizedBox(height: 24),

            /// EMAIL FORM
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Friend’s email address",
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email cannot be empty";
                  }
                  if (!value.contains('@')) {
                    return "Enter a valid email";
                  }
                  return null;
                },
              ),
            ),

            const SizedBox(height: 16),

            /// SEND BUTTON
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _sendInvite,
                style: AppStyles.primaryButtonStyle,
                child: const Text("Send Invitation"),
              ),
            ),

            const SizedBox(height: 32),
            const Divider(),

            const SizedBox(height: 12),
            const Text(
              "Previously Invited",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 12),

            /// INVITED LIST
            Expanded(
              child: _invitedFriends.isEmpty
                  ? Center(
                child: Text(
                  "No invitations yet",
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              )
                  : ListView.builder(
                itemCount: _invitedFriends.length,
                itemBuilder: (context, index) {
                  final friend = _invitedFriends[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blueGrey,
                          child: Text(
                            friend.email[0].toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                friend.email,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                friend.status,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: friend.status == "Accepted"
                                      ? Colors.green
                                      : Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.red),
                          onPressed: () => _removeInvite(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
