import 'package:flutter/cupertino.dart';
import 'package:mp3_music_converter/screens/search_follow/model.dart';
import 'package:mp3_music_converter/screens/search_follow/search_repository.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/widgets/progress_indicator.dart';

final SearchRepository searchRepository = SearchRepository();

class SearchProvider extends ChangeNotifier{
  BuildContext _context;
  List<Users> users;
  CustomProgressIndicator _progressIndicator;
  var value;
  bool isFollow=false;
  Users user = Users();


  void init(BuildContext context) {
    this._context = context;
    this._progressIndicator = CustomProgressIndicator(this._context);
  }

  void search(String userName) async{
    try{
      _progressIndicator.show();
      users = await searchRepository.searchUser(userName);
      _progressIndicator.dismiss();
      notifyListeners();
    }catch(e){
      _progressIndicator.dismiss();
      showToast(_context,
          message: "please check network connection");
      notifyListeners();
    }

  }

  Future<void> follow(Map map) async {
    try{
      _progressIndicator.show();
      if(isFollow=false)
        value = await searchRepository.follow(map);
      await _progressIndicator.dismiss();
      isFollow = true;
      notifyListeners();
    }catch(e) {
      return throw e;
    }
  }

  Future<void> unFollow(Map map) async {
    try{
      _progressIndicator.show();
      if(isFollow=true)
        value = await searchRepository.unFollow(map);
      await _progressIndicator.dismiss();
      isFollow = false;
      notifyListeners();
    }catch(e) {
      return throw e;
    }
  }
}