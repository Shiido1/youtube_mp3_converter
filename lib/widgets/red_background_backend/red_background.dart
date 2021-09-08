import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/red_background_backend/profile.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:provider/provider.dart';
import 'package:mp3_music_converter/widgets/red_background_backend/provider.dart';
import 'package:http/http.dart' as http;

class RedBackground extends StatefulWidget {
  final String text;
  final IconButton iconButton;
  final VoidCallback callback;
  final Widget widgetContainer;

  RedBackground(
      {this.text, this.iconButton, this.callback, this.widgetContainer});

  @override
  _RedBackgroundState createState() => _RedBackgroundState();
}

class _RedBackgroundState extends State<RedBackground> {
  String url;

  @override
  void initState() {
    getNewPicUrl(context);
    Provider.of<RedBackgroundProvider>(context, listen: false).getUrl();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    url = Provider.of<RedBackgroundProvider>(context).url;
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: height < 540 ? 130 : null,
      child: Stack(
        children: [
          Image.asset(
            AppAssets.background,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fitWidth,
          ),
          Container(
            margin: const EdgeInsets.only(left: 24, right: 16, top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    widget.iconButton != null
                        ? IconButton(
                            icon: widget.iconButton, onPressed: widget.callback)
                        : TextViewWidget(text: '', color: AppColor.transparent),
                    widget.text != null
                        ? TextViewWidget(
                            color: AppColor.white,
                            text: widget.text,
                            textSize: 22,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Montserrat')
                        : Image.asset(
                            AppAssets.dashlogo,
                            height: 63,
                          ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [_widgetContainer(url, height)],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _widgetContainer(String picUrl, double height) => InkWell(
        onTap: () async {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ProfilePage()));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            picUrl == null || picUrl == ''
                ? ClipOval(
                    child: SizedBox(
                        height: 50,
                        width: 50,
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                          placeholder: (context, url) =>
                              new CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              new Icon(Icons.error),
                        )),
                  )
                : ClipOval(
                    child: SizedBox(
                      width: height < 540 ? 50 : 65,
                      height: height < 540 ? 50 : 65,
                      child: CachedNetworkImage(
                        imageUrl: url,
                        fit: BoxFit.cover,
                        placeholder: (context, index) => Container(
                          color: Colors.white,
                          child: Center(
                              child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: CircularProgressIndicator())),
                        ),
                        errorWidget: (context, url, error) => Icon(
                          Icons.person,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                'Profile',
                style: TextStyle(
                    fontSize: 17,
                    color: AppColor.white,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Montserrat-Thin'),
              ),
            ),
          ],
        ),
      );
}

getNewPicUrl(context) async {
  String baseUrl = "http://67.205.165.56/api/me";
  String token = await preferencesHelper.getStringValues(key: 'token');

  try {
    final response = await http.post(
      baseUrl,
      body: jsonEncode({'token': token}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      Map decodedResponse = jsonDecode(response.body);
      String picUrl = decodedResponse["profilepic"];
      if (picUrl[0] == "/") picUrl = "https://youtubeaudio.com" + picUrl;
      preferencesHelper.saveValue(key: 'profileImage', value: picUrl);
      Provider.of<RedBackgroundProvider>(context, listen: false)
          .updateUrl(picUrl);
    }
  } catch (e) {
    print(e);
  }
}
