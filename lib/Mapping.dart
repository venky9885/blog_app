/*import 'package:flutter/material.dart';
import 'LoginRegisterPage.dart';
import 'HomePage.dart';
import 'Authentication.dart';

class MappingPage extends StatefulWidget {
  final AuthImplementation auth;
  MappingPage({this.auth});
  //@override
  _MappingPageState createState() => _MappingPageState();
  //state<StatefulWidget> createState() {

  //}
}

enum AuthStatus {
  signedIn,
  notSignedIn,
}

class _MappingPageState extends State<MappingPage> {
  AuthStatus authStatus = AuthStatus.notSignedIn;
  //AuthStatus _authStatus = AuthStatus.signedIn;

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then(firebaseUserId) {
      setState(() {
          authStatus = firebaseUserId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });

  }

  Widget build(BuildContext context) {
    switch(authStatus) {
      case: AuthStatus.notSignedIn;
      return new LoginRegisterPage(
        auth: widget.auth,
        onSigned
      );
    }
    return Container();
  }
}*/
