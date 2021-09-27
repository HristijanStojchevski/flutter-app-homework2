import 'package:flutter/material.dart';
import 'package:homework2/model/activity.dart';
import 'package:homework2/services/firebaseService.dart';
import 'package:homework2/shared/activityCard.dart';
import 'package:homework2/shared/loading.dart';

class PostedList extends StatefulWidget {
  final List<Activity> postedActivities;
  final bool isLoading;
  final Function refreshPage;

  PostedList({required this.postedActivities, required this.isLoading, required this.refreshPage});

  @override
  _PostedListState createState() => _PostedListState();
}

class _PostedListState extends State<PostedList> {
  final AuthService _auth = AuthService();

  List<Activity> postedActivities = [];
  bool isLoading = false;

  void refreshScreen(){
    widget.refreshPage();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    postedActivities = widget.postedActivities;
    isLoading = widget.isLoading;
  }

  @override
  Widget build(BuildContext context) {

    // Map<String, dynamic> data = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    // setState(() {
    //   postedActivities = data['postedActivities'];
    //   isLoading = data['isLoading'];
    // });

    return Scaffold(
        backgroundColor: Colors.lightBlue[200],
        appBar: AppBar(
          title: Text('Created activities'),
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
        body: isLoading ? LoadingScreen() : ListView.builder(
            itemCount: postedActivities.length,
            itemBuilder: (context, index) {
              return ActivityCard(activity: postedActivities[index], isFinished: true, refreshPage: refreshScreen);
            })
    );
  }
}
