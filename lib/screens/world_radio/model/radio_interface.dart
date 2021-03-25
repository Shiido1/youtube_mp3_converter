import 'package:mp3_music_converter/screens/world_radio/model/radio_model.dart';

abstract class RadioInterface {
  addRadio(Radio favourite);
  Future<List<Radio>> getFavoriteRadio();
  deleteRadio(String key);
}
