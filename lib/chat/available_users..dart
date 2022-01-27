import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:http/http.dart' as http;

import 'chat_screen.dart';

class AvailableUsers extends StatefulWidget {
  AvailableUsers({Key key}) : super(key: key);

  @override
  _AvailableUsersState createState() => _AvailableUsersState();
}

class _AvailableUsersState extends State<AvailableUsers> {
  String userName;
  List availableUsers = [];
  String baseUrl = "http://159.223.129.191/api/me";
  String userId;

  getAvailableUsers() async {
    List chattingUsers = [];
    List followers = [];
    List following = [];

    String token = await preferencesHelper.getStringValues(key: 'token');

    try {
      final response = await http.post(
        baseUrl,
        body: jsonEncode({'token': token}),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        Map decodedResponse = jsonDecode(response.body);
        print(decodedResponse);

        followers = decodedResponse['followers'];
        following = decodedResponse['following'];
        userId = decodedResponse['userid'].toString();
        userName = decodedResponse['name'];

        for (Map follower in followers) {
          for (Map follow in following) {
            if (follower['followerid'] == follow['followerid'] &&
                follower['followerid'].toString() != userId) {
              chattingUsers.add(follower);
            }
          }
        }
        print(chattingUsers);

        if (chattingUsers.isNotEmpty) {
          if (mounted)
            setState(() {
              availableUsers = chattingUsers;
            });
        } else {
          if (mounted)
            setState(() {
              availableUsers = ['null'];
            });
        }
      } else {
        if (mounted) {
          showToast(context,
              message: 'An error occurred. Try again', gravity: 1);
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        showToast(context,
            message: 'Please connect to the internet and try again',
            gravity: 1);
        Navigator.pop(context);
      }
    }
  }

  @override
  void initState() {
    getAvailableUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('users availableL $availableUsers');
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
      body: availableUsers.isEmpty
          ? Center(child: CircularProgressIndicator())
          : availableUsers[0] == 'null'
              ? Center(
                  child: Text(
                    'No available users',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: availableUsers.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                            peerName: availableUsers[index]
                                                ['name'],
                                            imageUrl: availableUsers[index]
                                                        ['profilepic'][0] ==
                                                    "/"
                                                ? "https://youtubeaudio.ca" +
                                                    availableUsers[index]
                                                        ['profilepic']
                                                : availableUsers[index]
                                                    ['profilepic'],
                                            id: userId,
                                            pid: availableUsers[index]
                                                    ['followerid']
                                                .toString(),
                                          )));
                            },
                            leading: ClipOval(
                              child: Container(
                                width: 50,
                                height: 50,
                                child: CachedNetworkImage(
                                  imageUrl: availableUsers[index]['profilepic'],
                                  placeholder: (context, index) => Container(
                                    child: Center(
                                        child: SizedBox(
                                            width: 20,
                                            height: 20,
                                            child:
                                                CircularProgressIndicator())),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      new Icon(Icons.error),
                                ),
                              ),
                            ),
                            title: Text(
                              availableUsers[index]['name'],
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
