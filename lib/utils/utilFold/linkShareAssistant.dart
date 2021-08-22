import 'dart:io';

import 'package:flutter/services.dart';

/// This service is responsible for talking with the OS to see if anything was
/// shared with the application.
class LinkShareAssistant {
  void Function(String) onDataReceived;

  LinkShareAssistant() {
    // If sharing causes the app to be resumed, we'll check to see if we got any
    // shared data
    SystemChannels.lifecycle.setMessageHandler((msg) async {
      if (msg.contains("resumed") ?? false) {
        getSharedData().then((String data) {
          // Nothing was shared with us :(
          if (data.isEmpty) {
            return;
          }

          // We got something! Inform our listener.
          onDataReceived?.call(data);
        });
      }
      return;
    });
  }

  /// Invoke a method on our platform, telling it to give us any shared data
  /// it has
  Future<String> getSharedData() async {
    return Platform.isAndroid ? await MethodChannel('com.youtubeaudio.mp3_music_converter')
        .invokeMethod("getSharedData") ??
        "" : "";
  }
}