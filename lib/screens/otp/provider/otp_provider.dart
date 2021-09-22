import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jaynetwork/jaynetwork.dart';
import 'package:mp3_music_converter/screens/dashboard/main_dashboard.dart';
import 'package:mp3_music_converter/screens/otp/model/otp_model.dart';
import 'package:mp3_music_converter/screens/otp/repository/otp_repo.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';
import 'package:mp3_music_converter/utils/page_router/navigator.dart';
import 'package:mp3_music_converter/widgets/progress_indicator.dart';
import 'package:mp3_music_converter/widgets/red_background_backend/provider.dart';
import 'package:provider/provider.dart';

final OtpApiRepository _repository = OtpApiRepository();

class OtpProviders extends ChangeNotifier {
  BuildContext _context;
  CustomProgressIndicator _progressIndicator;

  HttpsCallable callable =
      FirebaseFunctions.instance.httpsCallable('createUser');

  void init(BuildContext context) {
    this._context = context;
    this._progressIndicator = CustomProgressIndicator(this._context);
  }

  void verifyOtp({@required Map map}) async {
    try {
      _progressIndicator.show();
      final _response = await _repository.verify(data: map);
      _response.when(success: (OtpModel success, data, __) async {
        await _progressIndicator.dismiss();

        callable.call({
          'name': success.name,
          'id': success.id,
          'url': success.profilepic
        });

        preferencesHelper.saveValue(key: 'token', value: success.token);
        preferencesHelper.saveValue(key: 'id', value: success.id);
        preferencesHelper.saveValue(key: 'name', value: success.name);
        preferencesHelper.saveValue(key: 'email', value: success.email);
        Provider.of<RedBackgroundProvider>(this._context, listen: false)
            .updateUrl(success.profilepic);
        showToast(this._context, message: success.message);

        Navigator.pushAndRemoveUntil(
            _context,
            MaterialPageRoute(builder: (_) => MainDashBoard()),
            (route) => false);

        // PageRouter.gotoNamed(Routes.DASHBOARD, _context);
      }, failure: (NetworkExceptions error, _, statusMessage) {
        _progressIndicator.dismiss();
        showToast(this._context,
            message: NetworkExceptions.getErrorMessage(error));
      });
    } catch (e) {
      _progressIndicator.dismiss();
      debugPrint('Error: $e');
    }
  }

  void resendOtp({@required Map map}) async {
    try {
      _progressIndicator.show();
      final _response = await _repository.verify(data: map);
      _response.when(success: (OtpModel success, data, __) async {
        await _progressIndicator.dismiss();
        showToast(this._context, message: success.message);
        print('successful');
        PageRouter.gotoNamed(Routes.DASHBOARD, _context);
      }, failure: (NetworkExceptions error, _, statusMessage) {
        _progressIndicator.dismiss();
        showToast(this._context,
            message: NetworkExceptions.getErrorMessage(error));
      });
    } catch (e) {
      _progressIndicator.dismiss();
      debugPrint('Error: $e');
    }
  }
}
