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

  void init({BuildContext context, @required bool search, String searchData}) {
    this._context = context;
    this._progressIndicator = CustomProgressIndicator(this._context);
    getRadio(search: search, searchData: searchData, context: context);
  }

  getRadio(
      {@required bool search,
      String searchData,
      @required BuildContext context}) async {
    if (search) radioX(search: true, searchData: searchData, context: context);
    if (search == false || radioModels == null)
      radioX(search: search, searchData: searchData, context: context);
  }

  void radioX(
      {@required bool search,
      String searchData,
      @required BuildContext context}) async {
    try {
      _progressIndicator.show();
      radioModels = search
          ? await _repository.radiox(
              map: Radio.mapToJson(token: token, searchData: searchData),
              search: true,
              context: context)
          : await _repository.radiox(
              map: Radio.mapToJson(
                token: token,
              ),
              search: false,
              context: context);
      await _progressIndicator.dismiss();
    } catch (e) {
      await _progressIndicator.dismiss();
      problem = false;
      print("error $e");
    }
    notifyListeners();
  }
}
