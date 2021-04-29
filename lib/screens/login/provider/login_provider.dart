import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:jaynetwork/jaynetwork.dart';
import 'package:mp3_music_converter/database/hive_boxes.dart';
import 'package:mp3_music_converter/screens/login/repository/login_repo.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/utils/helper/pref_manager.dart';
import 'package:mp3_music_converter/utils/page_router/navigator.dart';
import 'package:mp3_music_converter/widgets/progress_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

final LoginApiRepository _repository = LoginApiRepository();

class LoginProviders extends ChangeNotifier {
  BuildContext _context;
  CustomProgressIndicator _progressIndicator;
  bool isLoading = false;
  String userToken='';
      // 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC82Ny4yMDUuMTY1LjU2IiwiYXVkIjoiaHR0cDpcL1wvNjcuMjA1LjE2NS41NiIsImlhdCI6MTM1Njk5MTUyNCwibmJmIjoxMzU3MDAxMDAwLCJlbWFpbCI6InByZWJhZDUwQGdtYWlsLmNvbSJ9.QNDikltIgKrfOnO6NWxCWDSw5kDmYUrN9WYez24GvsU';
  Box<String> _box;
  String email='';
  String name='';
  SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper();


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
        showToast(this._context, message: 'Successfully Logged in..');
        isLoading = false;
        preferencesHelper.saveValue(key: 'email', value: map['email']);
        print(map['password']);
        await PageRouter.gotoNamed(Routes.DASHBOARD, _context);
        notifyListeners();
      }, failure: (NetworkExceptions error, _, statusMessage) async {
        showToast(this._context, message: 'Please try again');
        isLoading = false;
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

  getUserEmail(String _email) {
    email = _email;
    notifyListeners();
  }

  getUserName(String _name) {
    name = _name;
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

  saveUserEmail(String email) async {
    if (!(_box?.isOpen ?? false))
      _box = await PgHiveBoxes.openBox<String>('userEmail');
    _box.put('email', email);
  }

  getSavedUserEmail() async {
    if (!(_box?.isOpen ?? false))
      _box = await PgHiveBoxes.openBox<String>('userEmail');
    String email = _box.get('email');
    userToken = email;
    notifyListeners();
  }
}
