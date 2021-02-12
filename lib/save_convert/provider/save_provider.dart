import 'package:flutter/cupertino.dart';
import 'package:jaynetwork/network/network_exceptions.dart';
import 'package:mp3_music_converter/save_convert/model/save_convert_model.dart';
import 'package:mp3_music_converter/save_convert/repo/save_convert_repo.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/widgets/progress_indicator.dart';

final SaveConvertRepo _repository = SaveConvertRepo();

class ConverterProvider extends ChangeNotifier {
  BuildContext _context;
  CustomProgressIndicator _progressIndicator;
  SaveConvert saveModel = SaveConvert();
  bool problem = false;

  void init(BuildContext context) {
    this._context = context;
    this._progressIndicator = CustomProgressIndicator(this._context);
  }

  void saveConvert(String id) async {
    try {
      _progressIndicator.show();
      final _response =
      await _repository.saveConvert(id);
      _response.when(success: (success, _, __) async {
        await _progressIndicator.dismiss();
        saveModel = success;
        problem = true;
        notifyListeners();
      }, failure: (NetworkExceptions error, _, statusMessage) async {
        await _progressIndicator.dismiss();
        problem = false;
        showToast(this._context, message: statusMessage ?? '');
        notifyListeners();
      });
    } catch (e) {
      await _progressIndicator.dismiss();
      debugPrint('Error: $e');
      notifyListeners();
    }
  }
}