import 'package:flutter/material.dart';
import 'package:mp3_music_converter/screens/otp/otp_page.dart';
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
      await _progressIndicator.dismiss();

      if (_response['status'] == 'success') {
        showToast(
          this._context,
          message: 'SignUp Successful.',
          backgroundColor: Colors.white,
          textColor: Colors.black,
        );
        PageRouter.gotoWidget(
            OtpPage(
              email: _response['data']?.email,
              userID: _response['data']?.name,
            ),
            _context);
      } else
        showToast(_context,
            message: _response['data'],
            backgroundColor: Colors.white,
            textColor: Colors.black);
    } catch (e) {
      await _progressIndicator.dismiss();
      showToast(
        _context,
        message: 'An error occurred. Try again later.',
        backgroundColor: Colors.white,
        textColor: Colors.black,
      );
    }
  }
}
