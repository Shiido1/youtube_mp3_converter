import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_radio/flutter_radio.dart';
import 'package:audio_session/audio_session.dart' as asp;
import 'package:mp3_music_converter/screens/song/provider/music_provider.dart';

class RadioPlayProvider with ChangeNotifier {
  String currentRadio;
  bool value;

  void initPlayer() {
    audioStart();
  }

  Future<void> audioStart() async {
    if (!await FlutterRadio.isPlaying()) {
      await FlutterRadio.audioStart();
      value = true;
      notifyListeners();
    }
  }

  void playRadio(radioPlayer) async {
    await AudioService.customAction(AudioPlayerTask.STOP);
    await AudioService.pause();
    asp.AudioSession audioSession = await asp.AudioSession.instance;
    audioSession
        .configure(asp.AudioSessionConfiguration.speech())
        .then((value) async {
      if (await audioSession.setActive(true))
        await FlutterRadio.playOrPause(url: radioPlayer);
    });
    notifyListeners();
  }
}
