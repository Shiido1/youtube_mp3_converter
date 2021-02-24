import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mp3_music_converter/save_convert/provider/save_provider.dart';
import 'package:mp3_music_converter/screens/converter/convert.dart';
import 'package:mp3_music_converter/screens/converter/model/downloaded_file_model.dart';
import 'package:mp3_music_converter/screens/converter/model/youtube_model.dart';
import 'package:mp3_music_converter/screens/converter/provider/converter_provider.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/constant.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/bottom_playlist_indicator.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';

class SongViewCLass extends StatefulWidget {
  @override
  _SongViewCLassState createState() => _SongViewCLassState();
}

class _SongViewCLassState extends State<SongViewCLass> {
  SaveConvertProvider _saveConvertProvider;
  ConverterProvider _converterProvider;
  // List<Convert> convert = List();
  var read;
  Convert convert;
  // Future<void> openDb() async {
  //   var saveI = await Hive.openBox('music_db');
  //   save.get('key');
  //   setState(() {
  //     save = saveI;
  //     isSet = true;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    read = Hive.box('music_db');
    // read.get('key');
    // save = read.get('key');
    // return save;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.black,
        title: TextViewWidget(
          text: 'Song',
          color: AppColor.bottomRed,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_sharp,
            color: AppColor.bottomRed,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: _buildListView(),
              // ListView(
              //   children: [1, 2, 3, 4, 5, 6, 7]
              //       .map((mocked) => Column(
              //             children: [
              //               ListTile(
              //                 onTap: () {},
              //                 leading: Image.network(
              //                     _converterProvider?.youtubeModel?.image ??
              //                         ''),
              //                 title: TextViewWidget(
              //                   text: _converterProvider?.youtubeModel?.title ??
              //                       '',
              //                   color: AppColor.white,
              //                   textSize: 18,
              //                 ),
              //                 subtitle: TextViewWidget(
              //                   text: '',
              //                   color: AppColor.white,
              //                   textSize: 14,
              //                 ),
              //                 trailing: SvgPicture.asset(
              //                   AppAssets.dot,
              //                   color: AppColor.white,
              //                 ),
              //               ),
              //               SizedBox(
              //                 height: 3,
              //               ),
              //               Padding(
              //                 padding:
              //                     const EdgeInsets.only(left: 70.0, right: 23),
              //                 child: Divider(
              //                   color: AppColor.white,
              //                 ),
              //               )
              //             ],
              //           ))
              //       .toList(),
              // ),
            ),
            BottomPlayingIndicator()
          ],
        ),
      ),
    );
  }

  Widget _buildListView() {
    return WatchBoxBuilder(
        box: Hive.box('music_db'),
        builder: (context, read) {

          return ListView.builder(
              itemCount: read.length,
              itemBuilder: (context, index) {
                final readItem = DownloadedFile.fromJson(read.getAt(index));

                return Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 60.0,
                      child: ListTile(
                        leading: readItem?.image != null && readItem.image.isNotEmpty
                            ? Image.network(readItem.image)
                            : null,
                        title: TextViewWidget(
                          color: AppColor.white,
                          text: readItem?.title ?? '',
                          textSize: 15,
                        ),
                        trailing: SvgPicture.asset(
                          AppAssets.dot,
                          color: AppColor.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 115.0, right: 15),
                      child: Divider(
                        color: AppColor.white,
                      ),
                    )
                  ],
                );
              });
        });
  }
}