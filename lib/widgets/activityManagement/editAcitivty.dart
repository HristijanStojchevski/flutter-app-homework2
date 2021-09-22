import 'dart:io';

import 'package:flutter/material.dart';
import 'package:homework2/widgets/activityManagement/contentFormStep.dart';
import 'package:homework2/widgets/activityManagement/mainFormStep.dart';

class EditActivity extends StatefulWidget {
  final Function validate;
  String category;
  String name;
  String description;

  List<File> imgSrc;
  String audioSrc;

  EditActivity({
      required this.validate,
      required this.category,
      required this.name,
      required this.description,
      required this.imgSrc,
      required this.audioSrc});

  @override
  _EditActivityState createState() => _EditActivityState();
}

class _EditActivityState extends State<EditActivity> {

  int activeStepIndex = 0;
  String category = '';
  String name = '';
  String description = '';

  List<File> imgSrc = [];
  String audioSrc = '';

  @override void initState() {
    // TODO: implement initState
    super.initState();
    this.category = widget.category;
    this.name = widget.name;
    this.description = widget.description;
    this.imgSrc = widget.imgSrc;
    this.audioSrc = widget.audioSrc;
  }

  void updateMain(category, name, description){
    setState(() {
      this.category = category;
      this.name = name;
      this.description = description;
    });
    widget.validate(_formKey);
  }
  void updateContent(imgSrc, audioSrc){
    setState(() {
      this.imgSrc = imgSrc;
      this.audioSrc = audioSrc;
    });
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
        child: ContentStep(updateParams: updateContent, audioSrc: this.audioSrc, imgSrc: this.imgSrc)
    ))
  ];

  @override
  Widget build(BuildContext context) {
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
