import 'package:expenzes/utils/exceptions/app_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthServices {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  //google sign in method
  Future<void> googleSignInMethord() async {
    try {
      final GoogleSignInAccount? account = await googleSignIn.signIn();

      if (account == null) {
        return;
      }

      final GoogleSignInAuthentication authAcc = await account.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: authAcc.accessToken,
        idToken: authAcc.idToken,
      );

      await firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      print(exceptions(e.code));
    } catch (error) {
      print(error.toString());
    }
  }
}
