import 'package:flutter/cupertino.dart';
import 'package:mp3_music_converter/screens/login/provider/login_provider.dart';
import 'package:mp3_music_converter/screens/search_follow/model.dart';
import 'package:mp3_music_converter/screens/search_follow/search_repository.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/widgets/progress_indicator.dart';
import 'package:provider/provider.dart';

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

  Future<void> follow(int id) async {
    final map ={
      "token":Provider.of<LoginProviders>(_context,listen:false).userToken,
      "id":id
    };
    try{
      _progressIndicator.show();
      if(isFollow=false) value = await searchRepository.follow(map);
      await _progressIndicator.dismiss();
      isFollow = true;
      notifyListeners();
    }catch(e) {
      return throw e;
    }
  }

  Future<void> unFollow(int id) async {
    final map ={
      "token":Provider.of<LoginProviders>(_context,listen:false).userToken,
      "id":id
    };
    try{
      _progressIndicator.show();
      if(isFollow=true) value = await searchRepository.unFollow(map);
      await _progressIndicator.dismiss();
      isFollow = false;
      notifyListeners();
    }catch(e) {
      return throw e;
    }
  }
}