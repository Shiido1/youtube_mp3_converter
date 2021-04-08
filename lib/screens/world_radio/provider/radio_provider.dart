import 'package:flutter/cupertino.dart';
import 'package:mp3_music_converter/screens/world_radio/model/radio_model.dart';
import 'package:mp3_music_converter/screens/world_radio/repo/radio_repo.dart';
import 'package:mp3_music_converter/utils/helper/constant.dart';
import 'package:mp3_music_converter/widgets/progress_indicator.dart';

final RadioRepo _repository = RadioRepo();

class RadioProvider extends ChangeNotifier {
  BuildContext _context;
  CustomProgressIndicator _progressIndicator;
  bool problem = false;
  RadioModel radioModels;
  int index;
  Radio radio;

  void init(BuildContext context) {
    this._context = context;
    this._progressIndicator = CustomProgressIndicator(this._context);
    getRadio();
  }

  getRadio() async {
    if (radioModels == null) radioX();
  }

  void radioX() async {
    try {
      _progressIndicator.show();
      radioModels = await _repository.radiox(
          map: Radio.mapToJson(
        token: token,
      ));
      await _progressIndicator.dismiss();
    } catch (e) {
      await _progressIndicator.dismiss();
      problem = false;
      print("error $e");
      notifyListeners();
    }
  }
}
