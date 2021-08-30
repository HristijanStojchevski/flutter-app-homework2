import 'package:flutter/material.dart';
import 'package:homework2/widgets/auth/register.dart';
import 'package:homework2/widgets/auth/sign_in.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool needsSignIn = true;

  void toggleView () {
    setState( () => needsSignIn = !needsSignIn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: needsSignIn ? SignIn(showRegisterScreen: toggleView) : Register(showSignInScreen: toggleView),
    );
  }
}
