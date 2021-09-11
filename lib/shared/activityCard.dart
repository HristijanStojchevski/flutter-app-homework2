import 'package:flutter/material.dart';
import 'package:homework2/model/activity.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;

  ActivityCard({required this.activity});



  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        color: Colors.lightBlue[400],
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Icon(Icons.arrow_drop_down_circle, size: 40,),
                        SizedBox(width: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(activity.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            // TODO convert category to multiple lines
                            Text(activity.category.length <= 28 ? activity.category : 'multi line or\nvalidation on category entry', style: TextStyle(fontSize: 14, color: Colors.white),),
                          ],),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(activity.isNearby ? 'NEARBY' : '', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
                        SizedBox(width: 10,),
                        Text('${activity.distance}m')
                      ],
                    ),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.image, size: 60,),
                // TODO convert description to multiple lines
                Container(width: 290, child: Text(activity.description.length < 48 ? activity.description : 'Multiple row text sent to a function that returns \n a new text split on every 48 char with new line')),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0,0,10,0),
                  child: Icon(Icons.play_arrow, size: 30,),
                )
              ],
            ),
            ButtonBar(
              alignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {  },
                  child: Text('FULL POST', style: TextStyle(color: Colors.white, fontSize: 16),),),
                MaterialButton(
                  color: Colors.blue[600],
                  onPressed: () {  },
                  child: Text('ENROLL', style: TextStyle(color: Colors.white, fontSize: 16),),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}