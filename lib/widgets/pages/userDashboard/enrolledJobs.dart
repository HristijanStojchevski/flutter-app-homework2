import 'package:flutter/material.dart';
import 'package:homework2/services/firebaseService.dart';

class EnrolledList extends StatefulWidget {
  @override
  _EnrolledListState createState() => _EnrolledListState();
}

class _EnrolledListState extends State<EnrolledList> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.lightBlue[200],
        appBar: AppBar(
          title: Text('EnrolledList'),
          backgroundColor: Colors.lightBlue[400],
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.person),
              onPressed: () async {
                return await _auth.signOut();
              },
              label: Text('Sign out'),
            )
          ],
        ),
        body: Container(
            child: Text('HELLO'))
    );
  }
}
