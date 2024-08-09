import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthHelper {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Sign in with Google
  Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      return googleUser;
    } catch (error) {
      print('Google Sign-In error: $error');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }

  // Get current user
  Future<GoogleSignInAccount?> getCurrentUser() async {
    return _googleSignIn.currentUser;
  }
}
