import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mp3_music_converter/screens/world_radio/model/radio_model.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/utils/instance.dart';

class RadioRepo {
  Future<RadioModel> radiox(
      {@required Map map,
      @required bool search,
      @required BuildContext context,
      @required bool add}) async {
    try {
      final res = await jayNetworkClient
          .makePostRequest(search ? "searchradio" : "radiox", data: map);
      return RadioModel.fromJson(res.data, add);
    } catch (e) {
      showToast(context, message: 'An error occurred. Try again');
      return throw e;
    }
  }
}
