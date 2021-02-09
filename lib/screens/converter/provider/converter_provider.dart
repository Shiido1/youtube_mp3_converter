import 'package:flutter/cupertino.dart';
import 'package:jaynetwork/network/network_exceptions.dart';
import 'package:mp3_music_converter/screens/converter/repository/repo_converter.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/widgets/progress_indicator.dart';

final ConverterRepo _repository = ConverterRepo();

class ConverterProvider extends ChangeNotifier {
  BuildContext _context;
  CustomProgressIndicator _progressIndicator;

  void init(BuildContext context) {
    this._context = context;
    this._progressIndicator = CustomProgressIndicator(this._context);
  }

  void convert({@required Map map}) async {
    try {
      _progressIndicator.show();
      final _response = await _repository.convert(data: map);
      _response.when(success: (success, _, __) async {
        await _progressIndicator.dismiss();
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
