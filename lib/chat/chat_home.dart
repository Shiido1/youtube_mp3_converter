import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mp3_music_converter/chat/available_users..dart';
import 'package:mp3_music_converter/chat/chat_screen.dart';
import 'package:mp3_music_converter/chat/database_service.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';

class ChatHome extends StatefulWidget {
  ChatHome({Key key}) : super(key: key);

  @override
  _ChatHomeState createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
  bool search = false;
  List<MessageData> users = [];
  List<MessageData> userSearchResult = [];
  StreamSubscription userStream;
  StreamSubscription userDetailsStream;
  bool newMessage = false;
  int newMessageCount = 0;
  Map<String, UserDetails> chats = {};

  searchUsers(String value) {
    List<MessageData> usersPlaceholder = [];
    if (value == null || value.isEmpty) {
      setState(() {
        userSearchResult = users;
      });
      return;
    }
    for (MessageData user in users) {
      for (String data in chats.keys) {
        if (data == user.peerId &&
            chats[data].name.toLowerCase().contains(value.toLowerCase())) {
          usersPlaceholder.add(user);
        }
      }
    }
    setState(() {
      userSearchResult = usersPlaceholder;
    });
  }

  checkUnreadMessages(List<MessageData> message) {
    List newMessages = [];
    for (MessageData data in message) {
      if (data.unreadCount > 0) newMessages.add(data);
    }
    if (mounted)
      setState(() {
        newMessageCount = newMessages.length;
        newMessage = newMessageCount > 0 ? true : false;
      });
  }

  getUsers() async {
    String id = await preferencesHelper.getStringValues(key: 'id');

    userStream = DatabaseService().allStream(id).listen((event) {
      Map<int, MessageData> userIDs = {};
      List<MessageData> userData = [];

      if (event != null) {
        Map data = event.snapshot.value;
        if (data == null && event.snapshot.key == id) {
          setState(() {
            users = [
              MessageData(
                  id: null,
                  message: null,
                  peerId: null,
                  time: null,
                  unreadCount: null)
            ];
          });
          return;
        }

        data.forEach((key, value) {
          int count = 0;
          value.forEach((key2, value2) {
            if (key2 != 'time' &&
                key2 != 'lastMessage' &&
                value2['id'] != id &&
                value2['read'] == false) count += 1;
          });
          userIDs.putIfAbsent(
              value['time'],
              () => MessageData(
                  id: event.snapshot.key,
                  message: value['lastMessage'],
                  peerId: key,
                  time: value['time'].toString(),
                  unreadCount: count));
        });

        List userIdKey = userIDs.keys.toList();
        if (userIdKey.length > 1) userIdKey.sort((b, a) => a.compareTo(b));

        for (int key in userIdKey) {
          userData.add(userIDs[key]);
        }

        if (mounted)
          setState(() {
            users = userData;
          });
        checkUnreadMessages(users);
      }
    });
    userDetailsStream = FirebaseDatabase.instance
        .reference()
        .child('users')
        .onValue
        .listen((event) {
      Map<String, UserDetails> userDetails = {};
      if (event != null) {
        Map data = event.snapshot.value;
        if (data == null) return;
        data.forEach((key, value) {
          userDetails.putIfAbsent(
              key, () => UserDetails(value['name'], value['photoUrl']));
        });
      }
      setState(() {
        chats = userDetails;
      });
    });
  }

  @override
  void initState() {
    getUsers();
    super.initState();
  }

