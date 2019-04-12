import 'package:firebase_auth/firebase_auth.dart';

Future _handleSignIn(String email, String password) async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseUser user =
      await _auth.signInWithEmailAndPassword(email: email, password: password);
  print("signed in " + user.displayName);
  return user;
}
