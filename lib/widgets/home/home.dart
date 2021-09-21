
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homework2/model/activity.dart';
import 'package:homework2/services/firebaseService.dart';
import 'package:homework2/shared/activityCard.dart';
import 'package:homework2/widgets/pages/explorer/explorer.dart';
import 'package:homework2/widgets/pages/map/map.dart';
import 'package:homework2/widgets/pages/userDashboard/dashboard.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  // TODO : On update on activities offer a refresh on the page
  List<Activity> activities = <Activity>[
    Activity("title", 'description', 'helper', false, false, 'category',GeoPoint(41.99585,21.43144), 'creator'),
    Activity("Main activity", 'We need a huge description in order to satisfy the needs of the UI.\n Present this to the costumer in a nice and honorable fashion. \n New line behavior and a lot of extra unnecessary text that no one will read.', 'helper1', false, false, 'Construction',GeoPoint(41.99514,21.43221), 'creator'),
    Activity("title2", 'description', 'helper2', false, false, 'category',GeoPoint(41.99684,21.42367), 'creator1'),
    Activity("title3", 'description', 'helper2', false, false, 'category',GeoPoint(0,0), 'creator2'),
    Activity("title4", 'description', 'helper2', false, false, 'category',GeoPoint(0,0), 'creator2'),
    Activity("title5", 'description', 'helper3', false, false, 'category',GeoPoint(0,0), 'creator2'),
    Activity("title6", 'description', 'helper4', false, false, 'category',GeoPoint(0,0), 'creator3'),
    Activity("title7", 'description', 'helper5', false, false, 'category',GeoPoint(0,0), 'creator4'),
    Activity("title8", 'description', 'helper6', false, false, 'category',GeoPoint(0,0), 'creator4'),
    Activity("title8", 'description', 'helper6', false, false, 'category',GeoPoint(0,0), 'creator4'),
  ];

  int currentTab = 0;

  final List<String> screenNames = [ 'Explorer', 'Map Search', 'Dashboard'];

  final PageStorageBucket bucket = PageStorageBucket();

  List<Widget> screens = [];
  late Widget currentScreen;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentScreen = Explorer(activities: activities,);
  }

  @override
  Widget build(BuildContext context) {

    screens = [
      Explorer(activities: activities,),
      MapSearch(activities: activities,),
      Dashboard()
    ];
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(screenNames[currentTab]),
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
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      floatingActionButton: Container(
          height: 75.0,
          width: 75.0,
          child: currentTab == 0 ?
          FloatingActionButton(
            elevation: 5,
            child: Icon(Icons.add, size: 35,),
            onPressed: () {
            // TODO open new item form
              Navigator.pushNamed(context, '/newJob', arguments: {
                'createNewJob': true,
                'activity': null
              });
            }
          ) :
          FloatingActionButton(
            elevation: 20,
            child: Icon(Icons.explore, size: 60,),
            onPressed: () {
              setState(() {
                currentScreen = screens[0];
                currentTab = 0;
              });
            }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.lightBlue[400],
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MaterialButton(
                  minWidth: screenWidth/2 - 40,
                  onPressed: () {
                    setState(() {
                      currentScreen = screens[1];
                      currentTab = 1;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon( Icons.map, color: currentTab == 1 ? Colors.white : Colors.blueAccent[400], size: 35),
                      Text("Map", style: TextStyle(color: Colors.white, fontSize: 14, letterSpacing: 1.0))
                    ],
                  ),
              ),
              SizedBox(width: 60),
              MaterialButton(
                  minWidth: screenWidth/2 - 40,
                  onPressed: () {
                    setState(() {
                      currentScreen = screens[2];
                      currentTab = 2;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon( Icons.dashboard, color: currentTab == 2 ? Colors.white : Colors.blueAccent[400], size: 35),
                      Text("Dashboard", style: TextStyle(color: Colors.white, fontSize: 14, letterSpacing: 1.0),)
                    ],
                  ),
              )
            ]
          ),
        ),
      ),
    );
  }
}
