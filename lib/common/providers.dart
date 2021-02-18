import 'package:mp3_music_converter/screens/converter/provider/converter_provider.dart';
import 'package:mp3_music_converter/screens/login/provider/login_provider.dart';
import 'package:mp3_music_converter/screens/otp/provider/otp_provider.dart';
import 'package:mp3_music_converter/screens/signup/provider/sign_up_provider.dart';
import 'package:mp3_music_converter/utils/helper/timer_helper.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class Providers {
  static List<SingleChildWidget> getProviders = [
    ChangeNotifierProvider<LoginProviders>(create: (_) => LoginProviders()),
    ChangeNotifierProvider<SignUpProviders>(create: (_) => SignUpProviders()),
    ChangeNotifierProvider<OtpProviders>(create: (_) => OtpProviders()),
    ChangeNotifierProvider<UtilityProvider>(create: (_) => UtilityProvider()),
    ChangeNotifierProvider<ConverterProvider>(
        create: (_) => ConverterProvider()),
    // ChangeNotifierProvider<FileDownloaderProvider>(
    //     create: (_) => FileDownloaderProvider()),
  ];
}
