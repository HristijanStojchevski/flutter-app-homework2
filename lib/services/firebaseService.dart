import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:homework2/model/activity.dart';
import 'package:homework2/model/user.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _userCollection = FirebaseFirestore.instance.collection('users');

  // create user obj from FirebaseUser
  AppUser? _userFromFirebaseUser(User? user) {
    return user != null ? AppUser(uid: user.uid) : null;
  }

  // return a stream of firebase auth changes
  Stream<AppUser?> get authChanges {
    return _auth.userChanges().map(_userFromFirebaseUser);
  }

  // TODO anon sign in
  Future signInAnon() async {
    try{
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (err) {
      print(err.toString());
      return null;
    }
  }
  // TODO email pass login
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? firUser = result.user;
      // TODO get token and refresh token to update user session when not logged out.
      // TODO Let the app know which user is logged in, get user id and connect it with user at firestore
      // Get everything for that user. Save the user in local storage
      return _userFromFirebaseUser(firUser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }


  // TODO register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? firUser = result.user;
      // TODO ADD FIELDS FOR USER   firUserDoc.set  deviceToken , postedJobs, enrolledJobs, name (email), surname (if provided later), username (email)
      Map<String, dynamic> userData = {'name': email, 'surname': 'unknown', 'username': email};

      // Creates user in Firebase Storage if there is none existing with the unique uid
      await setUserData(userData);
      return _userFromFirebaseUser(firUser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }


  Future signOut() async {
    try{
      return await _auth.signOut();
    } catch (err) {
      print(err.toString());
      return null;
    }
  }

  Future updateUserData(Map<String, dynamic> userData) async {
    return await _userCollection.doc(userData['uid']).update(userData);
  }

  Future setUserData(Map<String, dynamic> userData) async {
    return await _userCollection.doc(userData['uid']).set(userData);
  }


}

class FirebaseService {

  // collection Ref
  final CollectionReference jobCollection = FirebaseFirestore.instance.collection('jobCategories');

  // Get all jobs
  // TODO List<Activity>
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  print(message.notification!.title);
  print(message.notification!.body);
  return;
}

class PushNotificationService {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final AndroidNotificationChannel channel = AndroidNotificationChannel('activity_room_channel', 'Activity room notification', 'The channel is used for important notifications', importance: Importance.high);

  String? deviceToken;

  Future init() async {
    if (Platform.isIOS) {
      NotificationSettings settings = await firebaseMessaging
          .getNotificationSettings();
      if (settings.authorizationStatus == AuthorizationStatus.notDetermined) {
        settings = await firebaseMessaging.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,);
      }
      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        print("Alert with directions to enable notifications.");
      }


      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true, // Required to display a heads up notification
        badge: true,
        sound: true,
      );
      this.deviceToken = await firebaseMessaging.getAPNSToken();
    } else {
      this.deviceToken = await firebaseMessaging.getToken(
          vapidKey: 'BDy07XHMSs9ZQkjk3M2tpqYxf2WUQKhjD2T1Ywa2ax6CyzXVwWept7X8zg8mqWicXBMwQczUCKbvb99NW_bdi9o');
      // print('device token :');
      // print(this.deviceToken);
      final initializationSettings = AndroidInitializationSettings(
          '@mipmap/ic_launcher');
      await flutterLocalNotificationsPlugin.initialize(
          InitializationSettings(android: initializationSettings));
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (message.notification != null &&
          message.notification?.android != null) {
        AndroidNotification? android = message.notification?.android;
        RemoteNotification? notification = message.notification;

        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification!.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: android?.smallIcon,
                // other properties...
              ),
            ));
        print('Foreground msg:');
        print(notification.title);
      }
      else
      if (message.notification != null && message.notification?.apple != null) {

      }
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

}