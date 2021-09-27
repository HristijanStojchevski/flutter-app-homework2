import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:homework2/model/activity.dart';
import 'package:homework2/widgets/activityManagement/contentFormStep.dart';
import 'package:homework2/widgets/activityManagement/mainFormStep.dart';

class EditActivity extends StatefulWidget {
  final Function validate;
  final Function updateActivity;
  Activity activity;

  EditActivity({
      required this.validate,
      required this.updateActivity,
      required this.activity});

  @override
  _EditActivityState createState() => _EditActivityState();
}

class _EditActivityState extends State<EditActivity> {

  int activeStepIndex = 0;
  String category = '';
  String name = '';
  String description = '';
  String audioRecording = '';
  List<String> networkPhotos = [];
  List<File> imgSrc = [];
  String audioSrc = '';
  Activity editedActivity = Activity(title: 'title', description: 'description', location: GeoPoint(0,0), category: '', networkPhotos: [], audioRecording: '');
  @override void initState() {
    // TODO: implement initState
    super.initState();
    this.category = widget.activity.category;
    this.name = widget.activity.title;
    this.description = widget.activity.description;
    this.imgSrc = widget.activity.photos;
    this.audioSrc = widget.activity.audioSrc;
    this.editedActivity = widget.activity;
    this.networkPhotos = widget.activity.networkPhotos;
    this.audioRecording = widget.activity.audioRecording;
  }

  void updateMain(category, name, description){
    setState(() {
      this.category = category;
      this.name = name;
      this.description = description;
      this.editedActivity.title = name;
      this.editedActivity.category = category;
      this.editedActivity.description = description;
    });
    widget.validate(_formKey);
    widget.updateActivity(editedActivity);
  }
  void updateContent(imgSrc, audioSrc, List<String> networkPhotos, String audioRecording){
    setState(() {
      this.imgSrc = imgSrc;
      this.audioSrc = audioSrc;
      this.networkPhotos = networkPhotos;
      this.audioRecording = audioRecording;
      this.editedActivity.audioSrc = audioSrc;
      this.editedActivity.photos = imgSrc;
      this.editedActivity.networkPhotos = networkPhotos;
      this.editedActivity.audioRecording = audioRecording;
    });
    widget.updateActivity(editedActivity);
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
        child: ContentStep(updateParams: updateContent, audioSrc: this.audioSrc, imgSrc: this.imgSrc, networkPhotos: this.networkPhotos, audioRecording: this.audioRecording,)
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
