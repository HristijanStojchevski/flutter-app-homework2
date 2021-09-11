import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homework2/model/activity.dart';
import 'package:homework2/services/firebaseService.dart';
import 'package:homework2/shared/activityCard.dart';

class Explorer extends StatefulWidget {
  @override
  _ExplorerState createState() => _ExplorerState();
}

class _ExplorerState extends State<Explorer> {

  // TODO : On update on activities offer a refresh on the page

  @override
  Widget build(BuildContext context) {

    List<Activity> activities = <Activity>[
      Activity("title", 'description', 'helper', false, false, 'category',GeoPoint(0,0), 'creator'),
      Activity("title1", 'description', 'helper1', false, false, 'category',GeoPoint(0,0), 'creator'),
      Activity("title2", 'description', 'helper2', false, false, 'category',GeoPoint(0,0), 'creator1'),
      Activity("title3", 'description', 'helper2', false, false, 'category',GeoPoint(0,0), 'creator2'),
      Activity("title4", 'description', 'helper2', false, false, 'category',GeoPoint(0,0), 'creator2'),
      Activity("title5", 'description', 'helper3', false, false, 'category',GeoPoint(0,0), 'creator2'),
      Activity("title6", 'description', 'helper4', false, false, 'category',GeoPoint(0,0), 'creator3'),
      Activity("title7", 'description', 'helper5', false, false, 'category',GeoPoint(0,0), 'creator4'),
      Activity("title8", 'description', 'helper6', false, false, 'category',GeoPoint(0,0), 'creator4'),
      Activity("title8", 'description', 'helper6', false, false, 'category',GeoPoint(0,0), 'creator4'),
    ];

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
