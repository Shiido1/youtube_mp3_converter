import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:mp3_music_converter/screens/search_follow/search_user_profile/provider.dart';
import 'package:provider/provider.dart';

import '../search_provider.dart';

class SearchUserProfileClass extends StatefulWidget {
  final userId;

  SearchUserProfileClass({Key key, this.userId}) : super(key: key);
  @override
  _SearchUserProfileClassState createState() => _SearchUserProfileClassState();
}

class _SearchUserProfileClassState extends State<SearchUserProfileClass> {
  TextEditingController userIdController = TextEditingController();
  SearchProvider searchProvider;
  SearchUserProfileProvider searchUserProfileProvider;
  int id;


  @override
  void initState() {
    searchProvider = Provider.of<SearchProvider>(context, listen: false);
    searchUserProfileProvider = Provider.of<SearchUserProfileProvider>
      (context, listen: false);
    searchUserProfileProvider.init(context);
    searchUserProfileProvider.searchUserProfile(widget.userId);
    setState(() {
      id = int.parse(widget.userId);
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var searchValue = searchProvider.users[id];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.bottomRed,
        title: TextViewWidget(
          text: searchValue?.name??'',
          color: AppColor.white,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_sharp,
            color: AppColor.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Container(
                  height: 60,
                  width: 50,
                  child:CachedNetworkImage(
                      imageUrl:searchValue?.profilePic??''))
            ],
          )
        ],
      ),
    );
  }
}
