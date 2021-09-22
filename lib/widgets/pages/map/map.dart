import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homework2/model/activity.dart';
import 'package:homework2/services/firebaseService.dart';
import 'package:location/location.dart';

class MapSearch extends StatefulWidget {
  List<Activity> activities;

  MapSearch({required this.activities});

  @override
  _MapSearchState createState() => _MapSearchState();
}

class _MapSearchState extends State<MapSearch> {

  void removePointAfterEnrollment(Activity enrolled){
    // TODO v2
    // activityLocationMarkers.remove(enrolled);
  }
  Location locationTracker = Location();
  LatLng _userLocation = LatLng(0, 0);

  CameraPosition _initCamPos = CameraPosition(
      target: LatLng(41.99503, 21.43205),
      zoom: 14
    );

  late GoogleMapController _googleMapController;

  @override void dispose() {
    // TODO: implement dispose
    super.dispose();
    _googleMapController.dispose();
  }
  bool firstMapInit = true;

  Set<Marker> activityLocationMarkers = <Marker>{};

  @override void initState(){
    // TODO: implement initState
    super.initState();
    for(Activity activity in widget.activities){
      // change title with id
      Marker marker = Marker( markerId: MarkerId(activity.title),
        infoWindow: InfoWindow(title: activity.title, snippet: 'Click here for info', onTap: () {
          // TODO logic for activity page navigation
          showDialog(context: context, builder: (context) {
            return OpenActivityDialog(activity: activity,);
          });
        }),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: LatLng(activity.location.latitude, activity.location.longitude)
      );
      activityLocationMarkers.add(marker);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        initialCameraPosition: _initCamPos,
        onMapCreated: (controller) {
          _googleMapController = controller;
          if(firstMapInit){
            getUserLocation(initial: true);
            firstMapInit = false;
          }
        },
        // List of job locations
        markers: activityLocationMarkers,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
        child: FloatingActionButton(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.black,
          onPressed: () {
            // TODO navigate to user location
            getUserLocation();
          },
          child: Icon(Icons.location_history_outlined, size: 30)
        ),
      ),
    );
  }

  void getUserLocation({initial = false}) async {
    Marker userMarker = Marker(markerId: MarkerId('user'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
        position: _userLocation);
    LocationData currLocation = await locationTracker.getLocation();
    if(currLocation.longitude != null) {
      _userLocation = LatLng(currLocation.latitude!.toDouble(), currLocation.longitude!.toDouble());
    }
    if(initial) {
      // Add user marker
      activityLocationMarkers.add(Marker(markerId: MarkerId('user'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
          position: _userLocation));
    }
    else {
      activityLocationMarkers.remove(userMarker);
      activityLocationMarkers.add(Marker(markerId: MarkerId('user'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
          position: _userLocation));
    }
    _googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: _userLocation, zoom: await _googleMapController.getZoomLevel())));
    // TODO v2 update location on change
    setState(() {

    });
  }
}

class OpenActivityDialog extends StatelessWidget {
  Activity activity;

  OpenActivityDialog({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration( shape: BoxShape.rectangle, color: Colors.white, borderRadius: BorderRadius.circular(20),
        boxShadow: [ BoxShadow(color: Colors.blue, offset: Offset(0, 1), blurRadius: 6)]),
        height: 200,
        width: 400,
        child: Column(children: [
          Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0), child: Text(activity.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.4),)),
          Container(padding: EdgeInsets.fromLTRB(0, 20, 0, 0), height: 115, width: 200, child: Text(activity.description, maxLines: 8, overflow: TextOverflow.fade,),),
          MaterialButton(shape: RoundedRectangleBorder(),color: Colors.blueAccent,onPressed: (){
            // TODO open activity page
            Navigator.pushNamed(context, '/activity', arguments: {
              // 'activityRef': activity.ref,
              'activity': activity
            });
          }, child: Text('Open activity page', style: TextStyle(fontWeight: FontWeight.bold),),)
        ],),
      ),
    );
  }
}
