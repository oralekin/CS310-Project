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
  _InviteFriendScreenState createState() => _InviteFriendScreenState();
}

class _InviteFriendScreenState extends State<InviteFriendScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  List<InvitedFriend> invitedFriends = [
    InvitedFriend(email: "ali@sabanciuniv.edu", status: "Pending"),
    InvitedFriend(email: "saima@sabanciuniv.edu", status: "Accepted"),
  ];

  void _removeFriend(int index) {
    setState(() {
      invitedFriends.removeAt(index);
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        invitedFriends.insert(
          0,
          InvitedFriend(email: emailController.text, status: "Sent"),
        );
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Success"),
          content: Text("Invitation sent to ${emailController.text}"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );

      emailController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Back Button + Title
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Text("Invite a Friend", style: AppStyles.pageTitleStyle),
                ],
              ),

              const SizedBox(height: 40),
              const Text("Invite friends to join an event by entering their email."),
              const SizedBox(height: 20),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Friend's mail address",
                        border: const OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      validator: (value) =>
                          (value == null || !value.contains('@'))
                              ? 'Enter valid email'
                              : null,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _submitForm,
                style: AppStyles.primaryButtonStyle,
                child: const Text("Send Invitation"),
              ),

              const SizedBox(height: 30),
              const Divider(),
              const Text("Previously Invited",
                  style: TextStyle(fontWeight: FontWeight.bold)),

              Expanded(
                child: ListView.builder(
                  itemCount: invitedFriends.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 0,
                      color: Colors.grey[100],
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            'https://ui-avatars.com/api/?name=${invitedFriends[index].email}',
                          ),
                        ),
                        title: Text(invitedFriends[index].email),
                        subtitle: Text(invitedFriends[index].status),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeFriend(index),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
