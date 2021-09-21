import 'package:flutter/cupertino.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

final pathToSaveAudio = 'temp_audio.aac';

class MediaService {
  FlutterSoundRecorder? _audioRecorder;
  FlutterSoundPlayer? _audioPlayer;

  bool get isRecording => _audioRecorder!.isRecording;
  bool get isPlaying => _audioPlayer!.isPlaying;

  String get pathOfSavedAudio => pathToSaveAudio;

  bool _isInit = false;
  Future record() async {
    if(!_isInit) return;
    final permission = await Permission.microphone.request();
    if(!permission.isGranted) {
      return;
    }
    await _audioRecorder!.openAudioSession();
    await _audioRecorder!.startRecorder(toFile: pathToSaveAudio);
  }

  Future stopRecording() async {
    if(!_isInit) return;
    await _audioRecorder!.stopRecorder();
    // await _audioRecorder!.closeAudioSession();
  }

  Future playAudio(VoidCallback whenFinished) async {
    if(!_isInit) return;
    await _audioPlayer!.startPlayer(
      fromURI: pathToSaveAudio,
      whenFinished: whenFinished
    );
  }

  Future stopAudio() async {
    if(!_isInit) return;
    await _audioPlayer!.stopPlayer();
  }

  Future init() async {
    if(_isInit) return;
    _audioRecorder = FlutterSoundRecorder();
    _audioPlayer = FlutterSoundPlayer();
    await _audioPlayer!.openAudioSession();
    _isInit = true;
  }

  Future dispose() async{
    if(!_isInit) return;
    _audioRecorder!.closeAudioSession();
    _audioRecorder = null;
    _audioPlayer!.closeAudioSession();
    _audioPlayer = null;
    _isInit = false;
  }

}