import 'package:mp3_music_converter/screens/converter/provider/converter_provider.dart';
import 'package:mp3_music_converter/screens/login/provider/login_provider.dart';
import 'package:mp3_music_converter/screens/otp/provider/otp_provider.dart';
import 'package:mp3_music_converter/screens/signup/provider/sign_up_provider.dart';
import 'package:mp3_music_converter/screens/splitted/provider/splitted_song_provider.dart';
import 'package:mp3_music_converter/screens/world_radio/provider/radio_play_provider.dart';
import 'package:mp3_music_converter/screens/world_radio/provider/radio_provider.dart';
import 'package:mp3_music_converter/utils/helper/timer_helper.dart';
import 'package:mp3_music_converter/screens/song/provider/music_provider.dart';
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
    ChangeNotifierProvider<RadioProvider>(create: (_) => RadioProvider()),
    ChangeNotifierProvider<MusicProvider>(create: (_) => MusicProvider()),
    ChangeNotifierProvider<RadioPlayProvider>(
        create: (_) => RadioPlayProvider()),
    ChangeNotifierProvider<SplittedSongProvider>(create: (_)=> SplittedSongProvider()),
  ];
}
