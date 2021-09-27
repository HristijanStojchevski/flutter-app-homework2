import 'package:flutter/material.dart';
import 'package:homework2/services/firebaseService.dart';
import 'package:homework2/widgets/auth/register.dart';
import 'package:homework2/widgets/auth/sign_in.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool needsSignIn = true;
  PushNotificationService notificationService = PushNotificationService();

  void toggleView () {
    setState( () => needsSignIn = !needsSignIn);
  }

  void authComplete (AuthService authService) async {
    await notificationService.saveDeviceToken(authService);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: needsSignIn ? SignIn(showRegisterScreen: toggleView, authComplete: authComplete) : Register(showSignInScreen: toggleView, authComplete: authComplete),
    );
  }
}
