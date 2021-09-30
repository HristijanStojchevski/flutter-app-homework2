import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homework2/model/activity.dart';
import 'package:homework2/services/firebaseService.dart';
import 'package:homework2/shared/activityCard.dart';
import 'package:homework2/shared/utilities.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class Explorer extends StatefulWidget{
  @override
  _ExplorerState createState() => _ExplorerState();
}

class _ExplorerState extends State<Explorer> {

  final UtilityFunctions utilities = UtilityFunctions();
  Location locationTracker = Location();
  GeoPoint _userLocation = GeoPoint(0, 0);

  List<Activity> filteredActivities = [];

  bool needsFiltering = false;

  bool filtered = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserLocation();
  }



  @override
  Widget build(BuildContext context) {
    final activities = Provider.of<List<Activity>>(context);
    // if(!ListEquality().equals(activities, localActivities)){
    //   if(updateActivities){
    //     setState(() {
    //       screens = [
    //         Explorer(),
    //         MapSearch(activities: activities,),
    //         Dashboard()
    //       ];
    //       localActivities = activities;
    //       currentScreen = screens[currentTab];
    //       updateActivities = false;
    //     });
    //   }
    //   else {
    //     // show update snackbar
    //   }
    // }
    for(Activity activity in activities){
      double distance = utilities.calculateDistance(_userLocation, activity.location);
      activity.distance = distance;

      if (distance <= 20) {
        activity.isNearby = true;
      }
    }
    activities.sort((a, b) => a.distance.compareTo(b.distance));
    if(!filtered) {
      filteredActivities = activities;
    }
    if(needsFiltering){
      // filter
      needsFiltering = false;
      setState(() {});
    }
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
        Expanded(
          child: Align(
            alignment: FractionalOffset.bottomCenter,
            child: ListView.builder(
              itemCount: filteredActivities.length,
              itemBuilder: (context, index) {
                return ActivityCard(activity: filteredActivities[index],refreshPage: () {}, isEditable: false,);
              }),
          ),
          ),
      ],
    );
  }

  Future<void> getUserLocation({initial = false}) async {
    LocationData currLocation = await locationTracker.getLocation();
    if(currLocation.longitude != null) {
      _userLocation =  GeoPoint(currLocation.latitude!.toDouble(), currLocation.longitude!.toDouble());
    }
    setState(() {

    });
  }
}
