import 'package:flutter/cupertino.dart';
import 'package:mp3_music_converter/screens/dashboard/sample_dashboard.dart';
import 'package:mp3_music_converter/screens/login/sign_in_screen.dart';
import 'package:mp3_music_converter/screens/otp/otp_page_success.dart';
import 'package:mp3_music_converter/screens/signup/sign_up_screen.dart';

BuildContext globalContext;
bool hasOpenedLogOutDialog = false;

class Routes {
  static const String DASHBOARD = '/dashboard';
  static const String OTP_SUCCESSFUL = '/otpSuccessful';
  static const String LOGIN = '/login';
  static const String SIGNUP = '/signup';

  static Map<String, Widget Function(BuildContext mainContext)> get getRoutes =>
      {
        DASHBOARD: (BuildContext context) {
          globalContext = context;
          return Sample();
        },
        OTP_SUCCESSFUL: (BuildContext context) {
          globalContext = context;
          return OtpPageSuccessful();
        },
        LOGIN: (BuildContext context) {
          globalContext = context;
          return SignInScreen();
        },
        SIGNUP: (BuildContext context) {
          globalContext = context;
          return SignUpScreen();
        },
      };
}
