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
        radioModels = await _repository.radiox(
          map: Radio.mapToJson(token: _token, searchData: searchData),
          search: true,
          context: context,
        );

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
