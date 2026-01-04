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