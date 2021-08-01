import 'package:flutter/cupertino.dart';
import 'package:mp3_music_converter/bottom_navigation/playlist.dart';
import 'package:mp3_music_converter/screens/change_password/change_password.dart';
import 'package:mp3_music_converter/screens/dashboard/main_dashboard.dart';
import 'package:mp3_music_converter/screens/login/sign_in_screen.dart';
import 'package:mp3_music_converter/screens/signup/sign_up_screen.dart';

BuildContext globalContext;
bool hasOpenedLogOutDialog = false;

class Routes {
  static const String DASHBOARD = '/dashboard';
  static const String OTP_SUCCESSFUL = '/otpSuccessful';
  static const String LOGIN = '/login';
  static const String SIGNUP = '/signup';
  static const String PLAYLIST = '/playlist';
  static const String SONGSCREEN = '/song_screen';
  static const String CHANGEPASSWORD = '/change_password';

  static Map<String, Widget Function(BuildContext mainContext)> get getRoutes =>
      {
        DASHBOARD: (BuildContext context) {
          globalContext = context;
          return MainDashBoard();
        },
        PLAYLIST: (BuildContext context) {
          globalContext = context;
          return PlayList();
        },
        LOGIN: (BuildContext context) {
          globalContext = context;
          return SignInScreen();
        },
        SIGNUP: (BuildContext context) {
          globalContext = context;
          return SignUpScreen();
        },
        CHANGEPASSWORD: (BuildContext context) {
          globalContext = context;
          return ChangePassword();
        },
      };
}
