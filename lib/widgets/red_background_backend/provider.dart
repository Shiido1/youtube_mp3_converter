
import 'package:flutter/cupertino.dart';
import 'package:mp3_music_converter/screens/login/provider/login_provider.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:provider/provider.dart';

import '../progress_indicator.dart';
import 'package:mp3_music_converter/widgets/red_background_backend/repo.dart';

final RedBackgroundRepo redBackgroundRepo = RedBackgroundRepo();

class RedBackgroundProvider extends ChangeNotifier {
  BuildContext _context;
  CustomProgressIndicator _progressIndicator;


  void init(BuildContext context) {
    this._context = context;
    this._progressIndicator = CustomProgressIndicator(this._context);
  }

  void image(String image) async {
    final map = {
      "token": Provider
          .of<LoginProviders>(_context, listen: false)
          .userToken,
      "image": image
    };
    try {
      _progressIndicator.show();
      await redBackgroundRepo.image(map);
      _progressIndicator.dismiss();
      notifyListeners();
    } catch (e) {
      _progressIndicator.dismiss();
      showToast(_context,
          message: "Network connection please try again");
      notifyListeners();
    }
  }
}