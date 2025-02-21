import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
  authenticating,
  error,
}

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthStatus _status = AuthStatus.initial;
  String? _error;

  AuthStatus get status => _status;
  String? get error => _error;
  User? get currentUser => _auth.currentUser;
  bool get isAuthenticated => _auth.currentUser != null;

  AuthService() {
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        _status = AuthStatus.unauthenticated;
      } else {
        _status = AuthStatus.authenticated;
      }
      notifyListeners();
    });
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _status = AuthStatus.authenticating;
      _error = null;
      notifyListeners();

      await _auth.signInWithEmailAndPassword(email: email, password: password);

      return true;
    } on FirebaseAuthException catch (e) {
      _status = AuthStatus.error;
      _error = _getMessageFromErrorCode(e.code);
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(String email, String password) async {
    try {
      _status = AuthStatus.authenticating;
      _error = null;
      notifyListeners();

      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return true;
    } on FirebaseAuthException catch (e) {
      _status = AuthStatus.error;
      _error = _getMessageFromErrorCode(e.code);
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  String _getMessageFromErrorCode(String errorCode) {
    switch (errorCode) {
      case "invalid-email":
        return "Invalid email address.";
      case "wrong-password":
        return "Wrong password.";
      case "user-not-found":
        return "User not found.";
      case "user-disabled":
        return "User account has been disabled.";
      case "too-many-requests":
        return "Too many attempts. Please try again later.";
      case "operation-not-allowed":
        return "Email & Password sign-in is not enabled.";
      case "email-already-in-use":
        return "An account already exists with this email.";
      case "weak-password":
        return "Please enter a stronger password.";
      default:
        return "An error occurred. Please try again.";
    }
  }
}
