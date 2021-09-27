import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:homework2/model/activity.dart';
import 'package:homework2/model/user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final appUser = AppUser();

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _userCollection = FirebaseFirestore.instance.collection('users');

  // create user obj from FirebaseUser
  AppUser? _userFromFirebaseUser(User? user){
    if(user != null){
      // TODO Let the app know which user is logged in, get user id and connect it with user at firestore
      appUser.uid = user.uid;
      appUser.isLoggedIn = true;
      DocumentReference userRef = _userCollection.doc(user.uid);
      try {
        userRef.get().then((docRef) {
          if (docRef.exists) {
            final Map<String, dynamic> docData = docRef.data() as Map<
                String,
                dynamic>;
            appUser.name = docData['name'] ?? 'FirebaseError';
            appUser.email = docData['email'] ?? 'FirebaseError';
            appUser.activities = List.from(docData['activities'] ?? []);
            // TODO construct Role from string, remove conditional here
            if (docData['role'] == 'Explorer') {
              appUser.role = Role.Explorer;
            } else {
              appUser.role = Role.Activist;
            }
            appUser.surname = docData['surname'] ?? 'FirebaseError';
            appUser.username = docData['username'] ?? 'FirebaseError';
          }
        });
      } catch (err) {
        print(err.toString());
        return null;
      }
      return appUser;
    }
    return null;
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
  Future<AppUser?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? firUser = result.user;
      // TODO get token and refresh token to update user session when not logged out.
      return _userFromFirebaseUser(firUser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }


  // TODO register with email and password
  Future<AppUser?> registerWithEmailAndPassword(String email, String password, String name, String surname) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? firUser = result.user;
      // TODO ADD FIELDS FOR USER   firUserDoc.set  deviceToken , postedJobs, enrolledJobs, name (email), surname (if provided later), username (email)

      Map<String, dynamic> userData = {'uid': firUser!.uid, 'name': name, 'surname': surname, 'username': email, 'role': Role.Explorer.name,
        'activities': [], 'devices': []};
      await setUserData(userData);
      return _userFromFirebaseUser(firUser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }


  Future signOut() async {
    try{
      await _auth.signOut();
      // TODO delete token from this device
      removeDeviceToken();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('userEmail');
      await prefs.remove('encryptedPass');
      return;
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

  Future addDeviceToken() async {
    String uid = appUser.uid!;
    return await _userCollection.doc(uid).update({'devices': FieldValue.arrayUnion([appUser.deviceToken])});
  }

  Future removeDeviceToken() async {
    String uid = appUser.uid!;
    return await _userCollection.doc(uid).update({'devices': FieldValue.arrayRemove([appUser.deviceToken])});
  }

  Future upgradeUserToActivist() async {
    String uid = appUser.uid!;
    return await _userCollection.doc(uid).update({'role': Role.Activist.name});
  }

}

class FirebaseService {

  // collection Ref
  final CollectionReference activityCollection = FirebaseFirestore.instance.collection('activities');
  final Reference firebaseStorage = FirebaseStorage.instance.ref('ActivityRoom');
  
  // Get all jobs
  // TODO List<Activity>
  List<Activity> _activityListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc){
      return Activity(activityId: doc.id, title: doc['title'] ?? '', description: doc['description'] ?? '', location: doc['location'] ?? GeoPoint(0, 0), category: doc['category'] ?? '',
          networkPhotos: List.from(doc['photos']), audioRecording: doc['audioRecording'] ?? '', creator: doc['creator'] ?? '');
    }).toList();
  }

  Stream<List<Activity>> get activities {
    String userId = appUser.uid ?? 'undefined';
    if( userId == 'undefined'){
      return activityCollection.snapshots().map(_activityListFromSnapshot);
    }
    DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(userId);
    return activityCollection.where('creator', isNotEqualTo: userRef).snapshots().map(_activityListFromSnapshot);
  }

  Stream<List<Activity>> get postedActivities {
    String userId = appUser.uid ?? 'undefined';
    if( userId == 'undefined'){
      return activityCollection.snapshots().map(_activityListFromSnapshot);
    }
    DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(userId);
    return activityCollection.where('creator', isEqualTo: userRef).snapshots().map(_activityListFromSnapshot);
  }

  Future<Activity?> _activityFromActivityRef(DocumentReference activityRef) async {
    try {
      Activity activity = Activity(title: 'title', description: 'description', location: GeoPoint(0,0),
          category: 'category', networkPhotos: [], audioRecording: '');
      await activityRef.get().then((DocumentSnapshot docRef) {
        if (docRef.exists) {
          final docData = docRef.data() as Map<String, dynamic>;
          activity.title = docData['title'] ?? '';
          activity.description = docData['description'] ?? 'FirebaseError';
          activity.activityId = docRef.id;
          activity.networkPhotos = List.from(docData['photos']);
          activity.creator = docData['creator'] ?? '';
          activity.audioRecording = docData['audioRecording'] ?? '';
          activity.category = docData['category'] ?? '';
          activity.location = docData['location'] ?? '';
        }
      });
      return activity;
    } catch (err) {
      print(err.toString());
      return null;
    }
  }

  // Load activity
  Future<Activity?> loadActivity(String? activityId) async{
    if(activityId != null && activityId.isNotEmpty) {
      DocumentReference activityRef = activityCollection.doc(activityId);
      Activity? activity = await _activityFromActivityRef(activityRef);
      return activity;
    }
    else return null;
  }

  Future<void> deleteFromStorage(Reference document) async {
    try {
      // TODO Delete every file inside the reference in order to delete the full folder
      ListResult listResult = await document.listAll();
      print(listResult.items);

    } on FirebaseException catch(storageErr){
      // if the error is from firebase storage then garbage collection
      print("Error while deleting storage files");
      print(storageErr);
    }
  }

  Future<bool> deleteActivity(String? activityId) async {
    try {
      if(activityId != null) {
        // WORK AROUND FOR FLUTTER FIREBASE UNABLE TO DELETE FOLDER
        DocumentReference activityRef = activityCollection.doc(activityId);
        await FirebaseFirestore.instance.collection('users').doc(appUser.uid).update({'activities': FieldValue.arrayRemove([activityRef])});
        final activitySnap = await activityRef.get();
        if(activitySnap.exists) {
          final data = activitySnap.data() as Map<String, dynamic>;
          List<String> imgUrls = List.from(data['photos']);
          String audioRecordingUrl = data['audioRecording'] ?? '';
          if(audioRecordingUrl.isNotEmpty) {
            imgUrls.add(audioRecordingUrl);
          }
          for (String fileUrl in imgUrls) {
            try {
              await FirebaseStorage.instance.refFromURL(fileUrl).delete();
            } on FirebaseException catch (err) {
              print('Err with deleting the file with this url : \n $fileUrl');
              print(err);
            }
          }
        }
        await activityCollection.doc(activityId).delete(); // TODO .whenComplete(() => deleteFromStorage(activityId));
        return true;
      }
      else return false;
    } on FirebaseException catch(firErr){
      print('deletion unsuccessful !');
      print(firErr.toString());
      return false;
    }
  }

  Future<bool> saveAudio(String audioSrc, String? activityId) async {
    if(activityId != null && activityId.isNotEmpty) {
      Reference correctFolder = firebaseStorage.child('activities').child(
          activityId).child('audio');
      try {
        Directory docDirectory = await getApplicationDocumentsDirectory();
        audioSrc = '${docDirectory.path}/$audioSrc';
        File audioFile = File(audioSrc);
        await correctFolder.putFile(audioFile).whenComplete(() async {
          String downloadUrl = await correctFolder.getDownloadURL();
          await activityCollection.doc(activityId).update({ 'audioRecording': downloadUrl });
        });
      } on FirebaseException catch (firErr) {
        print(firErr.toString());
        return false;
      }
      return true;
    }
    return false;
  }

  Future<void> deleteImageFromStorage(String imageUrl) async {
    try {
      await FirebaseStorage.instance.refFromURL(imageUrl).delete();
    } on FirebaseException catch (delErr) {
      print('Error on deletion image with url: \n$imageUrl');
      print(delErr.toString());
      // TODO notify server to activate garbage collection on firebase storage
      // User will still have correct photos, but in the folder there might be asset that is with no use.
    }
  }

  // Activity images
  Future<void> saveImageUrls(String? activityId, {List<String> saveImages = const [], bool isNew = true}) async {
    if(activityId != null && activityId.isNotEmpty) {
      print("Activity ID:  " + activityId);
      Reference correctFolder = firebaseStorage.child('activities').child(
          activityId).child('images');
      ListResult images = await correctFolder.listAll();
      List<String> urls = [];
      List<String> names = [];
      int imgCounter = 1;
      // If is a new activity or if there were deleted photos from network photos
      if(isNew || saveImages.length != images.items.length) {
        images.items.forEach((image) async {
          String downloadUrl = await image.getDownloadURL();
          if (!isNew && !saveImages.contains(downloadUrl)) {
            await deleteImageFromStorage(downloadUrl);
          } else {
            urls.add(downloadUrl);
            names.add(image.name);
          }
          if (imgCounter++ == images.items.length) {
            await activityCollection.doc(activityId).update(
                { 'photos': urls});
          }
        });
      }
    }
  }

  // Save photos to firebase storage
  Future<bool> savePhotos(List<File> photos, String? activityId) async {
    if(activityId != null && activityId.isNotEmpty) {
      Reference correctFolder = firebaseStorage.child('activities').child(
          activityId).child('images');
      ListResult images = await correctFolder.listAll();
      int numLastImg = images.items.length > 0 ? int.parse(images.items.last.name.characters.last) : 0; // TODO fix with different approach. Potential oversizing of image names. It will just add numbers !
      for (int photoIndex = 1; photoIndex<=photos.length; photoIndex++) {
        try {
          await correctFolder.child('image${numLastImg + photoIndex}').putFile(photos[photoIndex-1]);
        } on FirebaseException catch (firErr) {
          print(firErr.toString());
          return false;
        }
      }
      return true;
    }
    return false;
  }

  Future<bool> saveActivity(Activity activity, bool _isNew) async {
    try {
      Map<String, dynamic> activityData = {
        'title': activity.title, 'description': activity.description,
        'location': activity.location, 'category': activity.category,
        'creator': activity.creator
      };
      if (_isNew) {
        String creator = appUser.uid ?? 'undefined';
        DocumentReference userRef = FirebaseFirestore.instance.collection(
            'users').doc(creator);
        activityData['creator'] = userRef;
        DocumentReference activityRef = await activityCollection.add(
            activityData);
        activity.activityId = activityRef.id;
        if (creator != 'undefined') {
          FirebaseFirestore.instance.collection('users').doc(creator).update(
              {'activities': FieldValue.arrayUnion([activityRef])});
        }
      } else {
        await saveImageUrls(activity.activityId, saveImages: activity.networkPhotos, isNew: _isNew);
      }
      // TODO potential update. Needs late provider for thrown error to notify user that the changes were not saved
      // await saveImageUrls(activity.activityId, saveImgUrls: activity.networkPhotos, isNew: _isNew, saveImages: activity.photos);
      if (activity.photos.isNotEmpty) {
        bool savedPhotos = await savePhotos(
            activity.photos, activity.activityId);
        if (!savedPhotos) {
          if(_isNew) {
            await activityCollection.doc(activity.activityId).delete();
            FirebaseFirestore.instance.collection('users')
                .doc(appUser.uid)
                .update(
                {'activities': FieldValue.arrayRemove([activity.activityId])});
          }
          return false;
        }
        await saveImageUrls(activity.activityId);
      }
      if (activity.audioSrc.isNotEmpty) {
        bool savedAudio = await saveAudio(activity.audioSrc, activity.activityId);
        if (!savedAudio) {
          if(_isNew) {
            await activityCollection.doc(activity.activityId).delete();
            FirebaseFirestore.instance.collection('users')
                .doc(appUser.uid)
                .update(
                {'activities': FieldValue.arrayRemove([activity.activityId])});
          }
          return false;
        }
      } else if (activity.audioRecording.isEmpty){
        activityData['audioRecording'] = '';
      }
      await activityCollection.doc(activity.activityId).update(activityData);
      return true;
    } catch (Err) {
      print('Probably no internet');
      print(Err.toString());
      return false;
    }
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  print(message.notification!.title);
  print(message.notification!.body);
  return;
}

