import 'package:flutter/material.dart';
import 'package:uniconnect/helpers/routes.dart';

void main() {
  runApp(const UniConnect());
}

class UniConnect extends StatelessWidget {
  const UniConnect({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UniConnect',
      debugShowCheckedModeBanner: false,

      
      initialRoute: "/",

      // Normal named routes
      routes: routes,

    
      onGenerateRoute: (settings) {
        if (settings.name == "/chat") {
          return MaterialPageRoute(
            builder: (_) => const ChatScreenWrapper(), 
            settings: settings,
          );
        }
        return null;
      },
    );
  }
}

class ChatScreenWrapper extends StatelessWidget {
  const ChatScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return const ChatScreen();
  }
}
