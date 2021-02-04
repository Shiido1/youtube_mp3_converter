
import 'package:mp3_music_converter/screens/login/provider/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';


class Providers {
  static List<SingleChildWidget> getProviders = [
    ChangeNotifierProvider<LoginProviders>(create: (_) => LoginProviders()),
  ];
}
