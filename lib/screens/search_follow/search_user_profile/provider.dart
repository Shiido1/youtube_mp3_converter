import 'package:flutter/cupertino.dart';
import 'package:mp3_music_converter/screens/search_follow/search_user_profile/repo.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/widgets/progress_indicator.dart';


final SearchUserProfileRepo searchUserProfileRepo = SearchUserProfileRepo();

class SearchUserProfileProvider extends ChangeNotifier{

  BuildContext _context;
  CustomProgressIndicator _progressIndicator;

  void init(BuildContext context) {
    this._context = context;
    this._progressIndicator = CustomProgressIndicator(this._context);
  }

  Future<void> searchUserProfile(String userId) async {
    try{
      _progressIndicator.show();
      await searchUserProfileRepo.searchUserPro(userId);
      _progressIndicator.dismiss();
      notifyListeners();
    }catch(e){
      _progressIndicator.dismiss();
      showToast(_context,
          message: "please try again");
      notifyListeners();
    }
  }

}