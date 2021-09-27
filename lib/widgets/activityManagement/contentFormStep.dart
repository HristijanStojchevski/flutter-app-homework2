import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homework2/services/mediaService.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
class ContentStep extends StatefulWidget {
  final Function updateParams;
  final List<File> imgSrc;
  final String audioSrc;
  final String audioRecording;
  final List<String> networkPhotos;

  ContentStep({required this.updateParams, required this.imgSrc, required this.audioSrc, required this.audioRecording, required this.networkPhotos});

  @override
  _ContentStepState createState() => _ContentStepState();
}

class _ContentStepState extends State<ContentStep> {
  final File? imageFile = null;
  final ImagePicker imagePicker = ImagePicker();
  String audioSrc = '';
  List<String> networkPhotos = [];
  String audioRecording = '';
  List<Map<String, dynamic>> images = [];

  Future pickImage({imageSource}) async {
    try{
      final image = await imagePicker.pickImage(source: imageSource);
      if(image == null) return;
      this.widget.imgSrc.add(File(image.path));
      this.images.add({'local': File(image.path)});
      widget.updateParams(this.widget.imgSrc, this.audioSrc, this.networkPhotos, this.audioRecording);
    } on PlatformException catch (ex) {
      print('Failed to pick image: ${ex.toString()}');
    }
  }

  void saveAudioFromNetwork() async {
    Directory docDirectory = await getApplicationDocumentsDirectory();
    pathToSaveAudio = '${docDirectory.path}/temp_audio.aac';
    final file = File(pathToSaveAudio);
    Reference audioRef = FirebaseStorage.instance.refFromURL(widget.audioRecording);
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
    this.audioSrc = widget.audioSrc;
    this.networkPhotos = widget.networkPhotos;
    this.audioRecording = widget.audioRecording;
    if(this.audioRecording.isNotEmpty){
      saveAudioFromNetwork();
    } else {
      // Make sure there is no leftover file
      deleteOldAudioFile();
    }
    for(File photo in widget.imgSrc){
      this.images.add({'local': photo});
    }
    for(String urlPhoto in widget.networkPhotos){
      this.images.add({'network': urlPhoto});
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    mediaService.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deleteImageSnackBar = SnackBar(content: Text('Are you sure ? You can\'t undo this !'), action: SnackBarAction(textColor: Colors.lightBlueAccent,label: 'DELETE', onPressed: (){
      // TODO remove selected image from images list and from relevant src + call updateParams, show previous index
    },), backgroundColor: Colors.redAccent, duration: Duration(seconds: 5),);
    final audioSnackBar = SnackBar(content: Text('Do you want to start a new recording ? You will overwrite previous recording !'), action: SnackBarAction(textColor: Colors.white,label: 'RECORD', onPressed: () async {
      await mediaService.record();
      setState(() {});
      widget.updateParams(this.widget.imgSrc, this.audioSrc, this.networkPhotos, this.audioRecording);
    },), backgroundColor: Colors.blueAccent, duration: Duration(seconds: 10),);
    bool isRecording = mediaService.isRecording;
    bool isPlaying = mediaService.isPlaying;
    return Container(
      height: 400,
      child: Column(children: <Widget>[
        // Gallery swipe able
        Container(
          height: 180,
          color: Colors.grey[400],
          child: Row(
            children: [
              // left control
              Container(width: 40, height: 180, color: Colors.grey[500], child: Icon(Icons.arrow_left),),
              // Image
              Container(width: 283.2, height: 180, child: images.isEmpty ?
                Icon(Icons.image, size: 200,) : images.last.containsKey('network') ?
                  Image.network(images.last['network'], fit: BoxFit.cover,)
                  :
                  Image.file(images.last['local'], fit: BoxFit.cover),
              ),
              // right control,
              Container(width: 40, height: 180, color: Colors.grey[500], child: Icon(Icons.arrow_right),)
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
                // snack bar are you sure then action to delete
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(deleteImageSnackBar);
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
                  if (audioRecording.isNotEmpty || audioSrc.isNotEmpty) {
                    await mediaService.playAudio(() {
                      setState(() {});
                    });
                  }
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
              try {
                await mediaService.stopRecording();
                audioSrc = 'temp_audio.aac';
                audioRecording = '';
                setState(() {});
                widget.updateParams(this.widget.imgSrc, this.audioSrc, this.networkPhotos, this.audioRecording);
              } catch (someErr) {
                print(someErr.toString());
              }
            }
            else{
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(audioSnackBar);
            }
            },
            child: Icon(isRecording ? Icons.stop_circle_outlined : Icons.mic, size: isRecording ? 60 : 50, color: isRecording ? Colors.redAccent : Colors.lightBlue[500],),
          ),
        ),
        // Hidden list of TextFromFields for the path references of the photos that were saved
      ])
    );
  }
}
