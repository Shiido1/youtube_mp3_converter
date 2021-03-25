import 'package:flutter/cupertino.dart';
import 'package:flutter_radio/flutter_radio.dart';
import 'package:mp3_music_converter/screens/world_radio/model/radio_model.dart';
import 'package:mp3_music_converter/screens/world_radio/repo/radio_repo.dart';

class RadioPlayProvider with ChangeNotifier {
  List<Radio> favRadio = [];
  Radio favourite;

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

  void updateFavourite(Radio _favourite) {
    favourite = _favourite;
  }

  getFavoriteRadio() async {
    favRadio = await RadioPlayerRepository.getFavoriteRadio();
    notifyListeners();
  }

  updateRadio(Radio radio) {
    favRadio.forEach((element) {
      if (element.name == radio.name) {
        element = radio;
      }
    });
    if (favRadio.isEmpty) return;
    RadioPlayerRepository.addRadio(radio);
    notifyListeners();
  }
}
