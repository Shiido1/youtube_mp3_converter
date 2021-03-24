import 'package:flutter/cupertino.dart';
import 'package:flutter_radio/flutter_radio.dart';

class RadioPlayProvider with ChangeNotifier {
  void initPlayer() {
    audioStart();
  }

  Future<void> audioStart() async {
    if (!await FlutterRadio.isPlaying()) {
      await FlutterRadio.audioStart();
      print('Audio Start OK');
      notifyListeners();
    }
  }

  void playAudio(mp3) async {
    FlutterRadio.playOrPause(url: mp3);
    notifyListeners();
  }
}
