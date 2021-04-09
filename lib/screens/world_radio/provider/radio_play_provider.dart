import 'package:flutter/cupertino.dart';
import 'package:flutter_radio/flutter_radio.dart';
import 'package:mp3_music_converter/screens/world_radio/model/radio_model.dart';
import 'package:mp3_music_converter/screens/world_radio/repo/radio_repo.dart';

class RadioPlayProvider with ChangeNotifier {
  List<Radio> favRadio = [];
  List<Radio> favourite = [];
  Radio favorite;
  String radioPlayer = '';
  bool isPLay = false;

  int _currentRadioIndex = -1;
  int get length => favourite.length;
  int get songNumber => _currentRadioIndex + 1;

  void initPlayer() {
    audioStart();
    RadioPlayerRepository.init();
  }

  Future<void> audioStart() async {
    await FlutterRadio.audioStart();
    print('Audio Start OK');
    notifyListeners();
  }

  void playRadio(radioPlayer) async {
    if (await FlutterRadio.isPlaying()) return;
    await FlutterRadio.playOrPause(url: radioPlayer);
    notifyListeners();
  }

  void updateFavourite(Radio fav) {
    favorite = fav;
  }

  getFavoriteRadio() async {
    favourite = await RadioPlayerRepository.getFavoriteRadio();

    notifyListeners();
  }

  updateRadio(Radio radio) {
    favRadio.forEach((element) {
      if (element.name == radio.name) {
        element = radio;
      }
    });
    RadioPlayerRepository.addRadio(radio);
    notifyListeners();
  }

  // Future next() async {
  //   playRadio(nextRadio);
  //   notifyListeners();
  //   if (favourite.isNotEmpty) playRadio(nextFavRadio);
  //   notifyListeners();
  // }
  //
  // Future prev() async {
  //   playRadio(prevRadio);
  //   notifyListeners();
  //   if (favourite.isNotEmpty) playRadio(prevFavRadio);
  //   notifyListeners();
  // }
  //
  // bool get canNextRadio => _currentRadioIndex == length - 1;
  // bool get canPrevRadio => _currentRadioIndex == 0;
  //
  // Radio get nextRadio {
  //   if (_currentRadioIndex < length) {
  //     _currentRadioIndex++;
  //   }
  //   if (_currentRadioIndex >= length) return null;
  //   return favRadio[_currentRadioIndex];
  // }
  //
  // Radio get prevRadio {
  //   if (_currentRadioIndex > 0) {
  //     _currentRadioIndex--;
  //   }
  //   if (_currentRadioIndex < 0) return null;
  //   return favRadio[_currentRadioIndex];
  // }
  //
  // Radio get nextFavRadio {
  //   if (_currentRadioIndex < length) {
  //     _currentRadioIndex++;
  //   }
  //   if (_currentRadioIndex >= length) return null;
  //   return favourite[_currentRadioIndex];
  // }
  //
  // Radio get prevFavRadio {
  //   if (_currentRadioIndex > 0) {
  //     _currentRadioIndex--;
  //   }
  //   if (_currentRadioIndex < 0) return null;
  //   return favourite[_currentRadioIndex];
  // }
}
