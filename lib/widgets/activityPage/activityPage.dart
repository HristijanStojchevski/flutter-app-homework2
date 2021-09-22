import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homework2/model/activity.dart';
import 'package:homework2/shared/utilities.dart';

class ActivityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    Map<String, dynamic> data = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    Activity activity = data["activity"];
    bool isEditable = data['isEditable'] == null ? false : data['isEditable'];
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
              Navigator.pushNamed(context, '/newJob', arguments: {
                'createNewJob': false,
                'activity': activity
              });
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
            color: Colors.blue[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // // left control
                // Container(width: 60, height: 180, color: Colors.grey[400], child: Icon(Icons.arrow_left),),
                // // Image
                // Container(width: 291, height: 180, child: Icon(Icons.image, size: 200,),),
                // // right control,
                // Container(width: 60, height: 180, color: Colors.grey[400], child: Icon(Icons.arrow_right),)
                Container(height: 180, child: Icon(Icons.image, size: 200,),),
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
                MaterialButton(elevation: 6, shape: CircleBorder(), color: Colors.lightBlue[400], onPressed: () {
                  // TODO play audio
                  },
                  child: Icon(Icons.play_circle_outline, size: 50, color: Colors.white,),
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
          isEditable || !activity.enrolled ? MaterialButton( // TODO one more condition. IF activity.creatorRef and auth logged in user ref are same then don't show the button
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
