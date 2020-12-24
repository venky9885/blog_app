import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:quizapp2/helper/constants.dart';
import 'auth.dart';

//import 'package:quizapp2/services/database.dart';
//import 'package:quizapp2/widget/widget.dart';
//import '../views/home.dart';
class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text("Sign up "),
        actions: <Widget>[
          FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('Sign in'),
              onPressed: () {
                widget.toggleView();
              })
        ],
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
              key: _formKey,
              child: Column(
                //key: _formKey,
                children: <Widget>[
                  SizedBox(height: 20.0),
                  TextFormField(
                    validator: (val) => val.isEmpty ? 'Enter an email' : null,
                    onChanged: (val) {
                      setState(() => email = val);
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    obscureText: true,
                    validator: (val) =>
                        val.length < 6 ? 'Enter Password Correctly' : null,
                    onChanged: (val) {
                      setState(() => password = val);
                    },
                  ),
                  SizedBox(height: 20.0),
                  RaisedButton(
                      color: Colors.pink,
                      child: Text(
                        'Register',
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          dynamic result = await _auth
                              .registerWithEmailAndPassword(email, password);
                          if (result == null) {
                            setState(() => error = 'Please Enter Correctly');
                          }
                        }
                      }),
                  SizedBox(height: 12.0),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 14.0),
                  )
                ],
              ))),
    );
  }
}
