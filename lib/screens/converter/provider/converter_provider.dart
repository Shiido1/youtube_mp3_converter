import 'package:flutter/cupertino.dart';
import 'package:jaynetwork/network/network_exceptions.dart';
import 'package:mp3_music_converter/screens/converter/model/youtube_model.dart';
import 'package:mp3_music_converter/screens/converter/repository/repo_converter.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/widgets/progress_indicator.dart';

final ConverterRepo _repository = ConverterRepo();

class ConverterProvider extends ChangeNotifier {
  BuildContext _context;
  CustomProgressIndicator _progressIndicator;
  YoutubeModel youtubeModel = YoutubeModel();

  void init(BuildContext context) {
    this._context = context;
    this._progressIndicator = CustomProgressIndicator(this._context);
  }

  void convert(String url) async {
    try {
      _progressIndicator.show();
      final _response =
          await _repository.convert(YoutubeModel.mapToJson(url: url));
      _response.when(success: (success, _, __) async {
        await _progressIndicator.dismiss();
        youtubeModel = success;
        notifyListeners();
      }, failure: (NetworkExceptions error, _, statusMessage) async {
        await _progressIndicator.dismiss();
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
