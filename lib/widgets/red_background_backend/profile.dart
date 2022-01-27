import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';
import 'package:mp3_music_converter/widgets/red_background_backend/cloud_storage.dart';
import 'package:mp3_music_converter/widgets/red_background_backend/provider.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name, email, pic, about, background;
  bool error = false;
  bool readOnly = true;
  String hideFollowers;
  String hideFollowersPlaceholder;
  TextEditingController _aboutController;
  TextEditingController _nameController;

  @override
  void initState() {
    getProfileDetails();
    _aboutController = TextEditingController();
    _nameController = TextEditingController();
    super.initState();
  }

  saveProfile(String hideProfile, String aboutMe, String newName) async {
    String url = "http://159.223.129.191/api/editprofile";
    String token = await preferencesHelper.getStringValues(key: 'token');
    setState(() {
      about = null;
    });
    final snackBar = SnackBar(
      content: Text('Failed to profile. Try again later'),
      backgroundColor: Colors.red,
    );
    final snackBar2 = SnackBar(
      content: Text('Profile updated successfuly'),
      backgroundColor: Colors.green,
    );
    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          'token': token,
          'name': newName,
          'background': background,
          'hideprofile': hideProfile.toLowerCase(),
          'about': aboutMe
        }),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        Map decodedResponse = jsonDecode(response.body);
        if (decodedResponse['message']
            .toString()
            .toLowerCase()
            .contains("successfully")) {
          readOnly = true;
          getProfileDetails();
          ScaffoldMessenger.of(context).showSnackBar(snackBar2);
        } else
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  getProfileDetails() async {
    String baseUrl = "http://159.223.129.191/api/me";
    String token = await preferencesHelper.getStringValues(key: 'token');
    email = await preferencesHelper.getStringValues(key: 'email');

    try {
      final response = await http.post(
        baseUrl,
        body: jsonEncode({'token': token}),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        Map decodedResponse = jsonDecode(response.body);
        String picUrl = decodedResponse["profilepic"];
        print(decodedResponse);
        if (picUrl[0] == "/") picUrl = "https://youtubeaudio.ca" + picUrl;
        preferencesHelper.saveValue(key: 'profileImage', value: picUrl);
        Provider.of<RedBackgroundProvider>(context, listen: false)
            .updateUrl(picUrl);
        setState(() {
          pic = picUrl;
          background = decodedResponse["background"];
          name = decodedResponse["name"];
          about = decodedResponse["about"] == null
              ? "No about data"
              : decodedResponse["about"];
          hideFollowers =
              decodedResponse["hidefollower"].toString().toLowerCase() == "no"
                  ? "No"
                  : "Yes";
          hideFollowersPlaceholder = hideFollowers;
          _aboutController.text = about;
          _nameController.text = name;
        });
      } else
        setState(() {
          error = true;
        });
    } catch (e) {
      print(e);
      setState(() {
        error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (pic != null) pic = Provider.of<RedBackgroundProvider>(context).url;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [Container()],
        backgroundColor: AppColor.black,
        title: TextViewWidget(
          text: 'Profile',
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (error)
            Center(
                child: Text(
              "Could not load profile",
              style: TextStyle(fontSize: 18, color: Colors.white),
            )),
          SizedBox(height: 20),
          if (error)
            Center(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    error = false;
                  });
                  getProfileDetails();
                },
                child: Text("Retry",
                    style: TextStyle(color: Colors.white, fontSize: 15)),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue)),
              ),
            ),
          if (!error && about == null)
            Center(child: CircularProgressIndicator()),
          if (!error && about != null)
            Expanded(
              child: Column(children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ClipOval(
                            child: SizedBox(
                              width: 80,
                              height: 80,
                              child: CachedNetworkImage(
                                imageUrl: pic,
                                fit: BoxFit.cover,
                                placeholder: (context, index) => Container(
                                  color: Colors.white,
                                  child: Center(
                                      child: SizedBox(
                                          width: 30,
                                          height: 30,
                                          child: CircularProgressIndicator())),
                                ),
                                errorWidget: (context, url, error) => Icon(
                                  Icons.person,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                              bottom: -8,
                              right: -8,
                              child: InkWell(
                                onTap: () async {
                                  await _showDialog();
                                },
                                child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle),
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                    )),
                              ))
                        ],
                      ),
                      SizedBox(width: 40),
                      Expanded(
                        child: Container(
                          child: TextField(
                            controller: _nameController,
                            textCapitalization: TextCapitalization.words,
                            maxLength: 25,
                            readOnly: readOnly,
                            autofocus: true,
                            decoration:
                                InputDecoration(border: InputBorder.none),
                            style: TextStyle(color: Colors.white, fontSize: 23),
                            maxLines: 2,
                            minLines: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 30.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        about = _aboutController.text;
                        setState(() {
                          readOnly = false;
                        });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        decoration: BoxDecoration(
                          color: readOnly ? null : Colors.red,
                          border: Border.all(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text("Edit Profile",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    color: AppColor.background,
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                    child: ScrollConfiguration(
                      behavior: ScrollBehavior(),
                      child: GlowingOverscrollIndicator(
                        axisDirection: AxisDirection.down,
                        color: AppColor.background,
                        child: ListView(
                          children: [
                            SizedBox(height: 20),
                            Text(
                              "Email",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 22),
                            ),
                            SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(15)),
                              padding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 10),
                              child:
                                  Text(email, style: TextStyle(fontSize: 16)),
                            ),
                            SizedBox(height: 30),
                            Text(
                              "Hide Followers",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 22),
                            ),
                            SizedBox(height: 10),
                            if (readOnly)
                              Container(
                                decoration: BoxDecoration(
                                    color: readOnly
                                        ? Colors.white70
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(15)),
                                padding: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 10),
                                child: Text(hideFollowers,
                                    style: TextStyle(fontSize: 16)),
                              ),
                            if (!readOnly)
                              DropdownButtonFormField(
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white),
                                items: [
                                  DropdownMenuItem(
                                      child: Text('Yes'), value: "Yes"),
                                  DropdownMenuItem(
                                      child: Text('No'), value: "No"),
                                ],
                                value: hideFollowersPlaceholder,
                                onChanged: (val) {
                                  setState(() {
                                    hideFollowersPlaceholder = val;
                                  });
                                },
                              ),
                            SizedBox(height: 30),
                            Text(
                              "About Me",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 22),
                            ),
                            SizedBox(height: 10),
                            TextField(
                              readOnly: readOnly,
                              decoration: InputDecoration(
                                fillColor:
                                    readOnly ? Colors.white70 : Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                counterText: '',
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                              ),
                              controller: _aboutController,
                              maxLines: 5,
                              minLines: 5,
                              maxLength: 200,
                            ),
                            SizedBox(height: 20),
                            if (!readOnly)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _aboutController.text = about;
                                        _nameController.text = name;
                                        readOnly = true;
                                      });
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.red[300]),
                                    ),
                                    child: Text('Cancel',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16)),
                                  ),
                                  SizedBox(width: 20),
                                  TextButton(
                                      onPressed: () {
                                        saveProfile(
                                            hideFollowersPlaceholder,
                                            _aboutController.text,
                                            _nameController.text);
                                      },
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.green[400])),
                                      child: Text('Save',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600)))
                                ],
                              ),
                            if (!readOnly) SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ]),
            ),
        ],
      ),
    );
  }

  Future getImage(bool isCamera) async {
    if (isCamera) {
      var picture = await ImagePicker().getImage(source: ImageSource.camera);
      if (picture != null && picture.path != null && picture.path.isNotEmpty) {
        File image = File(picture.path);
        CloudStorage().imageUploadAndDownload(image: image, context: context);
      }
    } else {
      var picture = await ImagePicker().getImage(source: ImageSource.gallery);
      if (picture != null && picture.path != null && picture.path.isNotEmpty) {
        File image = File(picture.path);
        CloudStorage().imageUploadAndDownload(image: image, context: context);
      }
    }
  }

  Future<void> _showDialog() {
    return showDialog(
        context: context,
        barrierColor: Colors.black54,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 8, 8),
                        child: Row(
                          children: [
                            TextViewWidget(
                              text: 'Camera',
                              color: AppColor.black,
                              textSize: 18,
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.camera_alt)
                          ],
                        )),
                    onTap: () {
                      Navigator.pop(context);
                      getImage(true);
                    },
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  GestureDetector(
                    child: Container(
                        padding: EdgeInsets.fromLTRB(0, 8, 8, 0),
                        child: Row(
                          children: [
                            TextViewWidget(
                              text: 'Gallery',
                              color: AppColor.black,
                              textSize: 18,
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.photo)
                          ],
                        )),
                    onTap: () {
                      Navigator.pop(context);
                      getImage(false);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
