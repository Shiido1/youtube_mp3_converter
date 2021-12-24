import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:mp3_music_converter/screens/bookworm/provider/bookworm_provider.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:provider/provider.dart';

class VoiceSettings extends StatefulWidget {
  // final Function reInitTts;
  // VoiceSettings(this.reInitTts);

  @override
  _VoiceSettingsState createState() => _VoiceSettingsState();
}

class _VoiceSettingsState extends State<VoiceSettings> {
  double pitch = 1.0;
  double rate = 1.0;
  int groupValue = 1;
  FlutterTts flutterTts;
  BookwormProvider bookwormProvider;
  Map<String, String> male = {'name': 'en-gb-x-rjs-network', 'locale': 'en-GB'};
  Map<String, String> female = {
    'name': 'en-gb-x-gba-network',
    'locale': 'en-GB'
  };
  bool isPlaying = false;

  selectVoice(int val) {
    if (!isPlaying) {
      setState(() {
        groupValue = val;
      });
      setVoice(val == 1 ? male : female);
    }
  }

  initTts() async {
    flutterTts = FlutterTts();
    flutterTts.setCompletionHandler(() {
      setState(() {
        isPlaying = false;
      });
    });
    flutterTts.setCancelHandler(() {
      setState(() {
        isPlaying = false;
      });
    });
    flutterTts.setStartHandler(() {
      setState(() {
        isPlaying = true;
      });
    });
  }

  getStoredSettings() async {
    Map voice;
    bool pitchDataExists;
    bool speechRateDataExists;
    if (await preferencesHelper.doesExists(key: 'ttsVoice')) {
      Map data = await preferencesHelper.getCachedData(key: 'ttsVoice');
      voice = {'name': data['name'], 'locale': data['locale']};
      print('this is $voice');
    }
    pitchDataExists = await preferencesHelper.doesExists(key: 'ttsPitch');
    speechRateDataExists = await preferencesHelper.doesExists(key: 'ttsRate');

    groupValue = voice == null || voice['name'] == male['name'] ? 1 : 2;
    pitch = pitchDataExists
        ? await preferencesHelper.getDoubleValues(key: 'ttsPitch')
        : 1.0;
    rate = speechRateDataExists
        ? await preferencesHelper.getDoubleValues(key: 'ttsRate')
        : 1.0;
    setState(() {});
  }

  @override
  void initState() {
    bookwormProvider = Provider.of<BookwormProvider>(context, listen: false);
    initTts();
    getStoredSettings();
    super.initState();
  }

  @override
  void dispose() {
    flutterTts.stop();
    // widget.reInitTts();
    super.dispose();
  }

  setVoice(Map<String, String> voice) async {
    isPlaying = true;
    bookwormProvider.voice = voice;
    await flutterTts.setVoice(voice);
    preferencesHelper.saveValue(key: 'ttsVoice', value: voice);
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.speak('This is YT Audio');
  }

  setSpeechRate(double rate) async {
    isPlaying = true;
    bookwormProvider.rate = rate;
    await flutterTts.setSpeechRate(rate);
    preferencesHelper.saveValue(key: 'ttsRate', value: rate);
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.speak('This is YT Audio');
  }

  setVoicePitch(double pitch) async {
    isPlaying = true;
    bookwormProvider.pitch = pitch;
    await flutterTts.setPitch(pitch);
    preferencesHelper.saveValue(key: 'ttsPitch', value: pitch);
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.speak('This is YT Audio');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawerEnableOpenDragGesture: false,
      backgroundColor: AppColor.white.withOpacity(0.05),
      appBar: AppBar(
        backgroundColor: AppColor.black,
        title: TextViewWidget(
          text: 'Voice settings',
          color: AppColor.bottomRed,
          overflow: TextOverflow.ellipsis,
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: ListView(
          children: [
            Text(
              'Select Voice',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 15),
            Theme(
              data: Theme.of(context).copyWith(
                  unselectedWidgetColor: Colors.white,
                  highlightColor:
                      isPlaying ? Colors.transparent : Colors.white24,
                  splashColor: isPlaying ? Colors.transparent : Colors.white38),
              child: Row(
                children: [
                  Expanded(
                    child: RadioListTile(
                      value: 1,
                      activeColor: Colors.red,
                      groupValue: groupValue,
                      onChanged: selectVoice,
                      title: Text(
                        'Male',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile(
                      activeColor: Colors.red,
                      value: 2,
                      groupValue: groupValue,
                      onChanged: selectVoice,
                      title:
                          Text('Female', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 25),
            Text(
              'Voice Pitch',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 5),
            _pitch(),
            SizedBox(height: 25),
            Text(
              'Speech Rate',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 5),
            _rate(),
          ],
        ),
      ),
    );
  }

  Widget _pitch() {
    return Slider(
      value: pitch,
      min: 0.5,
      max: 2.0,
      divisions: 15,
      label: 'Pitch $pitch',
      activeColor: Colors.red,
      onChangeEnd: setVoicePitch,
      onChangeStart: (val) {
        flutterTts.stop();
      },
      onChanged: (newPitch) {
        setState(() {
          pitch = double.parse(newPitch.toStringAsFixed(2));
        });
      },
    );
  }

  Widget _rate() {
    return Slider(
      value: rate,
      min: 0.0,
      max: 1.0,
      divisions: 10,
      label: 'Rate $rate',
      activeColor: Colors.red,
      onChanged: (newRate) {
        setState(() {
          rate = double.parse(newRate.toStringAsFixed(2));
        });
      },
      onChangeStart: (val) {
        flutterTts.stop();
      },
      onChangeEnd: setSpeechRate,
    );
  }
}
