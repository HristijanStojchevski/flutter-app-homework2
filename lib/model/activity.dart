import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  String title = "";
  String description = "";
  final GeoPoint location;
  final String creator;
  String helper = "";
  bool enrolled = false;
  bool finished = false;
  String category = "";
  double distance = 0.0;
  bool isNearby = false;

  Activity(String title,String description, String helper, bool enrolled, bool finished, String category, this.location, this.creator){
    this.title = title;
    this.description = description;
    this.helper = helper;
    this.enrolled = enrolled;
    this.finished = finished;
    this.category = category;
  }

}