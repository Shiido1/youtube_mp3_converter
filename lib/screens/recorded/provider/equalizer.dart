import 'package:flutter/material.dart';
import 'package:equalizer/equalizer.dart' as equ;
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:hive/hive.dart';
import 'package:mp3_music_converter/screens/recorded/model/recorder_model.dart';
import 'package:mp3_music_converter/screens/recorded/provider/record_provider.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';
import 'package:mp3_music_converter/widgets/bottom_playlist_indicator.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:provider/provider.dart';

class Equalizer extends StatefulWidget {
  Equalizer({Key key}) : super(key: key);

  @override
  _EqualizerState createState() => _EqualizerState();
}

class _EqualizerState extends State<Equalizer> {
  bool enabled = false;
  String _selectedValue;
  Future<List<String>> fetchPresets;
  List<String> presets;
  double min, max;
  Map currentVal = {};
  TextEditingController _equalizerNameController;
  Box equalizerBox;
  List<String> customEqualizers = [];
  List<RecorderModel> recordedSongs = [];
  RecordProvider _recordProvider;
  RecorderModel selectedRecord;

  getCurrentEqualizer() async {
    bool exists = await preferencesHelper.doesExists(key: 'currentEqualizer');
    fetchPresets = equ.Equalizer.getPresetNames();
    if (!(equalizerBox?.isOpen ?? false))
      equalizerBox = await Hive.openBox('equalizerBox');

    fetchPresets.then((value) async {
      if (value != null && value.isNotEmpty) {
        presets = value;
        if (exists) {
          String equalizer =
              await preferencesHelper.getStringValues(key: 'currentEqualizer');
          if (equalizer != null && equalizer.isNotEmpty) {
            if (value.contains(equalizer))
              equ.Equalizer.setPreset(equalizer);
            else {
              Map data = equalizerBox.get(equalizer);

              data.entries.forEach((element) {
                equ.Equalizer.setBandLevel(element.key,
                    double.parse(element.value.toString()).toInt());
              });
            }

            _selectedValue = equalizer;
          }
        }

        if (_selectedValue == null) {
          equ.Equalizer.setPreset(value[0]);
          _selectedValue = value[0];
        }

        setState(() {});
      }
    });
  }

  getCustomEqualizers() async {
    customEqualizers = [];
    if (!(equalizerBox?.isOpen ?? false))
      equalizerBox = await Hive.openBox('equalizerBox');
    List equalizers = equalizerBox.keys.toList();

    if (equalizers.isNotEmpty)
      for (String item in equalizers) {
        customEqualizers.add(item);
      }
  }

  getEnabledStatus() async {
    bool exists = await preferencesHelper.doesExists(key: 'enabled');

    if (exists) {
      bool enb = await preferencesHelper.getBoolValues(key: 'enabled');
      setState(() {
        enabled = enb;
      });
      equ.Equalizer.setEnabled(enb);
    } else {
      setState(() {
        enabled = false;
      });
      equ.Equalizer.setEnabled(false);
    }
  }

  @override
  void initState() {
    equ.Equalizer.init(0);

    _equalizerNameController = TextEditingController();
    _recordProvider = Provider.of<RecordProvider>(context, listen: false);
    _recordProvider.stopAudio();
    recordedSongs = _recordProvider.allRecords;
    selectedRecord = _recordProvider.drawerRecord;
    _recordProvider.currentRecord = selectedRecord;
    _recordProvider.equalizer = true;
    getEnabledStatus();
    getCustomEqualizers();
    getCurrentEqualizer();
    super.initState();
  }

