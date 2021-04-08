import 'package:hive/hive.dart';
import 'package:mp3_music_converter/screens/world_radio/db/radio_hive.dart';
import 'package:mp3_music_converter/screens/world_radio/model/radio_interface.dart';
import 'package:mp3_music_converter/screens/world_radio/model/radio_model.dart';

class RadioService implements RadioInterface {
  Box<Map> _box;

  Future<Box<Map>> openBox() {
    return RadioHiveBox.openRadioBox<Map>(RadioHiveBox.radio);
  }

  @override
  addRadio(Radio favorite) async {
    if (!(_box?.isOpen ?? false)) _box = await openBox();
    return _box.put(favorite.name, favorite.toJson());
  }

  @override
  deleteRadio(String key) async {
    if (!(_box?.isOpen ?? false)) _box = await openBox();
    await _box.delete(key);
  }

  @override
  Future<List<Radio>> getFavoriteRadio() async {
    if (!(_box?.isOpen ?? false)) _box = await openBox();
    return _box.values
        .where((e) => e["favorite"] == true)
        .map((e) => Radio.fromJson(e))
        .toList();
  }
}
