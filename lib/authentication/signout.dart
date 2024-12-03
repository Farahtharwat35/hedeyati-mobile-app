import 'package:firebase_auth/firebase_auth.dart';
import '../helpers/response.dart';

class Signout {
  Future<Response> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return Response(
        success: true,
        message: 'User logged out successfully',
      );
    } catch (e) {
      return Response(
        success: false,
        message: 'Something went wrong',
      );
    }
  }
}