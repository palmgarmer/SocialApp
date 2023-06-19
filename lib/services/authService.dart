import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // google sign in
  signInWithGoogle() async {
    // being interactive sign in process
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // obtain auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // keep data on firestore database if user is new
    final userCollection = FirebaseFirestore.instance.collection('Users');
    final userDoc = await userCollection.doc(googleUser.email).get();
    if (!userDoc.exists) {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(googleUser.email)
          .set({
        "email": googleUser.email,
        "username": googleUser.displayName,
        "profilePic": googleUser.photoUrl,
        "bio": "Empty bio",
      });
    }

    // finally sign in user with credential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
