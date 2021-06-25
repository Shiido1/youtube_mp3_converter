import 'dart:io';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/utils/helper/pref_manager.dart';
import 'package:mp3_music_converter/widgets/progress_indicator.dart';
import 'package:mp3_music_converter/widgets/red_background_backend/provider.dart';
import 'package:mp3_music_converter/widgets/red_background_backend/repo.dart';
import 'package:provider/provider.dart';

class CloudStorage {
  SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper();
  HttpsCallable callable =
      FirebaseFunctions.instance.httpsCallable('updatePhoto');

  Future imageUploadAndDownload(
      {@required File image, @required BuildContext context}) async {
    CustomProgressIndicator _progressIndicator =
        CustomProgressIndicator(context);

    String token = await preferencesHelper.getStringValues(key: 'token');
    String id = await preferencesHelper.getStringValues(key: 'id');
    final reference =
        FirebaseStorage.instance.ref().child('Images').child('$token.jpg');
    _progressIndicator.show();

    try {
      UploadTask uploadTask = reference.putFile(image);

      uploadTask.timeout((Duration(seconds: 45)), onTimeout: () async {
        showToast(context, message: 'Failed to save profile image. Try again');
        _progressIndicator.dismiss();

        await uploadTask.cancel();
        return uploadTask.snapshot;
      });

      TaskSnapshot snapshot = await uploadTask;
      if (snapshot != null) {
        if (snapshot.state == TaskState.success) {
          String url = await snapshot.ref.getDownloadURL();
          print(url);
          preferencesHelper.saveValue(key: 'profileImage', value: url);
          Provider.of<RedBackgroundProvider>(context, listen: false)
              .updateUrl(url);

          callable.call({'url': url, 'id': id});
          RedBackgroundRepo(context).saveImage(url);
          _progressIndicator.dismiss();
          showToast(context, message: 'Picture updated');
        }
        if (snapshot.state == TaskState.error) {
          showToast(context,
              message: 'Failed to save profile image. Try again');
          _progressIndicator.dismiss();
        }
      }
    } on FirebaseException catch (_) {
      print(_);
      showToast(context, message: 'Failed to save profile image. Try again');
      _progressIndicator.dismiss();
    }
  }
}