  @override
  void dispose() {
    _equalizerNameController.dispose();
    _recordProvider.equalizer = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white.withOpacity(0.05),
      appBar: AppBar(
        actions: [Container()],
        backgroundColor: AppColor.black,
        title: TextViewWidget(
          text: 'Equalizer',
          color: AppColor.bottomRed,
          textSize: 24,
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
      body: FutureBuilder<List<int>>(
        future: equ.Equalizer.getBandLevelRange(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            min = snapshot.data[0].toDouble();
            max = snapshot.data[1].toDouble();
          }
          return snapshot.connectionState == ConnectionState.done
              ? customEqualizer()
              : Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }

  Widget customEqualizer() {
    int bandId = 0;

    return FutureBuilder<List<int>>(
      future: equ.Equalizer.getCenterBandFreqs(),
      builder: (context, snapshot) {
        return snapshot.connectionState == ConnectionState.done
            ? Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        SwitchListTile(
                          value: enabled,
                          onChanged: (val) {
                            equ.Equalizer.setEnabled(val);
                            preferencesHelper.saveValue(
                                key: 'enabled', value: val);
                            setState(() {
                              enabled = val;
                            });
                          },
                          activeTrackColor: Colors.red,
                          activeColor: Colors.red[800],
                          inactiveTrackColor: Colors.white24,
                          contentPadding: EdgeInsets.symmetric(horizontal: 30),
                          title: Text(
                            'Enable Equalizer',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 18),
                          ),
                        ),
                        if (recordedSongs != null && recordedSongs.isNotEmpty)
                          _buildRecordedSongList(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: snapshot?.data
                              ?.map((freq) => _buildSliderBand(freq, bandId++))
                              ?.toList(),
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _buildPresets(),
                        ),
                        SizedBox(height: 20),
                        if (_selectedValue == 'Custom')
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: TextButton(
                                onPressed: () {
                                  print(currentVal);
                                  showSaveDialog();
                                },
                                child: Text(
                                  'Save Settings',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.red)),
                              ),
                            ),
                          ),
                        if (presets != null &&
                            !(presets.contains(_selectedValue)) &&
                            _selectedValue != 'Custom')
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: TextButton(
                                onPressed: () {
                                  equalizerBox.delete(_selectedValue);
                                  _selectedValue = null;
                                  preferencesHelper.saveValue(
                                      key: 'currentEqualizer', value: '');
                                  getCustomEqualizers();
                                  getCurrentEqualizer();
                                },
                                child: Text(
                                  'Delete',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.red)),
                              ),
                            ),
                          ),
                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                  if (recordedSongs != null && recordedSongs.isNotEmpty)
                    BottomPlayingIndicator(
                      isMusic: false,
                      enabled: enabled,
                    )
                ],
              )
            : CircularProgressIndicator();
      },
    );
  }

  Widget _buildSliderBand(int freq, int bandId) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Column(
        children: [
          SizedBox(height: 40),
          SizedBox(
            height: 250.0,
            child: FutureBuilder<int>(
              future: equ.Equalizer.getBandLevel(bandId),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  currentVal.putIfAbsent(
                    bandId,
                    () => snapshot.data.toDouble(),
                  );
                }
                return FlutterSlider(
                  disabled: !enabled,
                  axis: Axis.vertical,
                  rtl: true,
                  min: min,
                  trackBar: FlutterSliderTrackBar(
                    activeTrackBar: BoxDecoration(
                      color: Colors.red,
                    ),
                    inactiveTrackBar:
                        BoxDecoration(color: Colors.white.withOpacity(0.6)),
                    activeTrackBarHeight: 5,
                    inactiveTrackBarHeight: 5,
                  ),
                  handlerWidth: 25,
                  handlerHeight: 10,
                  handler: FlutterSliderHandler(
                    child: Container(color: Colors.red[900]),
                  ),
                  max: max,
                  values: [snapshot.hasData ? snapshot.data.toDouble() : 0],
                  onDragCompleted: (handlerIndex, lowerValue, upperValue) {
                    if (_selectedValue != 'Custom')
                      setState(() {
                        _selectedValue = 'Custom';
                      });
                    equ.Equalizer.setBandLevel(
                      bandId,
                      lowerValue.toInt(),
                    );

                    currentVal.remove(bandId);
                    currentVal.putIfAbsent(bandId, () => lowerValue.toInt());
                    equalizerBox.put('Custom', currentVal);
                    preferencesHelper.saveValue(
                        key: 'currentEqualizer', value: 'Custom');
                  },
                  tooltip: FlutterSliderTooltip(
                      textStyle: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                      positionOffset:
                          FlutterSliderTooltipPositionOffset(top: 0)),
                );
              },
            ),
          ),
          SizedBox(height: 8),
          Text(
            '${freq ~/ 1000} Hz',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildPresets() {
    return FutureBuilder<List<String>>(
      future: fetchPresets,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<String> presets = snapshot.data.toList();
          List<String> presetsCopy = snapshot.data;
          if (customEqualizers.isNotEmpty) presets.addAll(customEqualizers);
          if (!(presets.contains('Custom'))) presets.add('Custom');
          if (presets.isEmpty)
            return Text(
              'No presets available!',
              style: TextStyle(color: Colors.white),
            );
          return DropdownButtonFormField(
            iconEnabledColor: Colors.white,
            decoration: InputDecoration(
              labelText: 'Available Presets',
              labelStyle:
                  TextStyle(color: enabled ? Colors.white : Colors.white54),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
            ),
            value: _selectedValue,
            onChanged: enabled
                ? (String value) {
                    if (presetsCopy.contains(value)) {
                      equ.Equalizer.setPreset(value);
                    } else {
                      Map data = equalizerBox.get(value);

                      data.entries.forEach(
                        (element) {
                          equ.Equalizer.setBandLevel(element.key,
                              double.parse(element.value.toString()).toInt());
                        },
                      );
                    }
                    preferencesHelper.saveValue(
                        key: 'currentEqualizer', value: value);
                    setState(
                      () {
                        _selectedValue = value;
                      },
                    );
                  }
                : null,
            dropdownColor: Colors.grey[800],
            items: presets?.map(
              (String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            )?.toList(),
          );
        } else if (snapshot.hasError)
          return Text(
            snapshot.error,
            style: TextStyle(color: Colors.white),
          );
        else
          return CircularProgressIndicator();
      },
    );
  }

  Future<Widget> showSaveDialog() {
    return showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.black87,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _equalizerNameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    hintText: 'Equalizer name',
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                  autofocus: true,
                  cursorColor: Colors.red,
                  cursorHeight: 20,
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white)),
                    ),
                    SizedBox(width: 70),
                    TextButton(
                      onPressed: () {
                        if (_equalizerNameController.text.trim().length < 1)
                          showToast(context,
                              message: 'Name cannot be empty',
                              backgroundColor: Colors.blue,
                              textColor: Colors.white,
                              gravity: 2);
                        else {
                          equalizerBox.put(
                              _equalizerNameController.text, currentVal);
                          getCustomEqualizers();
                          preferencesHelper.saveValue(
                              key: 'currentEqualizer',
                              value: _equalizerNameController.text);
                          getCurrentEqualizer();
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        'Save',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10)
              ],
            ),
          ),
        );
      },
    );
  }

  _buildRecordedSongList() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField(
            decoration: InputDecoration(
              labelText: 'Choose song',
              labelStyle: TextStyle(
                  color: enabled ? Colors.white : Colors.white54, fontSize: 20),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
            ),
            iconEnabledColor: Colors.white,
            dropdownColor: Colors.grey[800],
            items: recordedSongs?.map(
              (e) {
                return DropdownMenuItem(
                  child: Text(
                    '${e.name}',
                    style: TextStyle(color: Colors.white),
                  ),
                  value: e,
                );
              },
            )?.toList(),
            value: selectedRecord,
            onChanged: (val) {
              updateRecordProvider(val);
            },
          )
        ],
      ),
    );
  }

  updateRecordProvider(RecorderModel model) {
    _recordProvider.stopAudio();
    _recordProvider.currentRecord = model;
    _recordProvider.totalDuration = Duration();

    setState(() {
      selectedRecord = model;
    });
  }
}