  @override
  void dispose() {
    userStream?.cancel();
    userDetailsStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (search) {
          setState(() {
            search = false;
          });
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: AppColor.background,
        appBar: AppBar(
          actions: [
            IconButton(
                icon: Icon(
                  search ? Icons.cancel_outlined : Icons.search,
                  color: AppColor.white,
                  size: 25,
                ),
                onPressed: () {
                  setState(() {
                    search = !search;
                    if (search) userSearchResult = users;
                  });
                }),
            SizedBox(width: 10),
          ],
          backgroundColor: AppColor.black,
          title: Row(
            children: [
              TextViewWidget(
                text: 'Chat',
                color: AppColor.bottomRed,
              ),
              SizedBox(width: 10),
              if (newMessage)
                Container(
                  width: 35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$newMessageCount',
                    style: TextStyle(color: Colors.black),
                  ),
                )
            ],
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
        body: Theme(
          data: Theme.of(context).copyWith(accentColor: Colors.transparent),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Stack(
              children: [
                Column(
                  children: [
                    if (search)
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: TextFormField(
                          onChanged: (val) {
                            searchUsers(val);
                          },
                          decoration: decoration.copyWith(
                            prefixIcon: Icon(Icons.search,
                                color: Color.fromRGBO(0, 0, 0, 0.5)),
                          ),
                          cursorColor: AppColor.black,
                          cursorHeight: 18,
                        ),
                      ),
                    SizedBox(height: 20),
                    Expanded(
                      child: users.isEmpty
                          ? Center(child: CircularProgressIndicator())
                          : users[0].id == null
                              ? Center(
                                  child: Text(
                                      'No coversation. Start one by clicking the button below.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18)))
                              : ListView.builder(
                                  itemCount: search
                                      ? userSearchResult.length
                                      : users.length,
                                  itemBuilder: (context, index) {
                                    MessageData user = search
                                        ? userSearchResult[index]
                                        : users[index];
                                    UserDetails details = chats[user.peerId];
                                    String messageTime = user?.time != null
                                        ? checkDates(user.time)
                                        : '';

                                    return Card(
                                      color: AppColor.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(7))),
                                      margin: EdgeInsets.only(bottom: 20),
                                      child: ListTile(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        onTap: () {
                                          search = false;
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChatScreen(
                                                        peerName: details?.name,
                                                        imageUrl:
                                                            details?.photoUrl,
                                                        id: user?.id,
                                                        pid: user?.peerId,
                                                      )));
                                        },
                                        leading: ClipOval(
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            child: CachedNetworkImage(
                                              imageUrl: details?.photoUrl ?? '',
                                              fit: BoxFit.cover,
                                              placeholder: (context, index) =>
                                                  Container(
                                                child: Center(
                                                    child: SizedBox(
                                                        width: 20,
                                                        height: 20,
                                                        child:
                                                            CircularProgressIndicator())),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      new Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                        title: TextViewWidget(
                                          text: details?.name ?? '',
                                          color: AppColor.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        subtitle: Padding(
                                          padding: EdgeInsets.only(top: 8),
                                          child: Text(
                                            user?.message ?? '',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.5),
                                                fontSize: 14),
                                          ),
                                        ),
                                        trailing: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(messageTime ?? '',
                                                style: TextStyle(
                                                    color: Colors.black)),
                                            if (user.unreadCount > 0)
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Color.fromRGBO(
                                                        196, 196, 196, 1),
                                                    shape: BoxShape.circle),
                                                padding: EdgeInsets.all(5),
                                                child: Text(
                                                  user.unreadCount > 99
                                                      ? '99+'
                                                      : user?.unreadCount
                                                          .toString(),
                                                  style: TextStyle(
                                                      color: AppColor.black,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 14),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 15,
                  right: 5,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(25),
                    onTap: () {
                      search = false;
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => AvailableUsers()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColor.red,
                      ),
                      padding: EdgeInsets.all(10),
                      child:
                          Icon(Icons.message, color: AppColor.white, size: 35),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String checkDates(String key) {
    String currentItemDate = DateFormat.yMd()
        .format(DateTime.fromMillisecondsSinceEpoch(int.parse(key)));

    String todayDate = DateFormat.yMd().format(DateTime.now());

    String yesterdayDate =
        DateFormat.yMd().format(DateTime.now().subtract(Duration(days: 1)));

    if (currentItemDate == todayDate) {
      DateTime time = DateTime.fromMillisecondsSinceEpoch(int.parse(key));
      return DateFormat.Hm().format(time).toString();
    } else if (currentItemDate == yesterdayDate) {
      return 'yesterday';
    } else
      return DateFormat.yMd()
          .format(DateTime.fromMillisecondsSinceEpoch(int.parse(key)));
  }
}

const decoration = InputDecoration(
  filled: true,
  fillColor: AppColor.white,
  hintText: "Search",
  hintStyle: TextStyle(
      color: Color.fromRGBO(0, 0, 0, 0.6),
      fontSize: 14,
      fontWeight: FontWeight.w400),
  contentPadding: EdgeInsets.all(15),
  border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(7)),
      borderSide: BorderSide(color: Colors.transparent)),
  focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(7)),
      borderSide: BorderSide(color: Colors.transparent)),
);

class MessageData {
  String message;
  String id;
  String peerId;
  String time;
  int unreadCount;
  MessageData(
      {@required this.id,
      @required this.message,
      @required this.peerId,
      @required this.time,
      @required this.unreadCount});
}

class UserDetails {
  String name;
  String photoUrl;
  UserDetails(this.name, this.photoUrl);
}
