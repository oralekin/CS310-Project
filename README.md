# UniConnect

## Overview
UniConnect is a Flutter-based mobile application that centralizes university club events into a single platform. It enables students to discover, follow, and participate in campus events such as workshops, seminars, and festivals through a structured and user-friendly interface.

The application is built using Firebase for backend services and Provider for state management, ensuring scalability, maintainability, and real-world applicability.

---

## Features
- Email and password authentication (sign up, sign in, password reset)
- Event creation, approval, and browsing
- Join and leave events with attendee count tracking
- User profile management with profile photo update flow
- Basic admin approval workflow
- In-app chat functionality
- Responsive UI with named-route navigation

---

## Tech Stack
- **Flutter (Dart)**
- **Firebase**
  - Authentication
  - Cloud Firestore
- **Provider** for state management

---

## Setup
1. Install Flutter **3.3+** and Dart **3.3+**
2. Install dependencies:
   ```bash
   flutter pub get
Configure Firebase:

Run flutterfire configure to generate firebase_options.dart

Android: place google-services.json in android/app

iOS: place GoogleService-Info.plist in ios/Runner

Enable Authentication and Cloud Firestore in Firebase Console

Publish Firestore rules defined in firestore.rules

Firebase App Check (Development)
If Firebase Authentication is blocked on Android due to App Check or reCAPTCHA restrictions:

Obtain the debug token from runtime logs

Add the token under Firebase Console → App Check → Debug tokens

Restart the application

```bash
flutter run
```
Testing
Run all tests using:


flutter test
Included Tests
Application launch smoke test (widget_test.dart)

ExpandableText widget behavior test (expandable_text_test.dart)

All tests pass successfully.

Known Limitations
Joined-events stream performs per-event lookups and may not scale well for large datasets

Event lists currently do not support pagination

Team
Name	Student ID	Role
Mehmet Sefa Ciftci	32496	Project Coordinator
Bahar Küçüközer	32148	Documentation & Submission
Ekin Oral	29421	Integration & Repository
Melisa Ece Yıldırım	32053	Testing & Quality Assurance
Deniz Çolak	32342	Learning & Research