class PushNotificationService {
  PushNotificationService._privateConstructor();

  static final PushNotificationService _pushNotificationService = PushNotificationService._privateConstructor();

  factory PushNotificationService(){
    return _pushNotificationService;
  }

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final AndroidNotificationChannel channel = AndroidNotificationChannel('activity_room_channel', 'Activity room notification', 'The channel is used for important notifications', importance: Importance.high);
  final firebaseVapidID = 'BDy07XHMSs9ZQkjk3M2tpqYxf2WUQKhjD2T1Ywa2ax6CyzXVwWept7X8zg8mqWicXBMwQczUCKbvb99NW_bdi9o';

  String deviceToken = '';

  Future<bool> hasPermissions() async {
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
        return false;
      }
      else {
        return true;
      }
    }
    return true;
  }

  Future<void> saveDeviceToken(AuthService authService) async {
    if( await hasPermissions()){
      final devToken = await firebaseMessaging.getToken(vapidKey: firebaseVapidID);
      if(devToken != null){
        this.deviceToken = devToken;
        appUser.deviceToken = this.deviceToken;
        authService.addDeviceToken();
      }
    }
  }

  Future init() async {
    if (Platform.isIOS) {
      if(! await hasPermissions()) return;
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true, // Required to display a heads up notification
        badge: true,
        sound: true,
      );
      // this.deviceToken = await firebaseMessaging.getAPNSToken(); //TODO check this easier method
    } else {

      final initializationSettings = AndroidInitializationSettings(
          '@mipmap/ic_launcher');
      await flutterLocalNotificationsPlugin.initialize(
          InitializationSettings(android: initializationSettings));
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }

    // print('device token :');
    // print(this.deviceToken);
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
        // TODO apple notification
      }
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

}