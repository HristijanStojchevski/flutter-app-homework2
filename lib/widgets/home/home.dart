
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homework2/model/activity.dart';
import 'package:homework2/model/user.dart';
import 'package:homework2/services/firebaseService.dart';
import 'package:homework2/shared/activityCard.dart';
import 'package:homework2/widgets/activityManagement/manageActivity.dart';
import 'package:homework2/widgets/pages/explorer/explorer.dart';
import 'package:homework2/widgets/pages/map/map.dart';
import 'package:homework2/widgets/pages/userDashboard/dashboard.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  // TODO : On update on activities offer a refresh on the page
  List<Activity> localActivities = [];
  int currentTab = 0;
  bool updateActivities = true;
  final List<String> screenNames = [ 'Explorer', 'Map Search', 'Dashboard'];

  final PageStorageBucket bucket = PageStorageBucket();
  
  List<Widget> screens = [];
  late Widget currentScreen;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentScreen = Explorer();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    screens = [
      Explorer(),
      MapSearch(),
      Dashboard()
    ];

    // Provider
    return StreamProvider<List<Activity>>.value(
      value: FirebaseService().activities,
      initialData: [],
      child: Scaffold(
          // TODO enable this but find a solution for the MAP directions
          // extendBody: true,
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
            color: Colors.transparent,
            height: 75.0,
            width: 75.0,
            child: currentTab == 0 && appUser.role == Role.Activist ?
            FloatingActionButton(
                elevation: 5,
                child: Icon(Icons.add, size: 35,),
                onPressed: () {
                  // TODO open new item form
                  Activity activity = Activity(title: 'title', description: 'description', location: GeoPoint(0,0), category: '', networkPhotos: [], audioRecording: '');
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ActivityManagement(updateActivity: (){}, isNew: true,activity: activity)),);
                  // Navigator.pushNamed(context, '/newJob', arguments: {
                  //   'createNewJob': true,
                  //   'activity': null
                  // });
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
        )
    );
  }
}
