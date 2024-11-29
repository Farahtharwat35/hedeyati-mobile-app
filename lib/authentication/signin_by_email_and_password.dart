import 'package:firebase_auth/firebase_auth.dart';
import 'package:hedeyati/response.dart';

class SignInByEmailAndPassword {
  static Future<Response> login(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return Response(
        success: true,
        message: 'User logged in successfully',
        data: credential.user,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return Response(
          success: false,
          message: 'No user found for that email.',
        );
      } else if (e.code == 'wrong-password') {
        return Response(
          success: false,
          message: 'Wrong password provided for that user.',
        );
      } else {
        return Response(
          success: false,
          message: e.code,
        );
      }
    }
  }
}