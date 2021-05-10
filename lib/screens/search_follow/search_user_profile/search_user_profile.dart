import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:mp3_music_converter/screens/search_follow/search_user_profile/provider.dart';
import 'package:provider/provider.dart';

import '../search_provider.dart';

class SearchUserProfileClass extends StatefulWidget {
  final String userId;

  SearchUserProfileClass({Key key, this.userId}) : super(key: key);
  @override
  _SearchUserProfileClassState createState() => _SearchUserProfileClassState();
}

class _SearchUserProfileClassState extends State<SearchUserProfileClass> {
  TextEditingController userIdController = TextEditingController();
  // SearchProvider searchProvider;
  SearchUserProfileProvider searchUserProfileProvider;
  // int id;


  @override
  void initState() {
    // searchProvider = Provider.of<SearchProvider>(context, listen: false);
    searchUserProfileProvider = Provider.of<SearchUserProfileProvider>
      (context, listen: false);
    searchUserProfileProvider.init(context);
    searchUserProfileProvider.searchUserProfile(widget.userId);
    // setState(() {
    //   id = int.parse(widget.userId);
    // });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<SearchUserProfileProvider>(builder:(_,provider,__){

      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.bottomRed,
          title: TextViewWidget(
            text: provider?.user?.name??'',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 45,),
            Row(
              children: [
                SizedBox(width: 15,),
                ClipOval(
                    child:SizedBox(
                      height: 90,
                      width: 90,
                    child:CachedNetworkImage(
                        imageUrl:provider?.user?.profilepic??''))),
                SizedBox(width: 45,),
                Column(
                  children: [
                    TextViewWidget(
                        text: provider?.search?.followers==null?'0'
                            :provider?.search?.followers?.toString(),
                        color: AppColor.black,
                        textSize: 20,
                        fontWeight:FontWeight.w600,),
                    SizedBox(height: 8),
                    TextViewWidget(
                        text: 'Followers',
                        color: AppColor.black,
                        textSize: 19.3,
                        fontWeight:FontWeight.w600,),
                  ],
                ),
                SizedBox(width: 16,),
                Column(
                  children: [
                    TextViewWidget(
                        text: provider?.search?.following==null?'0'
                            :provider?.search?.following?.toString(),
                        color: AppColor.black,
                        textSize: 20,
                        fontWeight:FontWeight.w600,),
                    SizedBox(height: 8),
                    TextViewWidget(
                        text: 'Following',
                        color: AppColor.black,
                        textSize: 19.3,
                        fontWeight:FontWeight.w600,),
                  ],
                ),
              ],
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 18),
              child: ElevatedButton(
                onPressed: ()=>provider.follow(provider.user.id),
                    style: TextButton
                        .styleFrom(
                      backgroundColor:
                      provider.isFollow == true?AppColor
                          .background1:AppColor.bottomRed,
                    ),
                child: TextViewWidget(
                text: provider.isFollow == true?
                'Following':'Follow',
                color: AppColor.white,
                textSize: 18,
              )),
            ),
          ],
        ),
      );
    });
  }
}
