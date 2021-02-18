import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:jaynetwork/network/network_exceptions.dart';
import 'package:mp3_music_converter/screens/dashboard/sample_dashboard.dart';
import 'package:mp3_music_converter/screens/otp/otp_page.dart';
import 'package:mp3_music_converter/screens/signup/model/signup_model.dart';
import 'package:mp3_music_converter/screens/signup/repository/signup_repo.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/utils/page_router/navigator.dart';
import 'package:mp3_music_converter/widgets/progress_indicator.dart';

final SignUpApiRepository _repository = SignUpApiRepository();

class SignUpProviders extends ChangeNotifier {
  BuildContext _context;
  CustomProgressIndicator _progressIndicator;

  void init(BuildContext context) {
    this._context = context;
    this._progressIndicator = CustomProgressIndicator(this._context);
  }

  void signUp({@required Map map}) async {
    try {
      _progressIndicator.show();
      final _response = await _repository.signUp(data: map);
      _response.when(success: (success, _, __) async {
        await _progressIndicator.dismiss();
        PageRouter.gotoWidget(
            OtpPage(
              email: success?.email,
              userID: success?.name,
            ),
            _context);
        notifyListeners();
      }, failure: (NetworkExceptions error, int statusCode,
          String statusMessage) async {
        await _progressIndicator.dismiss();
        showToast(this._context,
            message: NetworkExceptions.getErrorMessage(error));
      });
    } catch (e) {
      await _progressIndicator.dismiss();
      showToast(_context, message: "Please connect to internet");
    }
  }
}
