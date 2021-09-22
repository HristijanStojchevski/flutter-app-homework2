import 'package:flutter/material.dart';
import 'package:homework2/model/activity.dart';
import 'package:homework2/services/firebaseService.dart';
import 'package:homework2/shared/activityCard.dart';

class FinishedList extends StatefulWidget {
  @override
  _FinishedListState createState() => _FinishedListState();
}

class _FinishedListState extends State<FinishedList> {
  final AuthService _auth = AuthService();

  List<Activity> finished = [];

  @override
  Widget build(BuildContext context) {

    Map<String, dynamic> data = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    setState(() {
      finished = data['finishedActivities'];
    });

    return Scaffold(
        backgroundColor: Colors.lightBlue[200],
        appBar: AppBar(
          title: Text('FinishedList'),
          backgroundColor: Colors.lightBlue[400],
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.person),
              onPressed: () async {
                Navigator.pop(context);
                return await _auth.signOut();
              },
              label: Text('Sign out'),
            )
          ],
        ),
        body: ListView.builder(
            itemCount: finished.length,
            itemBuilder: (context, index) {
              return ActivityCard(activity: finished[index], isFinished: true,);
            })
    );
  }
}
