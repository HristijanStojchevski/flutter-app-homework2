import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:homework2/model/activity.dart';
import 'package:homework2/widgets/activityManagement/contentFormStep.dart';
import 'package:homework2/widgets/activityManagement/mainFormStep.dart';

class NewActivity extends StatefulWidget {
  final Function validate;
  final Function updateActivity;
  NewActivity({required this.validate, required this.updateActivity});

  @override
  _NewActivityState createState() => _NewActivityState();
}

class _NewActivityState extends State<NewActivity> {

  Activity _newActivity = Activity(title: 'title', description: 'description', location: GeoPoint(0,0), category: '', networkPhotos: [], audioRecording: '');
  int activeStepIndex = 0;
  String category = '';
  String name = '';
  String description = '';

  List<File> imgSrc = <File>[];
  String audioSrc = '';

  void updateMain(category, name, description){
    setState(() {
      this.category = category;
      this.name = name;
      this.description = description;
      this._newActivity.title = name;
      this._newActivity.category = category;
      this._newActivity.description = description;
    });
    widget.validate(_formKey);
    widget.updateActivity(_newActivity);
  }
  void updateContent(imgSrc, audioSrc, List<String> networkPhotos, String audioRecording){
    setState(() {
      this.imgSrc = imgSrc;
      this.audioSrc = audioSrc;
      this._newActivity.audioSrc = audioSrc;
      this._newActivity.photos = imgSrc;
    });
    widget.updateActivity(_newActivity);
  }
  // global form key
  final _formKey = GlobalKey<FormState>();

  List<Step> stepList() => [
    Step(
        state: activeStepIndex > 0 ? StepState.complete : StepState.editing,
        isActive: activeStepIndex >= 0,
        title: Text('Main'), content: Center(
      child: MainStep(updateParams: updateMain, description: description, name: name, category: category,)
    )),
    Step(
        state: activeStepIndex >= 1 && _formKey.currentState!.validate() ? StepState.complete : StepState.editing,
        isActive: activeStepIndex >= 1,
        title: Text('Content'), content: Center(
      child: ContentStep(updateParams: updateContent, audioSrc: this.audioSrc, imgSrc: this.imgSrc, networkPhotos: [], audioRecording: '',)
    ))
  ];

  @override
  Widget build(BuildContext context) {

    // TODO on navigation back show snack bar
    final snackBar = SnackBar(content: Text('Are you sure ? All your progress will be lost !'), action: SnackBarAction(label: 'Exit', onPressed: (){
      Navigator.pop(context);
    },),);
    return Form(
      key: _formKey,
      child: Stepper(
          type: StepperType.horizontal,
          steps: stepList(),
          currentStep: activeStepIndex,
          onStepContinue: () {
            if(activeStepIndex < stepList().length - 1){
              // validate form
              if(_formKey.currentState!.validate()){
                setState(() {
                  activeStepIndex += 1;
                });}
            }
            },
          onStepCancel: () {
            if( activeStepIndex == 0 ){
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
            else {
              setState(() {
                activeStepIndex -= 1;
              });
            }
          },
          onStepTapped: (stepTapped) {
            if(stepTapped < activeStepIndex || _formKey.currentState!.validate()){ // validate form
              setState(() {
                activeStepIndex = stepTapped;
              });
            }
          },
      ),
    );
  }
}
