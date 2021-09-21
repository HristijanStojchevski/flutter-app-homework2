import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homework2/model/activity.dart';
import 'package:homework2/services/firebaseService.dart';
import 'package:homework2/widgets/pages/userDashboard/dashActivityTile.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Activity> postedActivities = <Activity>[
    Activity("title", 'description', 'helper', false, false, 'category',GeoPoint(0,0), 'creator'),
    Activity("title1", 'description', 'helper1', true, false, 'Construction',GeoPoint(0,0), 'creator'),
    Activity("title2", 'description', 'helper2', true, false, 'category',GeoPoint(0,0), 'creator1'),
    Activity("title3", 'description', 'helper2', false, false, 'category',GeoPoint(0,0), 'creator2'),
    Activity("title4", 'description', 'helper2', false, false, 'category',GeoPoint(0,0), 'creator2'),
    Activity("title5", 'description', 'helper3', false, true, 'category',GeoPoint(0,0), 'creator2'),
    Activity("title6", 'description', 'helper4', false, true, 'category',GeoPoint(0,0), 'creator3'),
  ];

  List<Activity> enrolledActivities = <Activity>[
    Activity("title", 'description', 'helper', true, false, 'category',GeoPoint(0,0), 'creator'),
    Activity("title1", 'description', 'helper1', true, true, 'category',GeoPoint(0,0), 'creator'),
    Activity("title2", 'description', 'helper2', true, false, 'category',GeoPoint(0,0), 'creator1'),
    Activity("title3", 'description', 'helper2', true, false, 'category',GeoPoint(0,0), 'creator2'),
    Activity("title4", 'description', 'helper2', true, true, 'category',GeoPoint(0,0), 'creator2'),
    Activity("title5", 'description', 'helper3', true, true, 'category',GeoPoint(0,0), 'creator2'),
    Activity("title6", 'description', 'helper4', true, true, 'category',GeoPoint(0,0), 'creator3'),
  ];

  List<Activity> finished = <Activity>[];

  void extractFinished(){
    List<Activity> enrolledTemp = [];
    for(Activity activity in enrolledActivities){
      if(activity.finished){
        finished.add(activity);
      }
      else{
        enrolledTemp.add(activity);
      }
    }
    setState(() {
      enrolledActivities = enrolledTemp;
    });
  }


  @override
  void initState() {
    super.initState();
    print('CALL INIT STATE');
    extractFinished();
  }

  @override
  Widget build(BuildContext context) {

    postedActivities[0].isNearby = true;
    postedActivities[0].distance = 570.43;
    postedActivities[0].description = 'And what a description this is !';

    return Column(
      children: [
        // User info card with a button to go to enrolled jobs
        Card(
          clipBehavior: Clip.antiAlias,
          elevation: 0,
          margin: EdgeInsets.all(5.0),
          child: Container(
            padding: EdgeInsets.fromLTRB(40, 20, 20, 0),
            child: Column(
              children: [
                // Name Surname
                Container(
                  child: Row(
                    children: [
                      Text("Name Surname", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.8, wordSpacing: 4),)
                    ],
                  ),
                ),
                SizedBox(height: 5,),
                // Button to enrolled widget
                Row(
                  children: [
                    Text("Finished: \$15", style: TextStyle(fontSize: 16),),
                    SizedBox(width: 20,),
                    MaterialButton(
                      color: Colors.lightBlue[400],
                      onPressed: () {
                        // TODO open enrolledJobs list widget
                        Navigator.pushNamed(context, '/finishedJobs', arguments: {
                          'finishedActivities': finished
                        });
                      }, // TODO think of a catchy word
                      child: Row( children: [
                        Text("CHECK ALL  ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                        Icon(Icons.arrow_forward_rounded, color: Colors.white,)
                      ])
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        // Created / Posted jobs
        Card(
          clipBehavior: Clip.antiAlias,
          elevation: 0,
          margin: EdgeInsets.all(5.0),
          child: Container(
            height: 205,
            color: Colors.lightBlue[400],
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('POSTED', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2),),
                ),
                // Posted jobs list
                Container(
                  height: 170,
                  child: ListView.builder(
                      itemCount: postedActivities.length,
                      itemBuilder: (context, index) {
                        return DashActivityTile(activity: postedActivities[index],);
                      }),
                )
              ],
            ),
          ),
        ),
        // Enrolled jobs
        Card(
          clipBehavior: Clip.antiAlias,
          child: Container(
            height: 205,
            color: Colors.lightBlue[400],
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('ENROLLED', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2),),
                ),
                // Enrolled jobs list
                Container(
                  height: 170,
                  child: ListView.builder(
                      itemCount: enrolledActivities.length,
                      itemBuilder: (context, index) {
                        return DashActivityTile(activity: enrolledActivities[index],);
                      }),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}