import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mp3_music_converter/screens/recorded/provider/record_provider.dart';
import 'package:mp3_music_converter/screens/recorded/recorded_drawer.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/icon_button.dart';
import 'package:mp3_music_converter/widgets/slider2_widget.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:provider/provider.dart';
import 'package:mp3_music_converter/screens/recorded/model/recorder_model.dart';

class RecordedScreen extends StatefulWidget {
  final RecorderModel record;
  final bool enabled;
  RecordedScreen({@required this.record, @required this.enabled});
  @override
  _RecordedScreenState createState() => _RecordedScreenState();
}

class _RecordedScreenState extends State<RecordedScreen> {
  RecordProvider _recordProvider;
  bool repeat;

  @override
  void initState() {
    _recordProvider = Provider.of<RecordProvider>(context, listen: false);
    _recordProvider.playerType = PlayerType.ALL;
    _recordProvider.playAudio(widget.record);
    repeat = _recordProvider.repeatRecord;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RecordProvider>(
      builder: (_, _provider, __) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColor.grey,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios_sharp,
                color: AppColor.white,
              ),
            ),
          ),
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: new BoxDecoration(
              color: AppColor.grey,
              image: new DecorationImage(
                fit: BoxFit.cover,
                colorFilter: new ColorFilter.mode(
                    AppColor.black.withOpacity(0.5), BlendMode.dstATop),
                image: new AssetImage(
                  AppAssets.bgImage2,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(35.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 280.0,
                    height: 320.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      image: DecorationImage(
                          image: AssetImage(
                            'assets/log.png',
                          ),
                          fit: BoxFit.contain),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: TextViewWidget(
                      text: _provider?.currentRecord?.name ?? 'unknown',
                      color: AppColor.white,
                      textSize: 18,
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SliderClass3(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(Icons.skip_previous_outlined),
                        onPressed: !_provider.canPrevRecord
                            ? () {
                                _recordProvider.prev();
                                if (repeat)
                                  _recordProvider
                                      .repeat(_recordProvider.currentRecord);
                              }
                            : null,
                        iconSize: 56,
                        color: !_provider.canPrevRecord
                            ? AppColor.white
                            : AppColor.grey,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: IconButt2(widget.enabled),
                      ),
                      SizedBox(
                        width: 28,
                      ),
                      IconButton(
                        icon: Icon(Icons.skip_next_outlined),
                        onPressed: !_provider.canNextRecord
                            ? () {
                                _recordProvider.next();
                                if (repeat)
                                  _recordProvider
                                      .repeat(_recordProvider.currentRecord);
                              }
                            : null,
                        iconSize: 56,
                        color: !_provider.canNextRecord
                            ? AppColor.white
                            : AppColor.grey,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          resizeToAvoidBottomInset: false,
        );
      },
    );
  }
}
