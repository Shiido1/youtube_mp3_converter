import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:jaynetwork/jaynetwork.dart';
import 'package:mp3_music_converter/database/hive_boxes.dart';
import 'package:mp3_music_converter/screens/login/repository/login_repo.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/utils/page_router/navigator.dart';
import 'package:mp3_music_converter/widgets/progress_indicator.dart';

final LoginApiRepository _repository = LoginApiRepository();

class LoginProviders extends ChangeNotifier {
  BuildContext _context;
  CustomProgressIndicator _progressIndicator;
  bool isLoading = false;
  String userToken =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC82Ny4yMDUuMTY1LjU2IiwiYXVkIjoiaHR0cDpcL1wvNjcuMjA1LjE2NS41NiIsImlhdCI6MTM1Njk5MTUyNCwibmJmIjoxMzU3MDAxMDAwLCJlbWFpbCI6InByZWJhZDUwQGdtYWlsLmNvbSJ9.QNDikltIgKrfOnO6NWxCWDSw5kDmYUrN9WYez24GvsU';
  Box<String> _box;

  void initialize(BuildContext context) {
    this._context = context;
    this._progressIndicator = CustomProgressIndicator(this._context);
  }

  void loginUser({@required BuildContext context, @required Map map}) async {
    try {
      // _progressIndicator.show();
      isLoading = true;
      notifyListeners();
      final _response =
          await _repository.loginUser(context: context, data: map);
      _response.when(success: (success, _, statusMessage) async {
        await _progressIndicator.dismiss();
        isLoading = false;
        PageRouter.gotoNamed(Routes.DASHBOARD, _context);
        notifyListeners();
      }, failure: (NetworkExceptions error, _, statusMessage) async {
        await _progressIndicator.dismiss();
        isLoading = false;
        showToast(this._context, message: statusMessage);
        notifyListeners();
      });
    } catch (e) {
      await _progressIndicator.dismiss();
      isLoading = false;
      showToast(_context, message: "Please connect to internet");
      notifyListeners();
    }
  }

  getUserToken(String token) {
    userToken = token;
    notifyListeners();
  }

  saveUserToken(String token) async {
    if (!(_box?.isOpen ?? false))
      _box = await PgHiveBoxes.openBox<String>('userToken');
    _box.put('token', token);
  }

  getSavedUserToken() async {
    if (!(_box?.isOpen ?? false))
      _box = await PgHiveBoxes.openBox<String>('userToken');
    String token = _box.get('token');
    userToken = token;
    notifyListeners();
  }
}
