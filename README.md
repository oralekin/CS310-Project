# 🎓 UniConnect

> A Flutter-based mobile application that centralizes university club events into a single, structured platform.

---

## 📌 Overview
**UniConnect** is a mobile application developed to bring together university club events such as workshops, seminars, and festivals under one platform.  
It eliminates fragmented communication channels and enables students to easily discover, follow, and participate in campus events.

The application leverages **Firebase** for backend services and **Provider** for state management, ensuring a scalable and maintainable architecture.

---

## ✨ Features
- 🔐 Email & password authentication (sign up, sign in, password reset)
- 📅 Event creation, approval, and browsing
- ➕ Join / leave events with attendee count tracking
- 👤 User profile management with profile photo update flow
- 🛂 Basic admin approval workflow
- 💬 In-app chat functionality
- 📱 Fully responsive UI with named-route navigation

---

## 🛠 Tech Stack
- **Flutter (Dart)**
- **Firebase**
  - Authentication  
  - Cloud Firestore
- **Provider** (State Management)

---

## ⚙️ Setup & Installation

### Prerequisites
- Flutter **3.3+**
- Dart **3.3+**

### Installation
```bash
flutter pub get
```
Firebase Configuration

Run:

flutterfire configure


to generate firebase_options.dart

Add platform configuration files:

Android: android/app/google-services.json

iOS: ios/Runner/GoogleService-Info.plist

Enable Authentication and Cloud Firestore in Firebase Console

Publish Firestore rules from firestore.rules

🔐 Firebase App Check (Development)

If Firebase Authentication is blocked on Android due to App Check or reCAPTCHA:

Retrieve the debug token from runtime logs

Add the token in
Firebase Console → App Check → Debug tokens

Restart the application

▶️ Run the Application
flutter run

🧪 Testing

Run all tests with:

flutter test

Included Tests

Widget Smoke Test
Verifies that the application launches and the root MaterialApp builds correctly.

ExpandableText Widget Test
Ensures correct expand / collapse behavior based on text length.

All tests pass successfully.

| Name                | Student ID | Role                        |
| ------------------- | ---------- | --------------------------- |
| Mehmet Sefa Ciftci  | 32496      | Project Coordinator         |
| Bahar Küçüközer     | 32148      | Documentation & Submission  |
| Ekin Oral           | 29421      | Integration & Repository    |
| Melisa Ece Yıldırım | 32053      | Testing & Quality Assurance |
| Deniz Çolak         | 32342      | Learning & Research         |
