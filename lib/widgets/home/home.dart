
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homework2/services/firebaseService.dart';
import 'package:homework2/widgets/home/tabbar.dart';
import 'package:homework2/widgets/pages/explorer/explorer.dart';
import 'package:homework2/widgets/pages/map/map.dart';
import 'package:homework2/widgets/pages/userDashboard/dashboard.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  int currentTab = 0;
  final List<Widget> screens = [
    Explorer(),
    MapSearch(),
    Dashboard()
  ];

  final List<String> screenNames = [ 'Explorer', 'MapSearch', 'Dashboard'];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = Explorer();

  @override
  Widget build(BuildContext context) {

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
            child: Icon(Icons.add, size: 35,),
            onPressed: () {
              // TODO open new item form
            }
          ) :
          FloatingActionButton(
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
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MaterialButton(
                  minWidth: screenWidth/2,
                  onPressed: () {
                    setState(() {
                      currentScreen = screens[1];
                      currentTab = 1;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon( Icons.map, color: currentTab == 1 ? Colors.blue : Colors.grey),
                      Text("Map")
                    ],
                  ),
              ),
              MaterialButton(
                  minWidth: screenWidth/2,
                  onPressed: () {
                    setState(() {
                      currentScreen = screens[2];
                      currentTab = 2;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon( Icons.dashboard, color: currentTab == 2 ? Colors.blue : Colors.grey),
                      Text("Dashboard")
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
