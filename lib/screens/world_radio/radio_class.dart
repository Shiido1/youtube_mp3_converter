import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mp3_music_converter/screens/dashboard/sample_dashboard.dart';
import 'package:mp3_music_converter/screens/world_radio/provider/radio_provider.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/constant.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/red_background.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:provider/provider.dart';

class RadioClass extends StatefulWidget {
  final List<Radio> radios;

  const RadioClass({Key key, this.radios}) : super(key: key);

  @override
  _RadioClassState createState() => _RadioClassState();
}

class _RadioClassState extends State<RadioClass>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  RadioProvider _radioProvider;

  @override
  void initState() {
    super.initState();
    _radioProvider = Provider.of<RadioProvider>(context, listen: false);
    _radioProvider.init(context);
    _radioProvider.radioX(token);

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
    return Scaffold(body: Consumer<RadioProvider>(
      builder: (_, model, __) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: AppColor.background1,
          child: SingleChildScrollView(
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
                      MaterialPageRoute(builder: (context) => Sample()),
                    ),
                  ),
                  text: 'Radio World Wide',
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
                                text: model?.radioModel?.name ?? '',
                                color: Colors.white,
                                textSize: 20,
                                fontWeight: FontWeight.bold),
                            TextViewWidget(
                              text: model?.radioModel?.countryName ?? '',
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
        );
      },
    ));
  }
}
