import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:jaynetwork/jaynetwork.dart';
import 'package:mp3_music_converter/database/hive_boxes.dart';
import 'package:mp3_music_converter/screens/login/model/login_model.dart';
import 'package:mp3_music_converter/screens/login/repository/login_repo.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/utils/helper/pref_manager.dart';
import 'package:mp3_music_converter/utils/page_router/navigator.dart';

LoginApiRepository _repository = LoginApiRepository();

class LoginProviders extends ChangeNotifier {
  BuildContext _context;
  bool isLoading = false;
  String userToken;
  Box<String> _box;
  String email = '';
  String name = '';
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
        preferencesHelper.saveValue(key: 'email', value: map['email']);

        await PageRouter.gotoNamed(Routes.DASHBOARD, _context);
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
  }

  saveUserEmail(String userEmail) async {
    if (!(_box?.isOpen ?? false))
      _box = await PgHiveBoxes.openBox<String>('email');
    _box.put('email', userEmail);
  }

  getSavedUserEmail() async {
    if (!(_box?.isOpen ?? false))
      _box = await PgHiveBoxes.openBox<String>('email');
    String emailAd = _box.get('email');
    email = emailAd;
    notifyListeners();
  }

  saveUserName(String username) async {
    if (!(_box?.isOpen ?? false))
      _box = await PgHiveBoxes.openBox<String>('name');
    _box.put('name', username);
  }

  getSavedUserName() async {
    if (!(_box?.isOpen ?? false))
      _box = await PgHiveBoxes.openBox<String>('name');
    String nameAd = _box.get('name');
    name = nameAd;
    notifyListeners();
  }
}
