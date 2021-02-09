import 'package:flutter/material.dart';
import 'package:mp3_music_converter/screens/converter/model/youtube_model.dart';
import 'package:mp3_music_converter/screens/converter/provider/converter_provider.dart';
import 'package:mp3_music_converter/screens/dashboard/sample_dashboard.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/widgets/bottom_playlist_indicator.dart';
import 'package:mp3_music_converter/widgets/red_background.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:provider/provider.dart';

class Convert extends StatefulWidget {
  @override
  _ConvertState createState() => _ConvertState();
}

class _ConvertState extends State<Convert> {
  List<YoutubeModel> _list = new List<YoutubeModel>();
  ConverterProvider _converterProvider;
  bool convertResult = false;

  _displayInfo() {
    final list = _converterProvider.convert('');
    setState(() {
      _list = list as List<YoutubeModel>;
      convertResult = true;
    });
  }

  @override
  void initState() {
    _converterProvider = Provider.of<ConverterProvider>(context, listen: false);
    _converterProvider.init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ConverterProvider>(builder: (_, model, __) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: AppColor.background,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  text: 'Converter',
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6, bottom: 6, left: 30),
                  child: TextViewWidget(
                      color: AppColor.white,
                      text: 'Enter Youtube Url',
                      textSize: 23,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Montserrat'),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Stack(children: [
                    TextFormField(
                      decoration: new InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        border: new OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        labelText: 'Enter Youtube Url',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      cursorColor: AppColor.white,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18.0),
                            border: Border.all(color: AppColor.white)),
                        child: ClipOval(
                          child: Material(
                            color: Color(0x00000), // button color
                            child: InkWell(
                              splashColor: Colors.white, // inkwell color
                              child: SizedBox(
                                  width: 56,
                                  height: 55.5,
                                  child: Icon(
                                    Icons.check,
                                    color: AppColor.white,
                                    size: 35,
                                  )),
                              onTap: () {
                                _displayInfo();
                              },
                            ),
                          ),
                        ),
                      ),
                    )
                  ]),
                ),
                convertResult == true
                    ? Container(
                        child: Column(
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.4),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.network(''),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                  'Chukwu Okike_ God of Creation',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                  )),
                                              SizedBox(height: 10),
                                              Text('File Size: 3.07mb',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                  )),
                                              SizedBox(height: 30),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 50),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FlatButton(
                                    onPressed: () {},
                                    color: Colors.green,
                                    child: Text(
                                      'Download',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    )),
                                SizedBox(width: 20),
                                FlatButton(
                                    color: Colors.red,
                                    onPressed: () {},
                                    child: Text(
                                      'Save to lib',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ))
                              ],
                            ),
                          ],
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: 305,
                ),
                BottomPlayingIndicator(),
              ],
            ),
          ),
        );
      }),
    );
  }
}
