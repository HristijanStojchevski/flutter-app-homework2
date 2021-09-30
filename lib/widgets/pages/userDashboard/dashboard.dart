import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homework2/model/activity.dart';
import 'package:homework2/services/firebaseService.dart';
import 'package:homework2/widgets/pages/userDashboard/dashActivityTile.dart';
import 'package:homework2/widgets/pages/userDashboard/postedActivities.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  List<Activity> postedActivities = [];

  void refreshPage(context){
    setState(() {});
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => PostedList(refreshPage: () {refreshPage(context);},isLoading: false,postedActivities: postedActivities)),);
  }

  void updatePostedActivities(List<Activity> updatedActivities) async {
    setState(() {
      postedActivities = updatedActivities;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final roleChangedSnackBar = SnackBar(content: Text('You have become an ACTIVIST!', style: TextStyle(fontSize: 18),), duration: Duration(seconds: 3),);

    return StreamBuilder<List<Activity>>(
      stream: FirebaseService().postedActivities,
      builder: (context, activitiesSnapshot) {
        bool isLoading = false;
        List<Activity> snapActivities = activitiesSnapshot.data ?? [];
        if(activitiesSnapshot.hasData){
          if(!(ListEquality().equals(snapActivities, postedActivities))){
            updatePostedActivities(snapActivities);
          }
        } else {
          isLoading = true;
        }
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
                          Text("${appUser.name} ${appUser.surname}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.8, wordSpacing: 4),)
                        ],
                      ),
                    ),
                    SizedBox(height: 5,),
                    // Button to enrolled widget
                    Row(
                      children: [
                        Text("Posted activities: ${isLoading ? '' : postedActivities.length}", style: TextStyle(fontSize: 16),),
                        SizedBox(width: 20,),
                        MaterialButton(
                            color: Colors.lightBlue[400],
                            onPressed: () {
                              // TODO open enrolledJobs list widget
                              Navigator.push(context, MaterialPageRoute(builder: (context) => PostedList(refreshPage: () {refreshPage(context);},isLoading: isLoading,postedActivities: postedActivities)),);
                              // Navigator.pushNamed(context, '/postedActivities', arguments: {
                              //   'postedActivities': postedActivities,
                              //   'isLoading': isLoading
                              // });
                            }, // TODO think of a catchy word
                            child: Row( children: [
                              Text(isLoading ? "LOADING..." : "CHECK ALL  ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                              Icon(Icons.arrow_forward_rounded, color: Colors.white,)
                            ])
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Card(
                clipBehavior: Clip.antiAlias,
                elevation: 0,
                margin: EdgeInsets.all(5.0),
                child: Container(
                  color: Colors.lightBlue[200],
                  height: 380,
                  child: Column(
                    children: [
                      Text("USER PROFILE\nimplementation", style: TextStyle(fontSize: 30, color: Colors.blueAccent[600]),),
                      SizedBox(height: 50,),
                      MaterialButton(color: Colors.blue, onPressed: (){
                        AuthService().upgradeUserToActivist();
                        ScaffoldMessenger.of(context).showSnackBar(roleChangedSnackBar);
                        }, child: Text('Become ACTIVIST', style: TextStyle(fontSize: 16,),),)
                    ]
                  ),
                )
            ),
            // Created / Posted jobs
            // Card(
            //   clipBehavior: Clip.antiAlias,
            //   elevation: 0,
            //   margin: EdgeInsets.all(5.0),
            //   child: Container(
            //     height: 205,
            //     color: Colors.lightBlue[400],
            //     child: Column(
            //       children: [
            //         Padding(
            //           padding: const EdgeInsets.all(8.0),
            //           child: Text('POSTED', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2),),
            //         ),
            //         // Posted jobs list
            //         Container(
            //           height: 170,
            //           child: ListView.builder(
            //               itemCount: postedActivities.length,
            //               itemBuilder: (context, index) {
            //                 return DashActivityTile(activity: postedActivities[index],);
            //               }),
            //         )
            //       ],
            //     ),
            //   ),
            // ),
            // // Enrolled jobs
            // Card(
            //   clipBehavior: Clip.antiAlias,
            //   child: Container(
            //     height: 205,
            //     color: Colors.lightBlue[400],
            //     child: Column(
            //       children: [
            //         Padding(
            //           padding: const EdgeInsets.all(8.0),
            //           child: Text('ENROLLED', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2),),
            //         ),
            //         // Enrolled jobs list
            //         Container(
            //           height: 170,
            //           child: ListView.builder(
            //               itemCount: enrolledActivities.length,
            //               itemBuilder: (context, index) {
            //                 return DashActivityTile(activity: enrolledActivities[index],);
            //               }),
            //         )
            //       ],
            //     ),
            //   ),
            // ),
          ],
        );
      }
    );
  }
}