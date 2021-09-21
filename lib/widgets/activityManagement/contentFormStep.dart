import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homework2/services/mediaService.dart';
import 'package:image_picker/image_picker.dart';

class ContentStep extends StatefulWidget {
  final Function updateParams;
  final List<File> imgSrc;
  final String audioSrc;

  ContentStep({required this.updateParams, required this.imgSrc, required this.audioSrc});

  @override
  _ContentStepState createState() => _ContentStepState();
}

class _ContentStepState extends State<ContentStep> {
  final File? imageFile = null;

  final ImagePicker imagePicker = ImagePicker();

  Future pickImage({imageSource}) async {
    try{
      final image = await imagePicker.pickImage(source: imageSource);
      if(image == null) return;

      this.widget.imgSrc.add(File(image.path));
      widget.updateParams(this.widget.imgSrc, this.widget.audioSrc);
    } on PlatformException catch (ex) {
      print('Failed to pick image: ${ex.toString()}');
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
  }

  @override
  Widget build(BuildContext context) {
    bool isRecording = mediaService.isRecording;
    bool isPlaying = mediaService.isPlaying;
    return Container(
      height: 400,
      child: Column(children: <Widget>[
        // Gallery swipe able
        Container(
          height: 180,
          color: Colors.blue[200],
          child: Row(
            children: [
              // left control
              Container(width: 40, height: 180, color: Colors.grey[400], child: Icon(Icons.arrow_left),),
              // Image
              Container(width: 283.2, height: 180, child: widget.imgSrc.isEmpty ?
                Icon(Icons.image, size: 200,) :
                Image.file(widget.imgSrc.last, fit: BoxFit.cover),
              ),
              // right control,
              Container(width: 40, height: 180, color: Colors.grey[400], child: Icon(Icons.arrow_right),)
            ],
          ),
        ),
        // Gallery update,
        Container(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // NEW IMAGE
              MaterialButton(minWidth: 130, color: Colors.lightBlue[400],onPressed: () async {
                // TODO open camera
                await pickImage(imageSource: ImageSource.camera);
              }, child: Text("New image", style: TextStyle(color: Colors.white, letterSpacing: 0.5))),
              // delete image,
              MaterialButton(minWidth: 50,onPressed: () {
                // V2
                // TODO delete
                // snack bar are you sure then action to delete
                },
                child: Icon(Icons.delete, size: 40, color: Colors.redAccent,),
              ),
              // Upload image
              MaterialButton(minWidth: 130, color: Colors.lightBlue[400],onPressed: () async {
                await pickImage(imageSource: ImageSource.gallery);
              }, child: Text("Upload image", style: TextStyle(color: Colors.white, letterSpacing: 0.5),),)
            ],
          ),
        ),
        SizedBox(height: 10,),
        // Audio tape / player,
        Container(
          height: 60,
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Expanded(child: FittedBox(fit: BoxFit.fill, child: Container(color: Colors.grey[400],child: Icon(Icons.multitrack_audio_outlined)))),
            MaterialButton(elevation: 6,color: Colors.grey[500],minWidth: 100,onPressed: () async {
              // TODO play audio
                if(isPlaying){
                  // stop playing
                  await mediaService.stopAudio();
                }
                else{
                  // start playing
                  await mediaService.playAudio(() { setState(() {});});
                }
                setState(() => {});
            },
            child: Icon(isPlaying ? Icons.stop_circle_outlined : Icons.play_circle_fill, size: 60,),)
          ],),
        ),
        SizedBox(height: 10,),
        // Mic control,
        Container(
          height: 60,
          child: MaterialButton(elevation: 8, color: Colors.grey[400],shape: CircleBorder(),onPressed: () async {
            // TODO record audio with mic
            if(isRecording){
              await mediaService.stopRecording();

            }
            else{
              await mediaService.record();
            }
            setState(() {});
            },
            child: Icon(isRecording ? Icons.stop_circle_outlined : Icons.mic, size: isRecording ? 60 : 50, color: isRecording ? Colors.redAccent : Colors.lightBlue[500],),
          ),
        ),
        // Hidden list of TextFromFields for the path references of the photos that were saved
      ])
    );
  }
}
