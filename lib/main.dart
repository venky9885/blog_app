import 'package:blog_app/HomePage.dart';

import 'Authentication.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user.dart';
//import 'constants.dart';
//import './views/signin.dart';
import 'auth.dart';

//import 'mai.dart';
//import './quiz/quize/helper/authenticate.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}

class Wrapper extends StatelessWidget {
  @override
  //final user = Provider.of<User>(context);
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user == null) {
      return Authenticate();
    } else {
      return HomePage();
    }
  }
}

/*
void main() {
  runApp(BlogApp());
}

class BlogApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blog App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home: LoginRegisterPage(),
      home: HomePage(),
    );
  }
}
*/
