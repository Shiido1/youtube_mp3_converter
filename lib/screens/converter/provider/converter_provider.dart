import 'package:flutter/cupertino.dart';
import 'package:jaynetwork/network/network_exceptions.dart';
import 'package:mp3_music_converter/save_convert/model/save_convert_model.dart';
import 'package:mp3_music_converter/save_convert/repo/save_convert_repo.dart';
import 'package:mp3_music_converter/screens/converter/model/youtube_model.dart';
import 'package:mp3_music_converter/screens/converter/repository/repo_converter.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/widgets/progress_indicator.dart';

final ConverterRepo _repository = ConverterRepo();
final SaveConvertRepo _saveConvertRepo = SaveConvertRepo();

class ConverterProvider extends ChangeNotifier {
  BuildContext _context;
  CustomProgressIndicator _progressIndicator;
  YoutubeModel youtubeModel = YoutubeModel();
  SaveConvert _saveConvert = SaveConvert();
  bool problem = false;

  void init(BuildContext context) {
    this._context = context;
    this._progressIndicator = CustomProgressIndicator(this._context);
  }

  void convert(String url, int id) async {
    try {
      _progressIndicator.show();
      final _response =
          await _repository.convert(YoutubeModel.mapToJson(url: url, id: id));
      _response.when(success: (success, _, statusMessage) async {
        await _progressIndicator.dismiss();
        youtubeModel = success;
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
