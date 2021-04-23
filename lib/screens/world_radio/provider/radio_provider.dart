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
  RadioModel radioModelsItems;

  void init(
      {BuildContext context,
      @required bool search,
      String searchData,
      bool add = false}) {
    this._context = context;
    this._progressIndicator = CustomProgressIndicator(this._context);
    getRadio(
        search: search, searchData: searchData, context: context, add: add);
  }

  getRadio(
      {@required bool search,
      String searchData,
      @required BuildContext context,
      bool add}) async {
    if (search)
      radioX(search: true, searchData: searchData, context: context, add: add);
    if (search == false || radioModels == null)
      radioX(
          search: search, searchData: searchData, context: context, add: add);
  }

  void radioX(
      {@required bool search,
      String searchData,
      @required BuildContext context,
      @required bool add}) async {
    try {
      if (!add) _progressIndicator.show();
      if (add) {
        RadioModel myModel = await _repository.radiox(
            map: Radio.mapToJson(token: token, searchData: searchData),
            search: true,
            context: context,
            add: true);
        if (radioModels == null)
          radioModels = myModel;
        else
          radioModels.radio.addAll(myModel.radio);
      } else {
        if (search) {
          if (radioModels != null) radioModelsItems = radioModels;
          radioModels = await _repository.radiox(
              map: Radio.mapToJson(token: token, searchData: searchData),
              search: true,
              context: context,
              add: false);
        } else {
          RadioModel myModel = await _repository.radiox(
              map: Radio.mapToJson(
                token: token,
              ),
              search: false,
              add: false,
              context: context);
          if (radioModels == null)
            radioModels = myModel;
          else
            radioModels.radio.addAll(myModel.radio);
        }
      }

      if (!add) await _progressIndicator.dismiss();
      notifyListeners();
    } catch (e) {
      if (!add) await _progressIndicator.dismiss();
      if (!add) problem = false;
      print("error $e");
    }
    notifyListeners();
  }
}
