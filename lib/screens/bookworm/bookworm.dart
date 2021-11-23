import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mp3_music_converter/screens/bookworm/create_book/create_a_book.dart';
import 'package:mp3_music_converter/screens/bookworm/folders/folder_list.dart';
import 'package:mp3_music_converter/screens/bookworm/subscription/subscription.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:page_transition/page_transition.dart';

class Bookworm extends StatefulWidget {
  Bookworm({Key key}) : super(key: key);

  @override
  _BookwormState createState() => _BookwormState();
}

class _BookwormState extends State<Bookworm> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawerEnableOpenDragGesture: false,
      backgroundColor: AppColor.white.withOpacity(0.05),
      appBar: AppBar(
        backgroundColor: AppColor.black,
        title: TextViewWidget(
          text: 'Bookworm',
          color: AppColor.bottomRed,
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
        child: Column(
          children: [
            MaterialButton(
              onPressed: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: CreateBook(),
                        type: PageTransitionType.rightToLeft));
              },
              color: Colors.white12,
              height: 60,
              child: Row(
                children: [
                  Icon(
                    FontAwesomeIcons.book,
                    size: 30,
                    color: Colors.white,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Create a Book',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            MaterialButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                      child: FolderList(title: 'Folders'),
                      type: PageTransitionType.rightToLeft),
                );
              },
              color: Colors.white12,
              height: 60,
              child: Row(
                children: [
                  Icon(
                    FontAwesomeIcons.solidFolder,
                    size: 30,
                    color: Colors.white,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Folder List',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            MaterialButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                      child: Subscription(),
                      type: PageTransitionType.rightToLeft),
                );
              },
              color: Colors.white12,
              height: 60,
              child: Row(
                children: [
                  Icon(
                    Icons.subscriptions_rounded,
                    size: 30,
                    color: Colors.white,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Plans',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
