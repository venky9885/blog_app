import 'package:flutter/material.dart';
import 'signin.dart';
import 'signup.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggleView: toggleView);
    } else {
      return Register(toggleView: toggleView);
    }
  }
}

/*import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthImplementation {
  Future<String> SignIn(String email, String password);
  Future<String> SignUp(String email, String password);
  Future<String> getCurrentUser();
  Future<void> SignOut();
}

class Auth implements AuthImplementation {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> SignIn(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.uid;
  }

  Future<String> SignUp(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return user.uid;
  }

  Future<String> getCurrentUser() {
    //FirebaseUser
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.uid;
  }

  Future<void> SignOut() {
    _firebaseAuth.signOut();
  }
}
*/
