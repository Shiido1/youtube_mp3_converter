import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mp3_music_converter/screens/dashboard/sample_dashboard.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';

class RadioClass extends StatefulWidget {
  @override
  _RadioClassState createState() => _RadioClassState();
}

class _RadioClassState extends State<RadioClass>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: AppColor.background1,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Image.asset('assets/rect.png'),
                  Column(
                    children: [
                      SizedBox(height: 65),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                  icon: Icon(
                                    Icons.arrow_back_ios_sharp,
                                    color: AppColor.white,
                                  ),
                                  onPressed: () => Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Sample()),
                                      )),
                              TextViewWidget(
                                  color: AppColor.white,
                                  text: 'Radio World Wide',
                                  textSize: 20,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Montserrat'),
                            ],
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipOval(
                                child: Image.asset('assets/burna.png'),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: TextViewWidget(
                                    color: AppColor.white,
                                    text: 'Profile',
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Montserrat-Thin'),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
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
              SizedBox(
                height: MediaQuery.of(context).size.height / 7.8,
              ),
              Container(
                decoration: BoxDecoration(color: AppColor.black2),
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, top: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextViewWidget(
                              text: 'Cool FM 96.9',
                              color: Colors.white,
                              textSize: 20,
                              fontWeight: FontWeight.bold),
                          TextViewWidget(
                            text: 'Lagos',
                            color: Colors.white,
                            textSize: 18,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SvgPicture.asset(AppAssets.previous,
                          height: 30, width: 30),
                      SvgPicture.asset(AppAssets.play, height: 45, width: 45),
                      SvgPicture.asset(AppAssets.next, height: 30, width: 30),
                      SizedBox(
                        width: 20,
                      ),
                      SvgPicture.asset(AppAssets.favorite,
                          height: 30, width: 30),
                    ],
                  ),
                ),
              ),
              Divider(color: Colors.white, height: 0.1),
            ],
          ),
        ),
      ),
    );
  }
}
