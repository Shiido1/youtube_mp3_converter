import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jaynetwork/jaynetwork.dart';
import 'package:mp3_music_converter/screens/dashboard/main_dashboard.dart';
import 'package:mp3_music_converter/screens/login/model/login_model.dart';
import 'package:mp3_music_converter/screens/login/repository/login_repo.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/utils/helper/pref_manager.dart';

LoginApiRepository _repository = LoginApiRepository();

class LoginProviders extends ChangeNotifier {
  BuildContext _context;
  bool isLoading = false;
  LoginModel loginModel;
  SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper();

  void initialize(BuildContext context) {
    this._context = context;
  }

  void loginUser({@required BuildContext context, @required Map map}) async {
    try {
      isLoading = true;
      notifyListeners();
      final _response =
          await _repository.loginUser(context: context, data: map);
      _response.when(success: (success, _, statusMessage) async {
        showToast(this._context, message: 'Login Successful.');
        isLoading = false;
        Navigator.pushAndRemoveUntil(
            _context,
            MaterialPageRoute(builder: (_) => MainDashBoard()),
            (route) => false);
        notifyListeners();
      }, failure: (NetworkExceptions error, _, statusMessage) async {
        showToast(this._context,
            message: NetworkExceptions.getErrorMessage(error));
        isLoading = false;
        notifyListeners();
      });
    } catch (e) {
      isLoading = false;
      showToast(_context, message: e);
      notifyListeners();
    }
  }
}
