import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mp3_music_converter/bottom_navigation/playlist.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/bottom_playlist_indicator.dart';
import 'package:mp3_music_converter/widgets/drawer.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';

class PlaylistScreen extends StatefulWidget {
  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  int _currentIndex = 0;

  Drawer _drawer() => Drawer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10, left: 15),
            child: Center(
              child: Column(
                children: [
                  Text('endDrawer content'),
                  Builder(
                      builder: (context) => RaisedButton(
                            child: Text('Click', semanticsLabel: 'Click 2'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )),
                ],
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.black,
        title: TextViewWidget(
          text: 'Playlist',
          color: AppColor.bottomRed,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => PlayList()),
            );
          },
          icon: Icon(
            Icons.arrow_back_ios_sharp,
            color: AppColor.bottomRed,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Image.asset(
            'assets/mqdefault4.png',
            height: 250,
            width: 250,
          ),
          SizedBox(
            height: 15,
          ),
          TextViewWidget(
            text: "Untitled Playlist",
            color: AppColor.white,
            textSize: 22,
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    SvgPicture.asset(
                      AppAssets.favorite,
                      height: 20.8,
                    ),
                    TextViewWidget(
                      text: 'Favorite',
                      color: AppColor.white,
                    )
                  ],
                ),
                Column(
                  children: [
                    SvgPicture.asset(AppAssets.shuffle),
                    TextViewWidget(text: 'Shuffle', color: AppColor.white)
                  ],
                ),
                Column(
                  children: [
                    SvgPicture.asset(AppAssets.repeat),
                    TextViewWidget(text: 'Repeat', color: AppColor.white)
                  ],
                ),
                Column(
                  children: [
                    SvgPicture.asset(AppAssets.share),
                    TextViewWidget(text: 'Share', color: AppColor.white)
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FlatButton(
                  color: AppColor.fadedPink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  onPressed: () {},
                  child: TextViewWidget(
                    color: AppColor.white,
                    text: 'Play',
                    textSize: 18.5,
                  )),
              FlatButton(
                  color: AppColor.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  onPressed: () {},
                  child: TextViewWidget(
                    color: AppColor.white,
                    text: 'Shuffle',
                    textSize: 18.5,
                  ))
            ],
          ),
          // Padding(
          //   padding: const EdgeInsets.only(
          //       right: 30, top: 16.0, bottom: 16.0, left: 30),
          //   child: Divider(color: AppColor.white, height: 0.1),
          // ),
          Expanded(
            child: ListView(
              children: [1, 2, 3, 4, 5, 6, 7]
                  .map((mocked) => Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Column(
                          children: [
                            ListTile(
                                onTap: () => Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PlaylistScreen()),
                                    ),
                                leading: Image.asset(AppAssets.image1),
                                title: TextViewWidget(
                                  text: 'Something Fishy',
                                  color: AppColor.white,
                                  textSize: 18,
                                ),
                                subtitle: TextViewWidget(
                                  text: 'Davido',
                                  color: AppColor.white,
                                  textSize: 15,
                                ),
                                trailing: InkWell(
                                    onTap: () {
                                      (context.ancestorWidgetOfExactType(
                                              DrawerStack) as DrawerStack)
                                          .openDrawer();
                                    },
                                    child: SvgPicture.asset(AppAssets.dot))),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 70.0, right: 23),
                              child: Divider(
                                color: AppColor.white,
                              ),
                            )
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
          BottomPlayingIndicator(),
        ],
      ),
      drawer: _drawer(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        backgroundColor: AppColor.black,
        selectedItemColor: AppColor.bottomRed,
        unselectedItemColor: AppColor.white,
        selectedLabelStyle: Theme.of(context).textTheme.caption,
        elevation: 5,
        unselectedLabelStyle: Theme.of(context).textTheme.caption,
        unselectedFontSize: 30,
        onTap: (value) {
          setState(() => _currentIndex = value);
        },
        items: [
          BottomNavigationBarItem(
            label: 'Playlist',
            icon: SvgPicture.asset(
              AppAssets.library,
              color: _currentIndex == 0 ? AppColor.bottomRed : AppColor.white,
            ),
          ),
          BottomNavigationBarItem(
            label: 'My Library',
            icon: SvgPicture.asset(
              AppAssets.playlist,
              color: _currentIndex == 1 ? AppColor.bottomRed : AppColor.white,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Search',
            icon: SvgPicture.asset(
              AppAssets.search,
              color: _currentIndex == 2 ? AppColor.bottomRed : AppColor.white,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Setting',
            icon: SvgPicture.asset(
              AppAssets.setting,
              color: _currentIndex == 3 ? AppColor.bottomRed : AppColor.white,
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerStack extends StatelessWidget {
  final GlobalKey<DrawerControllerState> _drawerKey =
      GlobalKey<DrawerControllerState>();
  final drawerScrimColor = AppColor.transparent;
  final double drawerEdgeDragWidth = null;
  final DragStartBehavior drawerDragStartBehavior = DragStartBehavior.start;

  final Widget body;
  final Drawer drawer;

  DrawerStack({Key key, this.body, this.drawer}) : super(key: key);

  void openDrawer() {
    _drawerKey.currentState?.open();
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          body,
          DrawerController(
            key: _drawerKey,
            alignment: DrawerAlignment.end,
            child: drawer,
            drawerCallback: (_) {},
            dragStartBehavior: drawerDragStartBehavior,
            //widget.drawerDragStartBehavior,
            scrimColor: drawerScrimColor,
            edgeDragWidth: drawerEdgeDragWidth,
          ),
        ],
      );
}