import 'package:flutter/material.dart';

// MODELS
import 'models/event_store.dart';

// USER SCREENS
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/password_reset_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/my_events_screen.dart';
import 'screens/invite_friend_screen.dart';
import 'screens/search_filter_screen.dart';

// PROFILE PHOTO FLOW
import 'screens/change_profile_screen.dart';
import 'screens/gallery_preview_screen.dart';
import 'screens/camera_preview_screen.dart';

// ADMIN
import 'screens/admin_login.dart';
import 'screens/dashboard_screen.dart';
import 'screens/create_event.dart';

// CHAT
import 'screens/chat_screen.dart';

// EVENT DETAILS
import 'screens/event_details_screen.dart';

void main() {
  runApp(const UniConnectApp());
}

class UniConnectApp extends StatelessWidget {
  const UniConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "UniConnect",
      initialRoute: SplashScreen.routeName,

      routes: {
        // USER FLOW
        SplashScreen.routeName: (ctx) => const SplashScreen(),
        LoginScreen.routeName: (ctx) => const LoginScreen(),
        RegisterScreen.routeName: (ctx) => const RegisterScreen(),
        PasswordResetScreen.routeName: (ctx) => const PasswordResetScreen(),
        UserHomeScreen.routeName: (ctx) => const UserHomeScreen(),
        ProfileScreen.routeName: (ctx) => const ProfileScreen(),
        EditProfileScreen.routeName: (ctx) => EditProfileScreen(),
        MyEventsScreen.routeName: (ctx) => const MyEventsScreen(),
        InviteFriendScreen.routeName: (ctx) => const InviteFriendScreen(),
        SearchFilterScreen.routeName: (ctx) => const SearchFilterScreen(),

        // PROFILE → Photo change
        ChangeProfileScreen.routeName: (ctx) => const ChangeProfileScreen(),
        CameraPreviewScreen.routeName: (ctx) => const CameraPreviewScreen(),

        // ADMIN
        AdminLoginScreen.routeName: (ctx) => const AdminLoginScreen(),
        AdminHomeScreen.routeName: (ctx) => const AdminHomeScreen(),
        CreateEventScreen.routeName: (ctx) => const CreateEventScreen(),

        // CHAT
        ChatScreen.routeName: (ctx) => const ChatScreen(),
      },

      // 🔑 ARGUMENT GEREKTİREN SAYFALAR
      onGenerateRoute: (settings) {
        // EVENT DETAILS (EventModel gönderiyoruz)
        if (settings.name == EventDetailsScreen.routeName) {
          final event = settings.arguments as EventModel;
          return MaterialPageRoute(
            builder: (_) => EventDetailsScreen(event: event),
          );
        }

        // GALLERY PREVIEW (String path gönderiyoruz)
        if (settings.name == GalleryPreviewScreen.routeName) {
          final imagePath = settings.arguments as String;
          return MaterialPageRoute(
            builder: (_) => GalleryPreviewScreen(imagePath: imagePath),
          );
        }

        return null;
      },
    );
  }
}
