import 'package:flutter/cupertino.dart';
import 'package:jaynetwork/network/network_exceptions.dart';
import 'package:mp3_music_converter/screens/converter/model/youtube_model.dart';
import 'package:mp3_music_converter/screens/converter/repository/repo_converter.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/widgets/progress_indicator.dart';

final ConverterRepo _repository = ConverterRepo();

class ConverterProvider extends ChangeNotifier {
  BuildContext _context;
  YoutubeModel youtubeModel = YoutubeModel();
  bool problem = false;
  CustomProgressIndicator _progressIndicator;

  void init(BuildContext context) {
    this._context = context;
    this._progressIndicator = CustomProgressIndicator(this._context);
  }

  Future convert(String url) async {
    try {
      _progressIndicator.show();
      var _response = await _repository.convert(YoutubeModel.mapToJson(
        url: url,
      ));
      _response.when(success: (success, _, statusMessage) async {
        await _progressIndicator.dismiss();
        youtubeModel = success;

        problem = true;
        notifyListeners();
      }, failure: (NetworkExceptions error, _, statusMessage) async {
        await _progressIndicator.dismiss();
        problem = false;
        showToast(this._context,
            message: NetworkExceptions.getErrorMessage(error));
        notifyListeners();
      });
    } catch (e) {
      _progressIndicator.dismiss();
      showToast(_context,
          message: "please check your url or internet connection");
      notifyListeners();
    }
  }
}
