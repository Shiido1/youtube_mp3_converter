import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jaynetwork/jaynetwork.dart';
import 'package:mp3_music_converter/screens/change_password/change_password.dart';
import 'package:mp3_music_converter/screens/change_password/repo/change_password_repo.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/utils/page_router/navigator.dart';
import 'package:mp3_music_converter/widgets/progress_indicator.dart';

ChangePasswordRepo changePasswordRepo = ChangePasswordRepo();
class ChangePasswordProvider extends ChangeNotifier{

  BuildContext _context;
  CustomProgressIndicator _progressIndicator;


  void init(BuildContext context) {
    this._context = context;
    this._progressIndicator = CustomProgressIndicator(this._context);
  }

  Future emailOtp(String _email) async {
    try{
      _progressIndicator.show();
      final response = await changePasswordRepo.email(_email);
      response.when(success: (success, _, statusMessage) async{
        await _progressIndicator.dismiss();
        // PageRouter.gotoNamed(Routes.CHANGEPASSWORD, _context, args: _email);
        Navigator.push(_context, MaterialPageRoute(builder: (_) => ChangePassword(email: _email,)));
        notifyListeners();
      }, failure: (NetworkExceptions error, _, statusMessage)async{
        _progressIndicator.dismiss();
        showToast(this._context, message: statusMessage);
        notifyListeners();
      });
    } catch(e){
      return throw e;
    }
  }

  Future otp(Map map) async {
    try{
      _progressIndicator.show();
      final response = await changePasswordRepo.otp(map);
      response.when(success: (success, _, statusMessage) async{
        await _progressIndicator.dismiss();
        showToast(this._context, message: 'Your Password has been reset');
        PageRouter.gotoNamed(Routes.DASHBOARD, _context);
        notifyListeners();
      }, failure: (NetworkExceptions error, _, statusMessage)async{
        _progressIndicator.dismiss();
        showToast(this._context, message: statusMessage);
        notifyListeners();
      });
    } catch(e){
      return throw e;
    }
  }
}