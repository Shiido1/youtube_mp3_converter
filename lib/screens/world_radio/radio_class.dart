import 'package:flutter/material.dart';
import 'package:flutter_radio/flutter_radio.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mp3_music_converter/screens/dashboard/main_dashboard.dart';
import 'package:mp3_music_converter/screens/world_radio/model/radio_model.dart';
import 'package:mp3_music_converter/screens/world_radio/provider/radio_provider.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/red_background.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:provider/provider.dart';

class RadioClass extends StatefulWidget {
  @override
  _RadioClassState createState() => _RadioClassState();
}

class _RadioClassState extends State<RadioClass>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  RadioProvider _radioProvider;
  bool tap = false;
  String radioFile = '', radioMp3 = '';
  bool isPlaying = false;
  bool isVisible = true;

  @override
  void initState() {
    _radioProvider = Provider.of<RadioProvider>(context, listen: false);
    _radioProvider.init(context);
    audioStart();

    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> audioStart() async {
    await FlutterRadio.audioStart();
    print('Audio Start OK');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: AppColor.background1,
      child: Column(
        children: [
          RedBackground(
            iconButton: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_outlined,
                color: AppColor.white,
              ),
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MainDashBoard()),
              ),
            ),
            text: 'Radio World Wide',
          ),
          Expanded(
            child: Stack(
              children: [
                Center(
                  child: AnimatedBuilder(
                      animation: _controller,
                      builder: (_, child) {
                        return Transform.rotate(
                          angle: _controller.value * 2 * 3.145,
                          child: child,
                        );
                      },
                      child: Image.asset(
                        AppAssets.globe,
                        height: 350,
                        width: 350,
                      )),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 45,
                        width: 230,
                        color: Colors.red[200],
                        child: Center(
                          child: TextViewWidget(
                            color: AppColor.white,
                            text: 'Lagos',
                          ),
                        ),
                      ),
                      tap == true
                          ? Container(
                              height: 340,
                              width: 230,
                              color: AppColor.black2,
                              child: (_radioProvider
                                              ?.radioModels?.radio?.length ??
                                          0) >
                                      0
                                  ? ListView.builder(
                                      itemCount: _radioProvider
                                              ?.radioModels?.radio?.length ??
                                          0,
                                      itemBuilder: (context, index) {
                                        var _radioLog = _radioProvider
                                            .radioModels.radio[index];
                                        return InkWell(
                                          onTap: () {
                                            setState(() {
                                              radioFile = _radioLog.name;
                                              radioMp3 = _radioLog.mp3;
                                            });
                                          },
                                          child: Column(
                                            children: [
                                              TextViewWidget(
                                                text: _radioLog.name,
                                                color: AppColor.white,
                                                textSize: 16,
                                              ),
                                              Divider(
                                                  thickness: 1,
                                                  color: AppColor.white)
                                            ],
                                          ),
                                        );
                                      })
                                  : Center(
                                      child: Text(
                                        'No Station',
                                        style: TextStyle(color: AppColor.white),
                                      ),
                                    ),
                            )
                          : Container(),
                      Container(
                        width: 230,
                        height: 50,
                        color: Colors.red[400],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  tap = !tap;
                                });
                              },
                              child: SvgPicture.asset(
                                AppAssets.bookmark,
                                height: 25,
                                width: 25,
                              ),
                            ),
                            SvgPicture.asset(
                              AppAssets.favourite,
                              height: 25,
                              width: 25,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(color: AppColor.black2),
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextViewWidget(
                        text: '$radioFile',
                        color: Colors.white,
                        textSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // SvgPicture.asset(AppAssets.previous,
                          //     height: 30, width: 30),
                          // SizedBox(
                          //   width: 7,
                          // ),
                          // SvgPicture.asset(AppAssets.play, height: 45, width: 45),
                          IconButton(
                              icon: Icon(
                                Icons.skip_previous_outlined,
                                color: AppColor.white,
                                size: 48,
                              ),
                              onPressed: () {}),

                          IconButton(
                            icon: isPlaying
                                ? Icon(
                                    Icons.pause_circle_outline,
                                    size: 48,
                                    color: Colors.white,
                                  )
                                : Icon(
                                    Icons.play_circle_outline,
                                    color: Colors.white,
                                    size: 48,
                                  ),
                            onPressed: () {
                              setState(() {
                                isPlaying = !isPlaying;
                                isVisible = !isVisible;
                                isPlaying == false
                                    ? FlutterRadio.pause(url: radioMp3)
                                    : FlutterRadio.play(url: radioMp3);
                              });
                            },
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.skip_next_outlined,
                                size: 48,
                                color: AppColor.white,
                              ),
                              onPressed: () {}),
                          // SizedBox(
                          //   width: 7,
                          // ),
                          // SvgPicture.asset(AppAssets.next,
                          //     height: 30, width: 30),
                          // SizedBox(
                          //   width: 6,
                          // ),
                          // SvgPicture.asset(AppAssets.favorite,
                          //     height: 30, width: 30),
                          // // SizedBox(
                          //   width: 5,
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
