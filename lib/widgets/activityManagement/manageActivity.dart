import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:homework2/model/activity.dart';
import 'package:homework2/services/firebaseService.dart';
import 'package:homework2/widgets/activityManagement/editAcitivty.dart';
import 'package:homework2/widgets/activityManagement/newActivity.dart';

class ActivityManagement extends StatefulWidget {
  @override
  _ActivityManagementState createState() => _ActivityManagementState();
}

class _ActivityManagementState extends State<ActivityManagement> {
  bool isNew = false;

  bool isValid = false;

  Activity activity = Activity('title', 'description', 'helper', false, false, 'category', GeoPoint(0,0), 'creator');


  void validateForm(GlobalKey<FormState> validationToken){
    if (validationToken.currentState!.validate()) {
      setState(() {
        isValid = true;
      });
    }
  }

  bool initBuild = true;

  @override
  Widget build(BuildContext context) {
    final snackBar = SnackBar(backgroundColor: Colors.redAccent, padding: EdgeInsets.fromLTRB(90, 2, 0, 2), content: Text('You have empty required fields!', style: TextStyle(fontSize: 16,)));

    if(initBuild) {
      Map<String, dynamic> data = ModalRoute
          .of(context)!
          .settings
          .arguments as Map<String, dynamic>;
      setState(() {
        isNew = data['createNewJob'];
        activity = data['activity'] == null ? activity : data['activity'];
      });
      initBuild = false;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isNew ? 'Create new Activity' : 'Edit Activity'),
        backgroundColor: Colors.lightBlue[400],
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.save, color: Colors.white, size: 30,),
            onPressed: () async {
              // TODO savechanges
              // activate form validation from here
              if(isValid){
                Navigator.pop(context);
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
      body: isNew ? NewActivity(validate: validateForm,) : EditActivity(validate: validateForm,name: activity.title, category: activity.category, description: activity.description, imgSrc: [], audioSrc: '',),
    );
  }
}
