import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;
  bool _isLoading = true;
  String? _errorMessage;

  late final StreamSubscription<User?> _authSub;

  User? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _authSub = _auth.authStateChanges().listen((user) {
      _user = user;
      _isLoading = false;
      notifyListeners();
    });
  }

  /// LOGIN
  Future<void> signIn(String email, String password) async {
    try {
      _errorMessage = null;
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      _errorMessage = _mapFirebaseError(e);
      notifyListeners();
      throw Exception(_errorMessage);
    }
  }

  /// SIGN UP
  Future<void> signUp(
    String email,
    String password, {
    required String role,
    required String fullName,
    required String university,
    String? clubName,
  }) async {
    try {
      _errorMessage = null;
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = cred.user?.uid;
      if (uid != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set({
          'email': email,
          'role': role,
          'fullName': fullName,
          'university': university,
          if (clubName != null && clubName.isNotEmpty)
            'clubName': clubName,
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    } on FirebaseAuthException catch (e) {
      _errorMessage = _mapFirebaseError(e);
      notifyListeners();
      throw Exception(_errorMessage);
    }
  }

  /// LOGOUT
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// FIREBASE ERROR → USER FRIENDLY MESSAGE
  String _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Bu e-posta adresi ile kayıtlı bir kullanıcı bulunamadı.';
      case 'wrong-password':
        return 'Şifre yanlış. Lütfen tekrar deneyin.';
      case 'email-already-in-use':
        return 'Bu e-posta adresi zaten kullanılıyor.';
      case 'invalid-email':
        return 'Geçersiz e-posta adresi.';
      case 'weak-password':
        return 'Şifre çok zayıf. Daha güçlü bir şifre seçin.';
      case 'network-request-failed':
        return 'İnternet bağlantısı yok. Lütfen bağlantınızı kontrol edin.';
      default:
        return 'Bir hata oluştu. Lütfen tekrar deneyin.';
    }
  }

  @override
  void dispose() {
    _authSub.cancel();
    super.dispose();
  }
}
