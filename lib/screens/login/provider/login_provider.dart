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
        showToast(this._context, message: 'Successfully Logged in..');
        isLoading = false;
        preferencesHelper.saveValue(key: 'email', value: map['email']);

        await PageRouter.gotoNamed(Routes.DASHBOARD, _context);
        notifyListeners();
      }, failure: (NetworkExceptions error, _, statusMessage) async {
        showToast(this._context, message: 'Please try again');
        isLoading = false;
        notifyListeners();
      });
    } catch (e) {
      isLoading = false;
      showToast(_context, message: "Please connect to internet");
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
    notifyListeners();
  }

  // saveUserEmail(String email) async {
  //   if (!(_box?.isOpen ?? false))
  //     _box = await PgHiveBoxes.openBox<String>('userEmail');
  //   _box.put('email', email);
  // }

  // getSavedUserEmail() async {
  //   if (!(_box?.isOpen ?? false))
  //     _box = await PgHiveBoxes.openBox<String>('userEmail');
  //   String email = _box.get('email');
  //   userToken = email;
  //   notifyListeners();
  // }
}
