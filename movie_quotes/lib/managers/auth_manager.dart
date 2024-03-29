import 'dart:async';
import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AuthManager {
  StreamSubscription<User?>? _authListener;
  User? _user;

  static final AuthManager instance = AuthManager._privateConstructor();

  AuthManager._privateConstructor();

  final Map<UniqueKey, Function> _loginObservers = {};
  final Map<UniqueKey, Function> _logoutObservers = {};

  void startListening() {
    if (_authListener != null) {
      return;
    }
    _authListener =
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
      bool isLoginEvent = user != null && _user == null;
      bool isLogoutEvent = user == null && _user != null;
      _user = user;
      if (isLoginEvent) {
        for (Function observer in _loginObservers.values) {
          observer();
        }
      }
      if (isLogoutEvent) {
        for (Function observer in _logoutObservers.values) {
          observer();
        }
      }
    });
  }

  // obligatory, but unused
  void stopListening() {
    _authListener?.cancel();
    _authListener = null;
  }

  UniqueKey addLoginObserver(Function observer) {
    startListening();
    UniqueKey key = UniqueKey();
    _loginObservers[key] = observer;
    return key;
  }

  UniqueKey addLogoutObserver(Function observer) {
    startListening();
    UniqueKey key = UniqueKey();
    _logoutObservers[key] = observer;
    return key;
  }

  void removeObserver(UniqueKey? key) {
    _loginObservers.remove(key);
    _logoutObservers.remove(key);
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  void createNewUserEmailPassword({
    required BuildContext context,
    required String email,
    required String password,
  }) {
    try {
      final credential = FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _showAuthSnackbar(
            context: context,
            authErrorMessage: "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        _showAuthSnackbar(
            context: context,
            authErrorMessage: "The email provided is already in use.");
      }
    } catch (e) {
      _showAuthSnackbar(
        context: context,
        authErrorMessage: e.toString(),
      );
    }
  }

  void loginExistingUserEmailPassword({
    required BuildContext context,
    required String email,
    required String password,
  }) {
    try {
      final credential = FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showAuthSnackbar(
            context: context,
            authErrorMessage: "Email not associated with an account.");
      } else if (e.code == 'wrong-password') {
        _showAuthSnackbar(
            context: context, authErrorMessage: "Incorrect password provided.");
      }
    } catch (e) {
      _showAuthSnackbar(
        context: context,
        authErrorMessage: e.toString(),
      );
    }
  }

  void _showAuthSnackbar({
    required BuildContext context,
    required String authErrorMessage,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(authErrorMessage),
      ),
    );
  }

  String get email => _user?.email ?? "";
  String get uid => _user?.uid ?? "";
  bool get isSignedIn => _user != null;
}
