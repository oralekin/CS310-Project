import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

// MODELS
import 'models/event_store.dart';

// PROVIDERS
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';


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
import 'screens/joined_events_screen.dart';
import 'screens/admin_event_approval_screen.dart';

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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// 🔥 FIREBASE INIT (FlutterFire CLI uyumlu)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const UniConnectRoot());
}

/// 🔑 ROOT: Provider burada, HER ŞEYİN ÜSTÜNDE
class UniConnectRoot extends StatelessWidget {
  const UniConnectRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const UniConnectApp(),
    );

  }
}

class UniConnectApp extends StatelessWidget {
  const UniConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "UniConnect",
          theme: themeProvider.isDarkMode
              ? ThemeData.dark()
              : ThemeData.light(),

          home: const SplashScreen(),

          routes: {
            // USER FLOW
            SplashScreen.routeName: (ctx) => const SplashScreen(),
            LoginScreen.routeName: (ctx) => const LoginScreen(),
            RegisterScreen.routeName: (ctx) => const RegisterScreen(),
            PasswordResetScreen.routeName: (ctx) =>
            const PasswordResetScreen(),
            UserHomeScreen.routeName: (ctx) => const UserHomeScreen(),
            ProfileScreen.routeName: (ctx) => const ProfileScreen(),
            EditProfileScreen.routeName: (ctx) => EditProfileScreen(),
            MyEventsScreen.routeName: (ctx) => const MyEventsScreen(),
            InviteFriendScreen.routeName: (ctx) =>
            const InviteFriendScreen(),
            SearchFilterScreen.routeName: (ctx) =>
            const SearchFilterScreen(),
            JoinedEventsScreen.routeName: (ctx) => const JoinedEventsScreen(),
            AdminEventApprovalScreen.routeName: (ctx) =>
            const AdminEventApprovalScreen(),



            // PROFILE → Photo change
            ChangeProfileScreen.routeName: (ctx) =>
            const ChangeProfileScreen(),
            CameraPreviewScreen.routeName: (ctx) =>
            const CameraPreviewScreen(),

            // ADMIN
            AdminLoginScreen.routeName: (ctx) =>
            const AdminLoginScreen(),
            AdminHomeScreen.routeName: (ctx) =>
            const AdminHomeScreen(),
            CreateEventScreen.routeName: (ctx) =>
            const CreateEventScreen(),

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
                builder: (_) =>
                    GalleryPreviewScreen(imagePath: imagePath),
              );
            }

            return null;
          },
        );
      },
    );

  }
}
