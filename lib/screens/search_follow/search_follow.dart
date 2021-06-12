import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mp3_music_converter/screens/dashboard/main_dashboard.dart';
import 'package:mp3_music_converter/screens/search_follow/search_user_profile/search_user_profile.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/widgets/red_background_backend/red_background.dart';
import 'package:mp3_music_converter/screens/search_follow/search_provider.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:provider/provider.dart';

class SearchFollow extends StatefulWidget {
  @override
  _SearchFollowState createState() => _SearchFollowState();
}

class _SearchFollowState extends State<SearchFollow> {
  SearchProvider searchProvider;
  TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    searchProvider = Provider.of<SearchProvider>(context, listen: false);
    searchProvider.init(context);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  search(String searchText) => searchProvider.search(searchText);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SearchProvider>(builder: (_, provider, __) {
        return Container(
          color: AppColor.background,
          child: Column(
            children: [
              RedBackground(
                iconButton: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_outlined,
                    color: AppColor.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                text: 'Follow',
              ),
              SizedBox(
                height: 45,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12, left: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColor.transparent,
                    border: Border.all(
                      color: AppColor.background1,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  margin: EdgeInsets.all(12),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Icon(
                          Icons.search,
                          color: AppColor.white,
                          size: 20,
                        ),
                      ),
                      new Expanded(
                        child: TextField(
                          // onChanged: (s) {
                          //   searchSong(s);
                          // },
                          controller: controller,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: "Search",
                            labelText:
                                'type the full name of user you want to follow',
                            labelStyle: TextStyle(
                                color: AppColor.background1,
                                fontWeight: FontWeight.w400),
                            hintStyle: TextStyle(color: AppColor.white),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 12),
                            isDense: true,
                          ),
                          style: TextStyle(
                            fontSize: 14.0,
                            color: AppColor.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: ClipOval(
                          child: Material(
                            color: AppColor.transparent, // button color
                            child: InkWell(
                              splashColor: AppColor.white, // inkwell color
                              child: SizedBox(
                                  width: 36,
                                  height: 24,
                                  child: Icon(
                                    Icons.check,
                                    color: AppColor.white,
                                    size: 20,
                                  )),
                              onTap: () => search('${controller.text}'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                child: (provider?.users?.length ?? 0) > 0
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: provider?.users?.length ?? 0,
                          itemBuilder: (context, index) {
                            var searchValue = provider.users[index];
                            bool isNotEmpty = provider.users.isNotEmpty;
                            return ListTile(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => SearchUserProfileClass(
                                          userId: searchValue.id.toString()))),
                              leading: Container(
                                  height: 60,
                                  width: 50,
                                  child: CachedNetworkImage(
                                      imageUrl: searchValue?.profilePic ?? '')),
                              title: isNotEmpty
                                  ? TextViewWidget(
                                      text: searchValue?.name ?? '',
                                      color: AppColor.white,
                                      textSize: 16.5,
                                      fontWeight: FontWeight.w500,
                                    )
                                  : Container(),
                            );
                          },
                        ),
                      )
                    : Center(
                        child: TextViewWidget(
                            text: 'No User',
                            textSize: 16.5,
                            color: AppColor.white)),
              )
            ],
          ),
        );
      }),
    );
  }
}
