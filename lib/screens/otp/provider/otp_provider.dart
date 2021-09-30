import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mp3_music_converter/screens/dashboard/main_dashboard.dart';
import 'package:mp3_music_converter/screens/otp/repository/otp_repo.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';
import 'package:mp3_music_converter/utils/helper/timer_helper.dart';
import 'package:mp3_music_converter/widgets/progress_indicator.dart';
import 'package:mp3_music_converter/widgets/red_background_backend/provider.dart';
import 'package:provider/provider.dart';

final OtpApiRepository _repository = OtpApiRepository();

class OtpProviders extends ChangeNotifier {
  HttpsCallable callable =
      FirebaseFunctions.instance.httpsCallable('createUser');

  void verifyOtp({@required Map map, @required BuildContext context}) async {
    try {
      CustomProgressIndicator(context).show();
      final _response = await _repository.verify(data: map);
      await CustomProgressIndicator(context).dismiss();
      if (_response['status'] == 'success') {
        callable.call({
          'name': _response['data']?.name,
          'id': _response['data']?.id,
          'url': _response['data']?.profilepic
        });

        preferencesHelper.saveValue(
            key: 'token', value: _response['data']?.token);
        preferencesHelper.saveValue(key: 'id', value: _response['data']?.id);
        preferencesHelper.saveValue(
            key: 'name', value: _response['data']?.name);
        preferencesHelper.saveValue(
            key: 'email', value: _response['data']?.email);
        Provider.of<RedBackgroundProvider>(context, listen: false)
            .updateUrl(_response['data']?.profilepic);
        showToast(context, message: _response['data']?.message);

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => MainDashBoard()),
            (route) => false);
      } else
        showToast(context,
            message: _response['data'],
            backgroundColor: Colors.white,
            textColor: Colors.black,
            duration: 4);

      // _response.when(success: (OtpModel success, data, __) async {
      // callable.call({
      //   'name': success.name,
      //   'id': success.id,
      //   'url': success.profilepic
      // });

      // preferencesHelper.saveValue(key: 'token', value: success.token);
      // preferencesHelper.saveValue(key: 'id', value: success.id);
      // preferencesHelper.saveValue(key: 'name', value: success.name);
      // preferencesHelper.saveValue(key: 'email', value: success.email);
      // Provider.of<RedBackgroundProvider>(context, listen: false)
      //     .updateUrl(success.profilepic);
      // showToast(context, message: success.message);

      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(builder: (_) => MainDashBoard()),
      //     (route) => false);

      //   // PageRouter.gotoNamed(Routes.DASHBOARD, _context);
      // }, failure: (NetworkExceptions error, _, statusMessage) {
      //   CustomProgressIndicator(context).dismiss();
      //   showToast(context, message: NetworkExceptions.getErrorMessage(error));
      // });
    } catch (e) {
      CustomProgressIndicator(context).dismiss();
      showToast(
        context,
        message: 'OTP Verification failed',
        backgroundColor: Colors.white,
        textColor: Colors.black,
      );
      debugPrint('Error: $e');
    }
  }

  void resendOtp(
      {@required String email, @required BuildContext context}) async {
    try {
      CustomProgressIndicator(context).show();
      final _response = await _repository.resend(email: email);
      CustomProgressIndicator(context).dismiss();

      if (_response == 'success') {
        showToast(context,
            message: 'OTP resent successfully',
            backgroundColor: Colors.white,
            textColor: Colors.black);
        Provider.of<UtilityProvider>(context, listen: false)
            .startTimer(timeLimit: 4);
      } else
        showToast(context,
            message: 'Could not resend otp',
            backgroundColor: Colors.white,
            textColor: Colors.black);
    } catch (e) {
      CustomProgressIndicator(context).dismiss();
      showToast(context,
          message: 'Could not resend otp',
          backgroundColor: Colors.white,
          textColor: Colors.black);
      debugPrint('Error: $e');
    }
  }
}
