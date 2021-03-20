import 'package:flutter/foundation.dart';
import 'package:mp3_music_converter/screens/world_radio/model/radio_model.dart';
import 'package:mp3_music_converter/utils/instance.dart';

class RadioRepo {
  Future<RadioModel> radiox({@required Map map}) async {
    try {
      final res = await jayNetworkClient.makePostRequest("radiox", data: map);
      return RadioModel.fromJson(res.data);
    } catch (e) {
      return throw e;
    }
  }
}
