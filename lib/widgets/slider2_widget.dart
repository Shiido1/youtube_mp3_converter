import 'package:flutter/material.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:mp3_music_converter/screens/song/provider/music_provider.dart';
import 'package:provider/provider.dart';

class SliderClass2 extends StatefulWidget {
  @override
  _SliderClass2State createState() => _SliderClass2State();
}

class _SliderClass2State extends State<SliderClass2> {
  bool isPlay;
  String mp3 = '';

  MusicProvider musicProvider;
  double val = 0.0;

  @override
  void initState() {
    super.initState();
    musicProvider = Provider.of<MusicProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicProvider>(builder: (_, provider, __) {
      return Container(
        width: 300,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            TextViewWidget(
              text: '${provider.progress.toString().split(".")[0]}',
              textSize: 16,
              color: AppColor.white,
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: Slider(
                  activeColor: AppColor.bottomRed,
                  inactiveColor: AppColor.white,
                  value: provider.progress.inSeconds.toDouble(),
                  min: 0.0,
                  max: provider.totalDuration.inSeconds.toDouble(),
                  onChanged: (double value) {
                    setState(() {
                      provider.seekToSecond(value.toInt());
                      val = value;
                    });
                  }),
            ),
            TextViewWidget(
              text: '${provider.totalDuration.toString().split(".")[0]}',
              textSize: 16,
              textAlign: TextAlign.center,
              color: AppColor.white,
            ),
          ],
        ),
      );
    });
  }
}
