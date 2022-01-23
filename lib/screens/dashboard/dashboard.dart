import 'dart:io';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mp3_music_converter/database/model/song.dart';
import 'package:mp3_music_converter/screens/bookworm/bookworm.dart';
import 'package:mp3_music_converter/screens/dashboard/name_song.dart';
import 'package:mp3_music_converter/screens/downloads/downloads.dart';
import 'package:mp3_music_converter/screens/payment/payment_screen.dart';
import 'package:mp3_music_converter/screens/split/split_loader.dart';
import 'package:mp3_music_converter/screens/world_radio/radio_class.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/utils/utilFold/splitAssistant.dart';
import 'package:mp3_music_converter/widgets/bottom_playlist_indicator.dart';
import 'package:mp3_music_converter/widgets/drawer.dart';
import 'package:mp3_music_converter/widgets/red_background_backend/red_background2.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

const String splitMusicPath = 'split';
bool debug = true;

// ignore: must_be_immutable
class DashBoard extends StatefulWidget with WidgetsBindingObserver {
  final TargetPlatform platform;

  DashBoard({Key key, this.platform}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  HomeButtonItem _homeButtonItem = HomeButtonItem.NON;
  List<String> _apiSplitList = ['', ''];
  bool _permissionReady;
  static String _localPath;
  // String _sharedText = '';
  bool loading = false;
  FilePickerResult result;
  bool hideDisclaimer = false;

  @override
  void initState() {
    // LinkShareAssistant()
    //   ..onDataReceived = _handleSharedData
    //   ..getSharedData().then(_handleSharedData);
    getBoolData();
    _permissionReady = false;
    _prepare();
    super.initState();
  }

  // // Handles any shared data we may receive.
  // void _handleSharedData(String sharedData) {
  //   MusicProvider _provider =
  //       Provider.of<MusicProvider>(context, listen: false);
  //   if (sharedData != null &&
  //       sharedData.isNotEmpty &&
  //       _provider.sharedText != sharedData) {
  //     if (mounted)
  //       setState(() {
  //         _sharedText = sharedData;
  //       });
  //     _provider.updateSharedText(sharedData);
  //   } else {
  //     if (mounted)
  //       setState(() {
  //         _sharedText = '';
  //       });
  //   }
  // }

  String splitFileNameHere(String fileName) {
    List name = fileName.split('-');
    name.removeLast();
    return name.join('-');
  }

  getBoolData() async {
    bool exists = await preferencesHelper.doesExists(key: 'hideDisclaimer');
    hideDisclaimer = exists
        ? await preferencesHelper.getBoolValues(key: 'hideDisclaimer')
        : false;
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
    // if (_sharedText.length > 1)
    //   return Convert(sharedLinkText: _sharedText);
    // else
    // SplitSongRepository.addSong(
    //   Song(
    //       songName: 'Love You',
    //       artistName: 'Niza',
    //       splitFileName: 'Let\'s see',
    //       fileName: 'open heavens',
    //       filePath: '/storage/music',
    //       vocalName: 'happt.mp3'),
    // );
    // RecorderServices()
    //     .addRecording(RecorderModel(name: 'Love me now', path: 'storage/j/'));
    return Scaffold(
      backgroundColor: AppColor.background,
      body: Column(
        children: [
          RedBackground2(openRadio: openRadio),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 16, right: 90),
              child: ListView(
                children: [
                  _buttonItem(
                    title: "Bookworm",
                    item: HomeButtonItem.BOOKWORM,
                    screen: Bookworm(),
                    assets: AppAssets.advance,
                  ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  // _buttonItem(
                  //   title: "Import Url",
                  //   item: HomeButtonItem.CONVERTER,
                  //   screen: Convert(),
                  //   assets: AppAssets.mpFile,
                  // ),
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
            ? !hideDisclaimer
                ? disclaimer()
                : splitMethod()
            : Navigator.push(
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
    print(userToken);
    result = await FilePicker.platform.pickFiles(type: FileType.audio);
    String artistName, songName;
    print(result.files.single.name);
    print(result.files.single.path);
    // return;

    if (result != null && result.files.isNotEmpty) {
      if ((result.files.single.size / 1000000.0).ceil() <= 20) {
        final splitSongDetails = await showNameSong(context);
        if (splitSongDetails != null) {
          songName = splitSongDetails.split('+')[0];
          artistName = splitSongDetails.split('+')[1];

          showDialog(
              context: context,
              barrierDismissible: false,
              barrierColor: Colors.black87,
              builder: (_) {
                return SplitLoader();
              });
          String nameOfFile = result.files.single.name.split(' ').join('_');
          var splitFiles =
              // <String, dynamic>{'reply': 'failure'};
              await SplitAssistant.splitFile(
                  filePath: result.files.single.path, userToken: userToken);
          if (Provider.of<SplitLoaderProvider>(context, listen: false)
              .isShowing) Navigator.pop(context);
          if (splitFiles['reply'] == "success") {
            Map splitData = await SplitAssistant.saveSplitFiles(
              decodedData: splitFiles['data'],
              userToken: userToken,
              artistName: artistName,
              songName: songName,
            );
            if (_permissionReady) {
              if (splitData['reply'] == 'success') {
                // showToast(context,
                //     message:
                //         'Song has been successfully split and saved to Library. If download fails, you can retry from the history page or use the sync button in Voice Over or Sing Along to pull your changes.',
                //     duration: 15,
                //     backgroundColor: Colors.blue[400],
                //     textColor: Colors.black);
                String voiceUrl = splitFiles['data']["files"]["voice"];
                String otherUrl = splitFiles['data']["files"]["other"];

                _apiSplitList = ['', ''];
                _apiSplitList.insert(0, otherUrl);
                _apiSplitList.insert(1, voiceUrl);

                print(splitData['data']['vocalid']);
                print(splitData['data']['othersid']);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Downloads(
                      apiSplitList: _apiSplitList,
                      localPath: _localPath,
                      song: Song(
                          fileName: nameOfFile,
                          musicid: splitFiles['data']['id'].toString(),
                          vocalLibid: splitData['data']['vocalid'],
                          libid: splitData['data']['othersid'],
                          artistName: artistName,
                          songName: songName),
                    ),
                  ),
                );
              } else {
                showToast(context, message: splitData['data']);
              }
            } else if (!_permissionReady) {
              _buildNoPermissionWarning();
            }
          } else if (splitFiles['data'] ==
              'please subscribe to enjoy this service') {
            // await _progressIndicator.dismiss();
            showSubscriptionMessage(context);
          } else if (splitFiles['data'] == 'insufficient storage') {
            // await _progressIndicator.dismiss();
            insufficientStorageWarning(context);
          } else if (splitFiles['data'] == "Invalid Song Provided!") {
            // await _progressIndicator.dismiss();
            showToast(context, message: 'Invalid Song Selected');
          } else {
            // await _progressIndicator.dismiss();
            showToast(context, message: 'An unknown error occurred.');
          }
        }
      } else {
        showToast(context,
            message:
                'File exceeds 20MB limit. Kindly reduce the file size and try again',
            duration: 6,
            gravity: 1,
            backgroundColor: Colors.red[700]);
      }
    }
  }

  Future<void> disclaimer() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Color.fromRGBO(40, 40, 40, 1),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Maximum of 20MB file per split',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    alignment: Alignment.centerLeft,
                    child: Theme(
                      data: Theme.of(context).copyWith(
                          unselectedWidgetColor: Colors.white,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent),
                      child: CheckboxListTile(
                        value: hideDisclaimer,
                        onChanged: (val) {
                          setState(() {
                            hideDisclaimer = val;
                          });
                        },
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(
                          'Do not show this again',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        activeColor: Colors.blue,
                      ),
                    ),
                  )
                ],
              ),
              actions: [
                TextButton(
                  child: Text('OK',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                  onPressed: () {
                    preferencesHelper.saveValue(
                        key: 'hideDisclaimer', value: hideDisclaimer);
                    Navigator.pop(context);
                    splitMethod();
                  },
                ),
              ],
            );
          },
        );
      },
    );
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

enum HomeButtonItem { NON, BOOKWORM, CONVERTER, CREATE_MUSIC, RADIO, DJ, PLAN }

class DJMixer extends StatelessWidget {
  const DJMixer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.bottomRed,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          // context, MaterialPageRoute(builder: (_) => MainDashBoard())),
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
