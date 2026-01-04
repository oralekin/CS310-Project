# UniConnect

## Overview
UniConnect is a multi-university club event platform for students to discover, share, and join campus events (workshops, seminars, festivals) in one place.

## Key Features
- User authentication (sign up, sign in, password reset)
- Event creation, approval, and browsing
- Event participation (join/leave) with attendee counts
- Profile management with photo update flow
- Basic admin dashboard and approval flow
- In-app chat

## Tech Stack
- Flutter (Dart)
- Firebase: Authentication + Cloud Firestore
- Provider for state management

## Setup
1. Install Flutter 3.3+ (Dart 3.3+). Verify with `flutter --version`.
2. Install dependencies: `flutter pub get`
3. Configure Firebase for your platforms:
   - Run `flutterfire configure` to regenerate `lib/firebase_options.dart`, or replace it with your own config.
   - Android: place `google-services.json` in `android/app`
   - iOS: place `GoogleService-Info.plist` in `ios/Runner`
4. Ensure Firestore and Auth are enabled in the Firebase console.
5. If authentication is blocked on Android, verify:
   - The Firebase Android app uses the same package name as `android/app/build.gradle.kts`.
   - Your debug SHA-1 fingerprint is registered in Firebase Console.
   - App Check / reCAPTCHA settings allow development builds.
6. Firestore rules are defined in `firestore.rules`.

## App Check (Debug Token)
If Firebase Auth is blocked on Android with a Recaptcha/App Check error:
1. Run the app and look for a log line like:
   `Enter this debug secret into the allow list in the Firebase Console for your project: <TOKEN>`
2. Firebase Console → App Check → Debug tokens → Add debug token and paste the value.
3. Restart the app.

## Platform Notes
- iOS/Web/macOS/Windows/Linux require additional Firebase configuration via `flutterfire configure`.
- If a platform is not configured, `firebase_options.dart` will throw an `UnsupportedError`.

## Feedback Fixes
- Asset image and network image usage added (home screen).
- Success AlertDialogs added for register/create/reset flows.
- Responsive layout adjustments using MediaQuery.
- Logout now calls `AuthProvider.signOut()` from profile screen.
- Firestore rules added and published to restrict unauthenticated access.
- Admin approval uses EventStore service (no direct Firestore in UI).
- Firebase options configured for web and windows; App Check debug token flow documented.
- iOS project added with `GoogleService-Info.plist`.
- Removed machine-specific Gradle Java home path.

## Feedback Status
Completed:
- iOS/Web/Windows Firebase configuration added.
- Windows-specific Gradle path removed.
- Image.asset + Image.network usage added.
- Success AlertDialogs added.
- Basic responsiveness via MediaQuery added.
- Logout bug fixed.
- Firestore security rules included.

Remaining:
- Verify App Check/Auth access is unblocked on all test devices.
- Record final demo video and submit final report.

## Run
`flutter run`

## Tests
Run all tests with: `flutter test`

Tests included:
- `test/widget_test.dart`: App launches smoke test (MaterialApp builds).
- `test/expandable_text_test.dart`: ExpandableText hides toggle for short text and toggles for long text.

## Known Limitations
- Joined-events stream performs per-event lookups and may be slow for large datasets.
- No pagination for event lists yet.

## Team
| Name               | Student ID | Role                            |
| :----------------- | ---------- | ------------------------------- |
| Mehmet Sefa Ciftci | 32496      | Project Coordinator             |
| Bahar Kucuk Ozer   | 32148      | Documentation and Submission    |
| Ekin Oral          | 29421      | Integration and Repository      |
| Melisa Ece Yildirim| 32053      | Testing and Quality Assurance   |
| Deniz Colak        | 32342      | Learning and Research           |
