import 'package:flutter/cupertino.dart';
import 'package:flutter_radio/flutter_radio.dart';

class RadioPlayProvider with ChangeNotifier {
  String currentRadio;

  void initPlayer() {
    audioStart();
  }

  Future<void> audioStart() async {
    await FlutterRadio.audioStart();
    notifyListeners();
    print('Audio Start OK');
  }

  void playAudio(mp3) async {
    if (currentRadio == mp3) return;

    FlutterRadio.playOrPause(url: mp3);
    notifyListeners();
    currentRadio = mp3;
  }
}
