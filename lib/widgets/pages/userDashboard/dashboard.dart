import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homework2/services/firebaseService.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // User info card with a button to go to enrolled jobs
        Card(
          clipBehavior: Clip.antiAlias,
          elevation: 0,
          margin: EdgeInsets.all(5.0),
          child: Container(
            padding: EdgeInsets.fromLTRB(40, 20, 20, 0),
            child: Column(
              children: [
                // Name Surname
                Container(
                  child: Row(
                    children: [
                      Text("Name Surname", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.8, wordSpacing: 4),)
                    ],
                  ),
                ),
                SizedBox(height: 5,),
                // Button to enrolled widget
                Row(
                  children: [
                    Text("Finished: \$15", style: TextStyle(fontSize: 16),),
                    SizedBox(width: 20,),
                    MaterialButton(
                      color: Colors.lightBlue[400],
                      onPressed: () {
                        // TODO open enrolledJobs list widget
                      }, // TODO think of a catchy word
                      child: Row( children: [
                        Text("CHECK ALL  ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                        Icon(Icons.arrow_forward_rounded, color: Colors.white,)
                      ])
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        // Created / Posted jobs
        Card(
          clipBehavior: Clip.antiAlias,
          elevation: 0,
          margin: EdgeInsets.all(5.0),
          child: Container(
            height: 205,
            color: Colors.lightBlue[400],
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('POSTED', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2),),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  child: Container(
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Title"),
                        Text('Description'),
                        MaterialButton(
                          color: Colors.lightBlue[400],
                          onPressed: (){
                            // TODO open job
                          },
                          child: Text('Open details'),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Finished jobs
        Card(
          clipBehavior: Clip.antiAlias,
          child: Container(
            height: 205,
            color: Colors.lightBlue[400],
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('ENROLLED', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2),),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  child: Container(
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Title"),
                        Text('Description'),
                        MaterialButton(
                          color: Colors.lightBlue[400],
                          onPressed: (){
                            // TODO open job
                          },
                          child: Text('Open details'),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
