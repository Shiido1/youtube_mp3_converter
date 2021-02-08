import 'dart:async';

import 'package:flutter/cupertino.dart';

class UtilityProvider extends ChangeNotifier {
  Timer _timer;
  int seconds = 59;
  bool timerIsNotExpired = true;
  int minute = 4;
  // List<StateList> stateList = [];
  // List<dynamic> lga = [];
  // StateList stateData;
  bool isCleared = true;

  // static List<States> nigeriaModelEntity;

  void startTimer({int timeLimit}) {
    minute = timeLimit;
    const oneSec = const Duration(seconds: 1);
    seconds = 60;
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        timerIsNotExpired = true;
        notifyListeners();
        if (seconds == 0) {
          if (minute <= 4 && minute > 0) {
            minute = minute - 1;
            startTimer(timeLimit: minute);
          } else {
            timerIsNotExpired = false;
            notifyListeners();
          }
          timer.cancel();
        } else {
          seconds = seconds - 1;
          notifyListeners();
        }
      },
    );
  }

  void cancelTimer() {
    _timer.cancel();
    notifyListeners();
  }

  /// @load from assets
  // Future<void> loadStateAssets() async {
  //   final _response = await rootBundle.loadString('assets/files/states.json');
  //   var _states = json.decode(_response);
  //   List<dynamic> list = _states['states'];
  //   for (var map in list) {
  //     StateList _state = StateList(state: map['name'], lga: map['lgas']);
  //     stateList.add(_state);
  //     stateList.sort((a, b) => a.state.compareTo(b.state));
  //     notifyListeners();
  //   }
  // }

  void clearDropDownList(bool isCleared) {
    this.isCleared = isCleared;
    notifyListeners();
  }

  // onStateChange(data) {
  //   stateData = data;
  //   lga = stateData.lga;
  //   notifyListeners();
  // }

  // resetData() {
  //   stateList = [];
  // }
}
