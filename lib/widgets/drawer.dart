import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mp3_music_converter/screens/playlist/play_list_screen.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/bottom_playlist_indicator.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';

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
