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

  void init(
      {BuildContext context,
      @required bool search,
      String searchData,
      bool add = false,
      bool firstSearch = false}) {
    this._context = context;
    this._progressIndicator = CustomProgressIndicator(this._context);
    getRadio(
        search: search,
        searchData: searchData,
        context: context,
        add: add,
        firstSearch: firstSearch);
  }

  getRadio(
      {@required bool search,
      String searchData,
      @required BuildContext context,
      bool add,
      bool firstSearch}) async {
    if (search)
      radioX(
          search: true,
          searchData: searchData,
          context: context,
          add: add,
          firstSearch: firstSearch);
    if (search == false || radioModels == null)
      radioX(
          search: search,
          searchData: searchData,
          context: context,
          add: add,
          firstSearch: firstSearch);
  }

  void radioX(
      {@required bool search,
      String searchData,
      @required BuildContext context,
      @required bool add,
      bool firstSearch}) async {
    try {
      await Provider.of<LoginProviders>(context, listen: false)
          .getSavedUserToken();
      String _token = Provider.of<LoginProviders>(context, listen: false).userToken;
      if (add) {
        print('print token here $_token');
        RadioModel myModel = await _repository.radiox(
            map: Radio.mapToJson(
                token: _token,
                searchData: searchData),
            search: true,
            context: context,
            add: true);
        if (radioModels == null)
          radioModels = myModel;
        else
          radioModels.radio.addAll(myModel.radio);
      } else {
        if (search) {
          _progressIndicator.show();
          if (radioModels != null) radioModelsItems = radioModels;
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
        } else {
          _progressIndicator.show();
          RadioModel myModel = await _repository.radiox(
              map: Radio.mapToJson(
                token: Provider.of<LoginProviders>(context, listen: false)
                    .userToken,
              ),
              search: false,
              add: false,
              context: context);
          if (radioModels == null)
            radioModels = myModel;
          else
            radioModels.radio.addAll(myModel.radio);
          _progressIndicator.dismiss();
          notifyListeners();
        }
      }
    } catch (e) {
      if (!add) _progressIndicator.dismiss();
      if (!add) problem = false;
      print("error $e");
    }
    notifyListeners();
  }
}
