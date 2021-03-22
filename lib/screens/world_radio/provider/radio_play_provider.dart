// import 'package:flutter/cupertino.dart';
// import 'package:flutter_radio/flutter_radio.dart';

// class RadioPlayProvider with ChangeNotifier {
//   void initPlayer() {}

//   Future<void> audioStart() async {
//     await FlutterRadio.audioStart();
//     notifyListeners();
//     print('Audio Start OK');
//   }

//   void playAudio(mp3) async {
//     if (advancedPlayer == null) initPlayer();
//     if (audioPlayerState == AudioPlayerState.PLAYING) stopAudio();

//     await advancedPlayer.play(mp3);
//     notifyListeners();
//   }

//   void resumeAudio() async {
//     await advancedPlayer.resume();
//     notifyListeners();
//   }

//   void pauseAudio() async {
//     await advancedPlayer.pause();
//     notifyListeners();
//   }
// }
