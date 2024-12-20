import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hedeyati/app/login-signup/login_page.dart';

class ProtectedRoute extends StatelessWidget {
  final Widget child;
  const ProtectedRoute({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, state) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return  LoginPage();
      }
      return child;
    });
  }
}
