import 'package:firebase_auth/firebase_auth.dart';
import '../helpers/response.dart';
import '../helpers/user_data_uniqueness_validator.dart';


class SignUpByEmailAndPassword {
  static Future<Response> signUp({required String email, required String password}) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Response(
        success: true,
        message: 'User created successfully',
        data: credential.user,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return Response(
          success: false,
          message: 'The password provided is too weak.',
        );
      } else if (e.code == 'email-already-in-use') {
        return Response(
          success: false,
          message: 'The account already exists for that email.',
        );
    } else {
      return Response(
        success: false,
        message: e.code,
      );
    } }
    catch (e) {
      return Response(
        success: false,
        message: 'Something went wrong',
      );
    }
  }
}