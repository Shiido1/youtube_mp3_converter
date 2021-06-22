import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mp3_music_converter/database/model/song.dart';
import 'package:mp3_music_converter/screens/converter/convert.dart';
import 'package:mp3_music_converter/screens/dashboard/main_dashboard.dart';
import 'package:mp3_music_converter/screens/downloads/downloads.dart';
import 'package:mp3_music_converter/screens/payment/payment_screen.dart';
import 'package:mp3_music_converter/screens/world_radio/radio_class.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/utils/utilFold/linkShareAssistant.dart';
import 'package:mp3_music_converter/utils/utilFold/splitAssistant.dart';
import 'package:mp3_music_converter/widgets/bottom_playlist_indicator.dart';
import 'package:mp3_music_converter/widgets/drawer.dart';
import 'package:mp3_music_converter/widgets/progress_indicator.dart';
import 'package:mp3_music_converter/widgets/red_background_backend/red_background.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

const String splitMusicPath = 'split';
bool debug = true;

// ignore: must_be_immutable
class DashBoard extends StatefulWidget with WidgetsBindingObserver {
  int index;
  final TargetPlatform platform;

  DashBoard({Key key, this.platform}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  HomeButtonItem _homeButtonItem = HomeButtonItem.NON;
  List<String> _apiSplittedList = ['', ''];
  String _sharedText = "";
  bool _permissionReady;
  static String _localPath;
  bool loading = false;
  CustomProgressIndicator _progressIndicator;
  FilePickerResult result;

  @override
  void initState() {
    this._progressIndicator = CustomProgressIndicator(this.context);

    LinkShareAssistant()
      ..onDataReceived = _handleSharedData
      ..getSharedData().then(_handleSharedData);
    _permissionReady = false;
    _prepare();
    super.initState();
  }

  String splitFileNameHere(String fileName) {
    List name = fileName.split('-');
    name.removeLast();
    return name.join('-');
  }

  Future<bool> _checkPermission() async {
    if (widget.platform == TargetPlatform.android) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

//* prepares the items we wish to download
  Future<Null> _prepare() async {
    _permissionReady = await _checkPermission(); // checks for users permission

    _localPath = (await _findLocalPath()) +
        Platform.pathSeparator +
        splitMusicPath; // gets users

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

//* finds available space for storage on users device
  Future<String> _findLocalPath() async {
    final directory = widget.platform == TargetPlatform.android
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // Handles any shared data we may receive.
  void _handleSharedData(String sharedData) {
    setState(() {
      _sharedText = sharedData;
    });
  }

  void openRadio(String search) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => RadioClass(
                  search: search,
                )));
  }

  @override
  Widget build(BuildContext context) {
    if (_sharedText.length > 1)
      return Convert(sharedLinkText: _sharedText);
    else
      return Scaffold(
        backgroundColor: AppColor.background,
        body: Column(
          children: [
            RedBackground(showMic: true, openRadio: openRadio),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 16, right: 90),
                child: ListView(
                  children: [
                    _buttonItem(
                      title: "Converter",
                      item: HomeButtonItem.CONVERTER,
                      screen: Convert(),
                      assets: AppAssets.mpFile,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _buttonItem(
                      title: "Split Music",
                      item: HomeButtonItem.CREATE_MUSIC,
                      assets: AppAssets.radioWave,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _buttonItem(
                      title: "Radio World Wide",
                      item: HomeButtonItem.RADIO,
                      screen: RadioClass(),
                      assets: AppAssets.radio,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _buttonItem(
                      title: "Disk Jockey",
                      item: HomeButtonItem.DJ,
                      screen: DJMixer(),
                      assets: AppAssets.djMixer,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _buttonItem(
                        title: "Plan",
                        item: HomeButtonItem.PLAN,
                        screen: PaymentScreen(),
                        assets: AppAssets.plan),
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ),
            BottomPlayingIndicator()
          ],
        ),
      );
  }

  Widget _buttonItem({
    String title,
    String assets,
    Widget screen,
    HomeButtonItem item,
  }) {
    return InkWell(
      onTap: () {
        setState(() {
          _homeButtonItem = item;
        });
        screen == null
            ? splitMethod()
            : Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => screen),
              );
      },
      child: Container(
          decoration: BoxDecoration(
              color: _homeButtonItem != item
                  ? AppColor.transparent
                  : Colors.redAccent[100].withOpacity(0.8),
              border: Border.all(
                color: _homeButtonItem != item
                    ? AppColor.white
                    : Colors.redAccent[100].withOpacity(0.8),
              ),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.all(13.0),
            child: Row(
              children: [
                SvgPicture.asset(
                  assets,
                  color:
                      _homeButtonItem != item ? AppColor.white : AppColor.black,
                  height: 24,
                  width: 25,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextViewWidget(
                    color: _homeButtonItem != item
                        ? AppColor.white
                        : AppColor.black,
                    text: '$title',
                    textSize: 18,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Future splitMethod() async {
    String userToken = await preferencesHelper.getStringValues(key: 'token');
    result = await FilePicker.platform.pickFiles(type: FileType.audio);

    if (result != null && result.files.isNotEmpty) {
      _progressIndicator.show();
      String nameOfFile = result.files.single.name.split(' ').join('_');
      var splittedFiles = await SplitAssistant.splitFile(
          filePath: result.files.single.path,
          context: context,
          userToken: userToken);
      if (splittedFiles['reply'] == "success") {
        await _progressIndicator.dismiss();
        SplitAssistant.saveSplitFiles(
            decodedData: splittedFiles['data'],
            context: context,
            userToken: userToken);
        if (_permissionReady) {
          String voiceUrl = splittedFiles['data']["files"]["voice"];
          String otherUrl = splittedFiles['data']["files"]["other"];

          _apiSplittedList = ['', ''];
          _apiSplittedList.insert(0, otherUrl);
          _apiSplittedList.insert(1, voiceUrl);

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Downloads(
                      apiSplittedList: _apiSplittedList,
                      localPath: _localPath,
                      song: Song(fileName: nameOfFile))));
        } else if (!_permissionReady) {
          _buildNoPermissionWarning();
        }
      } else if (splittedFiles['data'] ==
          'please subscribe to enjoy this service') {
        await _progressIndicator.dismiss();
        showSubscriptionMessage(context);
      } else {
        await _progressIndicator.dismiss();
        showToast(context, message: 'Please try again later');
      }
    }
  }

  Widget _buildNoPermissionWarning() => Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Please grant accessing storage permission to continue -_-',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.blueGrey, fontSize: 18.0),
                ),
              ),
              SizedBox(
                height: 32.0,
              ),
              TextButton(
                  onPressed: () {
                    _checkPermission().then((hasGranted) {
                      setState(() {
                        _permissionReady = hasGranted;
                      });
                    });
                  },
                  child: Text(
                    'Retry',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ))
            ],
          ),
        ),
      );
}

enum HomeButtonItem { NON, CONVERTER, CREATE_MUSIC, RADIO, DJ, PLAN }

class DJMixer extends StatelessWidget {
  const DJMixer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.bottomRed,
        leading: IconButton(
          onPressed: () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => MainDashBoard())),
          icon: Icon(
            Icons.arrow_back_ios_sharp,
            color: AppColor.white,
          ),
        ),
      ),
      body: Center(
          child: TextViewWidget(
        text: 'Coming Soon...!',
        color: AppColor.white,
        textSize: 18,
      )),
    );
  }
}
