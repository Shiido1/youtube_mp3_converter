import 'package:flutter/cupertino.dart';
import 'package:mp3_music_converter/screens/login/provider/login_provider.dart';
import 'package:mp3_music_converter/screens/world_radio/model/radio_model.dart';
import 'package:mp3_music_converter/screens/world_radio/repo/radio_repo.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';

final RadioRepo _repository = RadioRepo();

class RadioProvider extends ChangeNotifier {
  BuildContext _context;
  bool problem = false;
  RadioModel radioModels;
  RadioModel radioModelsItems;
  bool showAllChannels = false;
  LoginProviders login;
  bool isLoading = true;

  updateShowAllChannels(bool value) {
    this.showAllChannels = value;
  }

  updateIsLoading(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  updateIsLoadingWithoutListener(bool isLoading) {
    this.isLoading = isLoading;
  }

  void init({
    BuildContext context,
    @required bool search,
    String searchData,
  }) {
    this._context = context;
    getRadio(
      search: search,
      searchData: searchData,
      context: _context,
    );
  }

  getRadio({
    @required bool search,
    String searchData,
    @required BuildContext context,
  }) async {
    if (search)
      radioX(
        search: true,
        searchData: searchData,
        context: context,
      );
    if (search == false || radioModels == null)
      radioX(
        search: search,
        searchData: searchData,
        context: context,
      );
  }

  void radioX({
    @required bool search,
    String searchData,
    @required BuildContext context,
  }) async {
    String _token = await preferencesHelper.getStringValues(key: 'token');
    if (search) {
      if (radioModels != null) radioModelsItems = radioModels;
      try {
        RadioModel radioModelsPlaceHolder = await _repository.radiox(
          map: Radio.mapToJson(token: _token, searchData: searchData),
          search: true,
          context: context,
        );

        for (int i = 0; i < radioModelsPlaceHolder.radio.length; i++) {
          if (i == radioModelsPlaceHolder.radio.length)
            break;
          else if (radioModelsPlaceHolder.radio[i].uid ==
              radioModelsPlaceHolder.radio[i + 1].uid)
            radioModelsPlaceHolder.radio.removeAt(i);
        }
        radioModels = radioModelsPlaceHolder;

        print('this is the model: ${radioModels.radio}');
        isLoading = false;
        notifyListeners();
      } catch (e) {
        isLoading = false;
        notifyListeners();
      }
    } else {
      try {
        RadioModel myModel = await _repository.radiox(
            map: Radio.mapToJson(
              token: _token,
            ),
            search: false,
            context: context);
             for (int i=0; i<myModel.radio.length; i++) {
          if (i== myModel.radio.length) break;
          else if (myModel.radio[i].uid == myModel.radio[i+1].uid)
          myModel.radio.removeAt(i);
        }

        if (radioModels == null)
          radioModels = myModel;
        else
          radioModels.radio.addAll(myModel.radio);
        isLoading = false;
        notifyListeners();
      } catch (e) {
        isLoading = false;
        notifyListeners();
      }
    }
  }
}
