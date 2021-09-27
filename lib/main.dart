import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:homework2/model/activity.dart';
import 'package:homework2/model/user.dart';
import 'package:homework2/services/firebaseService.dart';
import 'package:homework2/shared/loading.dart';
import 'package:homework2/widgets/activityManagement/manageActivity.dart';
import 'package:homework2/widgets/activityPage/activityPage.dart';
import 'package:homework2/widgets/pages/userDashboard/postedActivities.dart';
import 'package:homework2/widgets/wrapper.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Firebase

    return MultiProvider(providers: [
      StreamProvider<ConnectivityResult>.value(
          value: Connectivity().onConnectivityChanged,
          initialData: ConnectivityResult.none),
      StreamProvider<AppUser?>.value(
        value: AuthService().authChanges,
        initialData: null
      ),
      StreamProvider<List<Activity>>.value(value: FirebaseService().activities, initialData: []),
    ],
    child: MaterialApp(
      initialRoute: '/home',
      routes: {
        '/home': (context) => Wrapper(),
        // '/': (context) => LoadingScreen(),
        '/activity': (context) => ActivityPage(),
        // '/postedActivities': (context) => PostedList(),
        // '/newJob': (context) => ActivityManagement()
      },
    ),
    );
  }
}
