import 'package:flutter/cupertino.dart';
import 'package:jaynetwork/network/network_exceptions.dart';
import 'package:mp3_music_converter/screens/world_radio/model/radio_model.dart';
import 'package:mp3_music_converter/screens/world_radio/repo/radio_repo.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/widgets/progress_indicator.dart';

final RadioRepo _repository = RadioRepo();

class RadioProvider extends ChangeNotifier {
  BuildContext _context;
  CustomProgressIndicator _progressIndicator;
  Radio radioModel = Radio();
  bool problem = false;

  void init(BuildContext context) {
    this._context = context;
    this._progressIndicator = CustomProgressIndicator(this._context);
  }

  void radioX(String token) async {
    try {
      _progressIndicator.show();
      final _response = await _repository.radiox(Radio.mapToJson(
        token: token,
      ));
      _response.when(success: (success, _, statusMessage) async {
        await _progressIndicator.dismiss();
        problem = true;
        notifyListeners();
        // _saveConvertRepo.saveConvert(SaveConvert.mapToJson(id: id));
      }, failure: (NetworkExceptions error, _, statusMessage) async {
        await _progressIndicator.dismiss();
        problem = false;
        showToast(this._context, message: statusMessage);
        notifyListeners();
      });
    } catch (e) {
      await _progressIndicator.dismiss();
      showToast(_context,
          message: "please check your url or internet connection");
      notifyListeners();
    }
  }
}
