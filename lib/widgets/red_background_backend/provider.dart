import 'package:flutter/material.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';

class RedBackgroundProvider extends ChangeNotifier {
  String url;

  void updateUrl(String url) {
    this.url = url;
    notifyListeners();
  }

  void getUrl() async {
    bool picExists = await preferencesHelper.doesExists(key: 'profileImage');
    if (picExists) {
      String picUrl =
          await preferencesHelper.getStringValues(key: 'profileImage');
      this.url = picUrl;
    } else
      url = null;
    notifyListeners();
  }
}
