import 'package:flutter/cupertino.dart';
import 'package:mp3_music_converter/screens/login/provider/login_provider.dart';
import 'package:mp3_music_converter/screens/search_follow/search_user_profile/repo.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/widgets/progress_indicator.dart';
import 'package:provider/provider.dart';
import 'package:mp3_music_converter/screens/search_follow/model/follow_model.dart';
import 'model.dart';

SearchUserProfileRepo searchUserProfileRepo = SearchUserProfileRepo();

class SearchUserProfileProvider extends ChangeNotifier {
  BuildContext _context;
  CustomProgressIndicator _progressIndicator;
  // SearchUserProfile user;
  SearchUserProfile search;
  var value;
  bool isFollow = false;
  FollowModel modelFollow;

  void init(BuildContext context) {
    this._context = context;
    this._progressIndicator = CustomProgressIndicator(this._context);
  }

  Future<void> searchUserProfile(String userId) async {
    try {
      _progressIndicator.show();
      search = await searchUserProfileRepo.searchUserProfile(userId);
      _progressIndicator.dismiss();
      notifyListeners();
    } catch (e) {
      _progressIndicator.dismiss();
      showToast(_context, message: "please try again");
      notifyListeners();
    }
  }

  Future<void> follow(int id) async {
    await Provider.of<LoginProviders>(_context, listen: false)
        .getSavedUserToken();
    String _token = Provider.of<LoginProviders>(_context, listen: false).userToken;
    final map = {
      "token": _token,
      "id": id
    };
    try {
      _progressIndicator.show();
      modelFollow = await searchUserProfileRepo.follow(map);
      _progressIndicator.dismiss();
      isFollow = true;
      notifyListeners();
    } catch (e) {
      _progressIndicator.dismiss();
      return e;
    }
  }

  Future<void> unFollow(int id) async {
    await Provider.of<LoginProviders>(_context, listen: false)
        .getSavedUserToken();
    String _token = Provider.of<LoginProviders>(_context, listen: false).userToken;
    final map = {
      "token": _token,
      "id": id
    };
    try {
      _progressIndicator.show();
      modelFollow = await searchUserProfileRepo.unFollow(map);
      _progressIndicator.dismiss();
      isFollow = false;
      notifyListeners();
    } catch (e) {
      _progressIndicator.dismiss();
      return e;
    }
  }
}
