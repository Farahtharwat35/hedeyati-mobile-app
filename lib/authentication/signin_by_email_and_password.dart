import 'package:firebase_auth/firebase_auth.dart';
import '../helpers/response.dart';
import '../helpers/userCredentials.dart';

class SignInByEmailAndPassword {
  static Future<Response> login(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      UserCredentials.saveCredentials(credential.user!.uid);
      print('User logged in successfully + ${UserCredentials.getCredentials()}');
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