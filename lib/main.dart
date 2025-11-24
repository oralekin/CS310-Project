import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/password_reset_screen.dart';
import 'screens/reset_confirmation_screen.dart';
import 'screens/chat_screen.dart';

void main() {
  runApp(const UniConnectApp());
}

class UniConnectApp extends StatelessWidget {
  const UniConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "UniConnect",
      debugShowCheckedModeBanner: false,

      // Initial Screen → Login
      initialRoute: LoginScreen.routeName,

      // Named Routes (PDF Requirement)
      routes: {
        LoginScreen.routeName: (ctx) => const LoginScreen(),
        RegisterScreen.routeName: (ctx) => const RegisterScreen(),
        PasswordResetScreen.routeName: (ctx) => const PasswordResetScreen(),
        ResetConfirmationScreen.routeName: (ctx) =>
            const ResetConfirmationScreen(),

        // ChatScreen special case (uses arguments)
        ChatScreen.routeName: (ctx) => const ChatScreen(),
      },

      // Arguments handling (PDF-approved pattern)
      onGenerateRoute: (settings) {
        if (settings.name == ChatScreen.routeName) {
          final args = settings.arguments;
          return MaterialPageRoute(
            builder: (ctx) => const ChatScreen(),
            settings: RouteSettings(arguments: args),
          );
        }
        return null;
      },
    );
  }
}
