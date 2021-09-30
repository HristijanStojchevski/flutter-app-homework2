import 'package:flutter/material.dart';
import 'package:homework2/model/activity.dart';
import 'package:homework2/services/firebaseService.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;
  final bool isEditable;
  final Function refreshPage;
  ActivityCard({required this.activity,required this.refreshPage, required this.isEditable});
  final firebaseService = FirebaseService();
  @override
  Widget build(BuildContext context) {
    final deleteErr = SnackBar(content: Text('There was an error with the deletion of this post! TRY AGAIN', style: TextStyle(fontSize: 14),), backgroundColor: Colors.redAccent, duration: Duration(seconds: 5),);
    final deleteSnackBar = SnackBar(content: Text('Are you sure you want to delete this post ?!', style: TextStyle(fontSize: 16)), action: SnackBarAction(textColor: Colors.lightBlueAccent,label: 'DELETE', onPressed: () async{
      bool delSuc = await firebaseService.deleteActivity(activity.activityId);
      if(!delSuc){
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(deleteErr);
      }
      else {
        refreshPage();
      }
    },), backgroundColor: Colors.redAccent, duration: Duration(seconds: 10),);
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
                    child: isEditable ? null : Row(
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
                Container(width: 290, child: Text(activity.description, maxLines: 3,overflow: TextOverflow.fade,)),
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
                  onPressed: () {
                    Navigator.pushNamed(context, '/activity', arguments: {
                      // 'activityRef': activity.ref,
                      'activity': activity,
                      'isEditable': isEditable
                    });
                  },
                  child: Text('FULL POST', style: TextStyle(color: Colors.white, fontSize: 16),),),
                MaterialButton(
                  color: isEditable ? Colors.redAccent : Colors.blue[600],
                  onPressed: () {
                    if(isEditable){
                      //TODO delete
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(deleteSnackBar);
                    }
                    else{
                      //TODO enroll
                    }
                  },
                  child: Text(isEditable ? 'DELETE' : 'SAVE', style: TextStyle(color: Colors.white, fontSize: 16),),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}