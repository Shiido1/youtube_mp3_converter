import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mp3_music_converter/screens/world_radio/model/radio_model.dart';
import 'package:mp3_music_converter/screens/world_radio/provider/radio_provider.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/utils/instance.dart';
import 'package:mp3_music_converter/widgets/progress_indicator.dart';
import 'package:provider/provider.dart';

class RadioRepo {
  Future<RadioModel> radiox({
    @required Map map,
    @required bool search,
    @required BuildContext context,
  }) async {
    try {
      final res = await jayNetworkClient
          .makePostRequest(search ? "searchradio" : "radiox", data: map);
      if (!search)
        Provider.of<RadioProvider>(context, listen: false)
            .updateShowAllChannels(true);
      print("this is the data: ${RadioModel.fromJson(res.data).radio}");
      return RadioModel.fromJson(res.data);
    } catch (e) {
      if (!search)
        Provider.of<RadioProvider>(context, listen: false)
            .updateShowAllChannels(false);
      showToast(context, message: 'An error occurred. Try again', gravity: 1);
      return throw e;
    }
  }
}
