import 'package:flutter/material.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';

import 'chat_screen.dart';

class AvailableUsers extends StatefulWidget {
  AvailableUsers({Key key}) : super(key: key);

  @override
  _AvailableUsersState createState() => _AvailableUsersState();
}

class _AvailableUsersState extends State<AvailableUsers> {
  String userName = 'Dan';
  String peerName = 'Rita';
  String id = '50';
  String pid = '70';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.black,
        title: TextViewWidget(
          text: 'Available Users',
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
      body: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            return Column(
              children: [
                ListTile(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                    userName: userName,
                                    peerName: peerName,
                                    imageUrl: '',
                                    id: id,
                                    pid: pid,
                                  )));
                    },
                    leading: CircleAvatar(child: Icon(Icons.person)),
                    title: Text(
                      peerName,
                      style: TextStyle(
                          color: AppColor.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    )),
                Divider(color: AppColor.white)
              ],
            );
          }),
    );
  }
}
