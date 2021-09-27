import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homework2/model/activity.dart';
import 'package:homework2/services/firebaseService.dart';
import 'package:homework2/services/mediaService.dart';
import 'package:homework2/widgets/activityManagement/manageActivity.dart';
import 'package:path_provider/path_provider.dart';

class ActivityPage extends StatefulWidget {
  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  late Activity activity;
  bool firstInit = true;
  bool isEditable = false;
  FirebaseService firebaseService = FirebaseService();
  void refreshPage() async{
    Activity? refreshedActivity = await firebaseService.loadActivity(activity.activityId);
    if(refreshedActivity != null) setState(() => activity = refreshedActivity);
  }

  void saveAudioFromNetwork() async {
    Directory docDirectory = await getApplicationDocumentsDirectory();
    pathToSaveAudio = '${docDirectory.path}/temp_audio.aac';
    final file = File(pathToSaveAudio);
    Reference audioRef = FirebaseStorage.instance.refFromURL(activity.audioRecording);
    await audioRef.writeToFile(file);
  }

  void deleteOldAudioFile() async {
    Directory docDirectory = await getApplicationDocumentsDirectory();
    pathToSaveAudio = '${docDirectory.path}/temp_audio.aac';
    final file = File(pathToSaveAudio);
    if(await file.exists()) {
      await file.delete();
    }
  }

  final MediaService mediaService = MediaService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mediaService.init();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    mediaService.dispose();
    deleteOldAudioFile();
  }

  @override
  Widget build(BuildContext context) {

    bool isPlaying = mediaService.isPlaying;
    if( firstInit) {
      Map<String, dynamic> data = ModalRoute
          .of(context)!
          .settings
          .arguments as Map<String, dynamic>;
      activity = data["activity"];
      isEditable = data['isEditable'] == null ? false : data['isEditable'];
      firstInit = false;
      if(activity.audioRecording.isNotEmpty){
        saveAudioFromNetwork();
      }
      setState(() => {});
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(activity.title),
        backgroundColor: Colors.lightBlue[400],
        elevation: 0.0,
        actions: isEditable ? <Widget>[
          TextButton.icon(
            icon: Icon(Icons.edit, size: 30, color: Colors.white,),
            onPressed: () async {
              // TODO redirect to edit page
              Navigator.push(context, MaterialPageRoute(builder: (context) => ActivityManagement(updateActivity: refreshPage, isNew: false,activity: activity)),);
              // Navigator.pushNamed(context, '/newJob', arguments: {
              //   'createNewJob': false,
              //   'activity': activity,
              //   'refreshActivityPage': refreshPage
              // });
            },
            label: Text(''),
          )
        ] : null,
      ),
      body: Container(
        // MAKE container scrollable  V2
        child: Column( children: <Widget>[
          // Image gallery swipe able
          Container(
            height: 180,
            color: Colors.grey[400],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // // left control
                // Container(width: 60, height: 180, color: Colors.grey[400], child: Icon(Icons.arrow_left),),
                // // Image
                // Container(width: 291, height: 180, child: Icon(Icons.image, size: 200,),),
                // // right control,
                // Container(width: 60, height: 180, color: Colors.grey[400], child: Icon(Icons.arrow_right),)
                Container(width: 400,height: 180, child: activity.networkPhotos.isNotEmpty ? Image.network(activity.networkPhotos.last) : Icon(Icons.image_not_supported, size: 60,)),
              ],
            ),
          ),
          // Description + audio description
          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            height: 200,
            child: Column(children: [
              // heading + audio player
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0,0,10,20),
                  child: Text('Description', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                ),
                SizedBox(width: 100,),
                MaterialButton(elevation: 6, shape: CircleBorder(), color: Colors.lightBlue[400], onPressed: () async {
                  // TODO play audio
                  if(isPlaying){
                    // stop playing
                    await mediaService.stopAudio();
                  }
                  else{
                    // start playing
                    if (activity.audioRecording.isNotEmpty) {
                      await mediaService.playAudio(() {
                        setState(() {});
                      });
                    }
                  }
                  setState(() => {});
                  },
                  child: Icon(isPlaying ? Icons.stop_circle_outlined : Icons.play_circle_outline, size: 50, color: Colors.white,),
                ),

              ],),
              // description text
              Padding(
                padding: EdgeInsets.fromLTRB(50, 10, 0, 0),
                child: Row( children: [
                  Container(width: 300, child: Text(activity.description, maxLines: 8, overflow: TextOverflow.fade, style: TextStyle(fontSize: 14, letterSpacing: 0.3),))
                ],),
              )
            ],),
          ),
          // Enroll button with pop up confirm (if more than 1min than Snack bar)
          isEditable ? MaterialButton( // TODO one more condition. IF activity.creatorRef and auth logged in user ref are same then don't show the button
            elevation: 10,
            color: Colors.lightBlue[400],
            onPressed: (){
            // TODO Enroll job
            },
            child: Text('ENROLL', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.8),),
          ) : Container(),
          // Scroll to comment section
          // Comment section scrollable list builder
          // Container(color: Colors.yellow, height: 172,
          // child: Column(crossAxisAlignment: CrossAxisAlignment.start , children: [
          //   Padding(
          //     padding: const EdgeInsets.fromLTRB(40, 0, 0, 1),
          //     child: Text('Comments', style: TextStyle(fontSize: 16),),
          //   ),
          //   Container(
          //     color: Colors.green,
          //     height: 152,
          //     child: ListView.builder(
          //         itemCount: ,
          //         itemBuilder: (context, index) {
          //           return
          //         }
          //     ),
          //   )
          // ],),)
        ],),
      ),
    );
  }
}
