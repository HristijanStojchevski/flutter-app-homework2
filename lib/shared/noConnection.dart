import 'package:flutter/material.dart';

class NoConnection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Image.asset('assets/images/NoInternetSurfer.jpg', fit: BoxFit.cover, height: double.infinity,)
      ),
    );
  }
}
