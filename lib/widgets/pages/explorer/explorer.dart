import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homework2/model/activity.dart';
import 'package:homework2/services/firebaseService.dart';
import 'package:homework2/shared/activityCard.dart';

class Explorer extends StatefulWidget {
  List<Activity> activities;

  Explorer({required this.activities});

  @override
  _ExplorerState createState() => _ExplorerState();
}

class _ExplorerState extends State<Explorer> {

  // TODO : On update on activities offer a refresh on the page
  List<Activity> activities = <Activity>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    activities = widget.activities;
  }

  @override
  Widget build(BuildContext context) {
    activities[0].isNearby = true;
    activities[0].distance = 570.43;
    activities[0].description = 'And what a description this is !';


    return Column(
      children: [
        Container(
          color: Colors.blue,
          padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('SEARCH BAR'),
              SizedBox(width: 20,),
              Icon(Icons.arrow_drop_down_circle_outlined, size: 30,)
            ],
          ),
        ),
        Container(
          height: 498,
          padding: EdgeInsets.symmetric(vertical: 10),
          child: ListView.builder(
            itemCount: activities.length,
            itemBuilder: (context, index) {
              return ActivityCard(activity: activities[index],);
            }),
          ),
      ],
    );
  }
}
