import 'dart:io';

// import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:homework2/model/user.dart';
import 'package:homework2/services/firebaseService.dart';
// import 'package:homework2/shared/noConnection.dart';
import 'package:homework2/widgets/auth/authenticate.dart';
import 'package:homework2/widgets/home/home.dart';
import 'package:provider/provider.dart';


class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  PushNotificationService notificationService = PushNotificationService();

  bool connected = false;

  // Future<void> checkConnectivity() async {
  //   try {
  //     final List<InternetAddress> result = await InternetAddress.lookup('google.com');
  //     if( result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //       setState(() => connected = true);
  //       return;
  //     }
  //     setState(() => connected = false);
  //   } catch (connErr) {
  //     print('Problem with google server connection'); // TODO connect with my server
  //     print(connErr.toString());
  //     setState(() => connected = false);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final appUserChanged = Provider.of<AppUser?>(context);
    // final connection = Provider.of<ConnectivityResult>(context);
    // if(connection == ConnectivityResult.none){
    //   AppUser test = AppUser();
    //   print(test.name);
    //   setState(() => connected = false);
    //   return NoConnection();
    // } else if (!connected){
    //   checkConnectivity();
    //   return NoConnection();
    // }
    if(appUserChanged != null) {
      notificationService.init();
      // TODO if success delete lines
      // appUser.name = appUserChanged.name;
      // appUser.email = appUserChanged.email;
      // appUser.activities = appUserChanged.activities;
      // appUser.role = appUserChanged.role;
      // appUser.surname = appUserChanged.surname;
      // appUser.username = appUserChanged.username;
      return Home();
    }
    else return Authenticate();
  }
}
