import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math' as math;
class UtilityFunctions {
  double _earthOrbitalCircleRadius = 6371;

  double calculateDistance(GeoPoint p1, GeoPoint p2){
    double alpha = 90 - p1.latitude;
    double betha = 90 - p2.latitude;
    double longitutes = p1.longitude - p2.longitude;
    double radAlpha = alpha * math.pi / 180;
    double radBetha = betha * math.pi / 180;
    double radLongitudes = longitutes * math.pi / 180;
    double acosineExpr = (math.cos(radAlpha) * math.cos(radBetha)) + (math.sin(radAlpha) * math.sin(radBetha) * math.cos(radLongitudes));
    double distance = _earthOrbitalCircleRadius * math.acos(acosineExpr);
    return (distance * 100).roundToDouble() / 100;
  }
}