import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:homework2/model/activity.dart';
import 'package:homework2/services/firebaseService.dart';
import 'package:homework2/widgets/activityManagement/editAcitivty.dart';
import 'package:homework2/widgets/activityManagement/newActivity.dart';
import 'package:provider/provider.dart';

class ActivityManagement extends StatefulWidget {
  final Function updateActivity;
  final bool isNew;
  final Activity activity;
  const ActivityManagement({Key? key, required this.updateActivity, required this.isNew, required this.activity}) : super(key: key);

  @override
  _ActivityManagementState createState() => _ActivityManagementState();
}

class _ActivityManagementState extends State<ActivityManagement> {
  bool _isNew = false;
  bool isValid = false;

  Activity activity = Activity(title: 'title', description: 'description', location: GeoPoint(0,0), category: '', networkPhotos: [], audioRecording: '');

  bool connected = false;

  // Future<void> checkConnectivity() async {
  //   try {
  //     final List<InternetAddress> result = await InternetAddress.lookup('google.com');
  //     if( result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //       setState(() => connected = true);
  //       return;
  //     }
  //     setState(() => connected = false);
  //   } catch (connErr) {
  //     print('Problem with google server connection'); // TODO connect with my server
  //     print(connErr.toString());
  //     setState(() => connected = false);
  //   }
  // }

  void validateForm(GlobalKey<FormState> validationToken){
    if (validationToken.currentState!.validate()) {
      setState(() => isValid = true);
    }
  }

  void updateActivity(Activity activity){
    setState(() => this.activity = activity);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isNew = widget.isNew;
    activity = widget.activity;
    if(activity.category.isNotEmpty && activity.title.isNotEmpty && activity.description.length > 5){
      isValid = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final snackBar = SnackBar(backgroundColor: Colors.redAccent, padding: EdgeInsets.fromLTRB(90, 2, 0, 2), content: Text('You have empty required fields!', style: TextStyle(fontSize: 16,)));
    final fireErrSnack = SnackBar(backgroundColor: Colors.redAccent, padding: EdgeInsets.fromLTRB(90, 2, 0, 2), content: Text('There was a problem with saving this activity! Try again', style: TextStyle(fontSize: 16,)));
    final noInternetSnack = SnackBar(backgroundColor: Colors.redAccent, padding: EdgeInsets.fromLTRB(90, 2, 0, 2), content: Text('You have no internet! Connect then try again.', style: TextStyle(fontSize: 16,)));
    // final connection = Provider.of<ConnectivityResult>(context);

    // if(!connected){
    //   checkConnectivity();
    // }

    return Scaffold(
      // TODO on navigation back read activity page from firebase
      appBar: AppBar(
        title: Text(_isNew ? 'Create new Activity' : 'Edit Activity'),
        backgroundColor: Colors.lightBlue[400],
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.save, color: Colors.white, size: 30,),
            onPressed: () async {
              if(isValid){
                // TODO save images to cloud storage
                // if(connection == ConnectivityResult.none){
                //   ScaffoldMessenger.of(context).clearSnackBars();
                //   ScaffoldMessenger.of(context).showSnackBar(noInternetSnack);
                //   setState(() => connected = false);
                //   return;
                // }
                // if(!connected){
                //   ScaffoldMessenger.of(context).clearSnackBars();
                //   ScaffoldMessenger.of(context).showSnackBar(noInternetSnack);
                //   return;
                // }
                FirebaseService firebaseService = FirebaseService();
                bool success = await firebaseService.saveActivity(activity, _isNew);
                if(success) {
                  if(!_isNew) {
                    widget.updateActivity();
                  }
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(fireErrSnack);
                }
              }
              else {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            label: Text('SAVE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),),
          )
        ],
      ),
      body: _isNew ? NewActivity(validate: validateForm, updateActivity: updateActivity) : EditActivity(validate: validateForm, updateActivity: updateActivity, activity: activity),
    );
  }
}
