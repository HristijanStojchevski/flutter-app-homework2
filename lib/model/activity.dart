import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  String? activityId;
  String title = "";
  String description = "";
  GeoPoint location = GeoPoint(0, 0);
  DocumentReference? creator;
  String category = "";
  List<File> photos = [];
  List<String> networkPhotos = [];
  String audioRecording = '';
  String audioSrc = '';
  double distance = 0.0;
  bool isNearby = false;


  Activity(
      {this.activityId,
      required this.title,
      required this.description,
      required this.location,
      this.creator,
      required this.category,
      required this.networkPhotos,
      required this.audioRecording});

  Activity.from(Activity activity){
    if(activity.activityId != null) this.activityId = activity.activityId;
    this.title = activity.title;
    this.description = activity.description;
    this.location = activity.location;
    this.creator = activity.creator;
    this.category = activity.category;
    this.photos = activity.photos;
    this.networkPhotos = activity.networkPhotos;
    this.audioRecording = activity.audioRecording;
    this.audioSrc = activity.audioSrc;
    this.distance = activity.distance;
    this.isNearby = activity.isNearby;
  }

  bool equalsMap(Activity otherActivity){
    return this.title == otherActivity.title && this.description == otherActivity.description &&
        this.location.latitude == otherActivity.location.latitude && this.location.longitude == otherActivity.location.longitude;
  }
}