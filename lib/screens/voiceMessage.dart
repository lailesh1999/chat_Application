import 'dart:io';
//import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
//import 'package:just_audio/just_audio.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:audioplayers/audio_cache.dart';
import 'dart:convert';

class Record {
  String statusText = "";
  bool isComplete = false;
  Timer? countdownTimer;

  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  void startRecord() async {
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      statusText = "Recording...";
      recordFilePath = await getFilePath();
      isComplete = false;

      RecordMp3.instance.start(recordFilePath, (type) {
        statusText = "Record error--->$type";
      });
    } else {
      statusText = "No microphone permission";
    }
  }

  void pauseRecord() {
    if (RecordMp3.instance.status == RecordStatus.PAUSE) {
      bool s = RecordMp3.instance.resume();
      if (s) {
        statusText = "Recording...";
      }
    } else {
      bool s = RecordMp3.instance.pause();
      if (s) {
        statusText = "Recording pause...";
      }
    }
  }

  void stopRecord() {
    bool s = RecordMp3.instance.stop();
    if (s) {
      statusText = "Record complete";
      isComplete = true;
    }
  }

  void resumeRecord() {
    bool s = RecordMp3.instance.resume();
    if (s) {
      statusText = "Recording...";
    }
  }

  late String recordFilePath;

  // void play() {
  //   if (recordFilePath != null && File(recordFilePath).existsSync()) {
  //     AudioPlayer audioPlayer = AudioPlayer();
  //     audioPlayer.play(recordFilePath as Source, isLocal: true);
  //   }
  // }

  int i = 0;

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = "/storage/emulated/0/Download/chatApplication" + "/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return sdPath + "/test_${i++}.mp3";
  }

  // Source src = AudioSource.uri(Uri.file(audioPath));
  final audioPlayer = AudioPlayer();

  Future<void> playAudioForDuration() async {
    // Play audio

    String audioPath = '/assets/music/record.mp3';
    final result = await audioPlayer.play(UrlSource(audioPath));

    //final result = await audioPlayer.play(src );
    Timer(Duration(seconds: 1), () {
      audioPlayer.stop();
    });
  }
}
