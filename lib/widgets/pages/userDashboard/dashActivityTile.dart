import 'package:flutter/material.dart';
import 'package:homework2/model/activity.dart';

class DashActivityTile extends StatelessWidget {
  final Activity activity;

  DashActivityTile({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Container(
        color: Colors.white,
        child: Row(
          children: [
            Container(
              width: 285,
              child: Row(
                  children: [
                Container(padding: EdgeInsets.fromLTRB(10, 0, 2, 0), width: 100, child: Text(activity.title, maxLines: 2, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),)),
                Container(width: 180, child: Text(activity.category,maxLines: 2,)),
              ]),
            ),
            Container(
              child: Row(
                children: [
                  MaterialButton(
                    color: Colors.lightBlue[400],
                    onPressed: (){
                      // TODO open job
                      Navigator.pushNamed(context, '/activity', arguments: {
                        'activity': activity,
                        'isEditable': !activity.enrolled
                      });
                    },
                    child: Text('Open details'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}