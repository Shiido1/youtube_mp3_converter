import 'package:flutter/cupertino.dart';
import 'package:mp3_music_converter/screens/login/provider/login_provider.dart';
import 'package:mp3_music_converter/screens/world_radio/model/radio_model.dart';
import 'package:mp3_music_converter/screens/world_radio/repo/radio_repo.dart';
import 'package:mp3_music_converter/widgets/progress_indicator.dart';
import 'package:provider/provider.dart';

final RadioRepo _repository = RadioRepo();

class RadioProvider extends ChangeNotifier {
  BuildContext _context;
  CustomProgressIndicator _progressIndicator;
  bool problem = false;
  RadioModel radioModels;
  RadioModel radioModelsItems;
  bool showAllChannels = false;
  LoginProviders login;

  updateShowAllChannels(bool value) {
    this.showAllChannels = value;
    // notifyListeners();
  }

  void init({
    BuildContext context,
    @required bool search,
    String searchData,
    bool add = false,
  }) {
    this._context = context;
    this._progressIndicator = CustomProgressIndicator(this._context);
    getRadio(
      search: search,
      searchData: searchData,
      context: context,
      add: add,
    );
  }

  getRadio({
    @required bool search,
    String searchData,
    @required BuildContext context,
    bool add,
  }) async {
    if (search)
      radioX(
        search: true,
        searchData: searchData,
        context: context,
        add: add,
      );
    if (search == false || radioModels == null)
      radioX(
        search: search,
        searchData: searchData,
        context: context,
        add: add,
      );
  }

  void radioX({
    @required bool search,
    String searchData,
    @required BuildContext context,
    @required bool add,
  }) async {
    await Provider.of<LoginProviders>(context, listen: false)
        .getSavedUserToken();
    String _token =
        Provider.of<LoginProviders>(context, listen: false).userToken;
    if (add) {
      try {
        RadioModel myModel = await _repository.radiox(
            map: Radio.mapToJson(token: _token, searchData: searchData),
            search: true,
            context: context,
            add: true);
        if (radioModels == null)
          radioModels = myModel;
        else
          radioModels.radio.addAll(myModel.radio);
      } catch (e) {
        print(e);
      }
    } else {
      if (search) {
        _progressIndicator.show();
        if (radioModels != null) radioModelsItems = radioModels;
        try {
          radioModels = await _repository.radiox(
              map: Radio.mapToJson(
                  token: Provider.of<LoginProviders>(context, listen: false)
                      .userToken,
                  searchData: searchData),
              search: true,
              context: context,
              add: false);
          _progressIndicator.dismiss();
          notifyListeners();
        } catch (e) {
          _progressIndicator.dismiss();
        }
      } else {
        _progressIndicator.show();
        try {
          RadioModel myModel = await _repository.radiox(
              map: Radio.mapToJson(
                token: Provider.of<LoginProviders>(context, listen: false)
                    .userToken,
              ),
              search: false,
              add: false,
              context: context);
          _progressIndicator.dismiss();
          if (radioModels == null)
            radioModels = myModel;
          else
            radioModels.radio.addAll(myModel.radio);
          notifyListeners();
        } catch (e) {
          _progressIndicator.dismiss();
        }
      }
    }
    notifyListeners();
  }
}
