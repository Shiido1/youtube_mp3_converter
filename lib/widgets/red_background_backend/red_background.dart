import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mp3_music_converter/widgets/red_background_backend/provider.dart';

class RedBackground extends StatefulWidget {
  final String text;
  final IconButton iconButton;
  final VoidCallback callback;
  final Widget widgetContainer;


  RedBackground({this.text, this.iconButton, this.callback, this.widgetContainer});

  @override
  _RedBackgroundState createState() => _RedBackgroundState();
}

class _RedBackgroundState extends State<RedBackground> {
  File image;
  bool img = false;
  SharedPreferences sharedPreferences;
  String downloadUrl;
  RedBackgroundProvider redBackgroundProvider;


  Future imageUploadAndDownload() async {
    final reference = FirebaseStorage.instance.ref().child('profile_image.jpg').child("Image_path");
    UploadTask uploadTask = reference.putFile(image);
    await uploadTask.timeout(Duration(seconds: 40));
    TaskSnapshot snapshot = await uploadTask;
    if(snapshot!=null){
      if (snapshot.state == TaskState.success){
        String downloadAddress = await snapshot.ref.getDownloadURL();
        setState(() {
          downloadUrl = downloadAddress;
        });
      }
    }
    preferencesHelper.saveValue(key: 'profile_image', value: downloadUrl);
    redBackgroundProvider.image(downloadUrl);
  }

  Future getImage(BuildContext context,bool isCamera) async {
    if (isCamera) {
      var picture = await ImagePicker.pickImage(source: ImageSource.camera);
      setState(() {
        image = picture;
        img = true;
      });
      Navigator.of(context).pop();
      preferencesHelper.saveValue(key: 'profileimage', value: image);
    }else{
      var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        image = picture;
        img = true;
      });
      Navigator.of(context).pop();
      preferencesHelper.saveValue(key: 'profileimage', value: image);
    }
  }

  Future<void> _showDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: TextViewWidget(text:'Camera',color: AppColor.black,),
                    onTap: () {
                      getImage(context,true);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),

                  ),
                  GestureDetector(
                    child: TextViewWidget(text:'Gallery',color: AppColor.black,),
                    onTap: () {
                      getImage(context,false);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    // init();
    super.initState();
  }

//   init() async {
//   String _imageString;
//   if (image != null) {
//     _imageString = await preferencesHelper.getStringValues(key: 'profile_image');
//     image = File(_imageString);
//     setState(() {});
//   }
// }

  @override
  Widget build(BuildContext context) {
    // init();
    return Container(
        child: Stack(
          children: [
            Image.asset(
              AppAssets.background,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fitWidth,
            ),
            Container(
              margin: const EdgeInsets.only(left: 16, right: 16, top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      widget.iconButton != null
                          ? IconButton(
                              icon: widget.iconButton,
                              onPressed: widget.callback)
                          : TextViewWidget(text: '', color: AppColor.transparent),
                      widget.text != null
                          ? TextViewWidget(
                              color: AppColor.white,
                              text: widget.text,
                              textSize: 22,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Montserrat')
                          : Image.asset(AppAssets.dashlogo,height: 63,),
                    ],
                  ),
                  _widgetContainer()
                ],
              ),
            ),
          ],
        ),
    );
  }

  Widget _widgetContainer()=>Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      img == false
          ? ClipOval(
        child: SizedBox(
          height: 50,
            width: 50,
            child: CachedNetworkImage(imageUrl:'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png')),)
          : Container(
        width: 65,
        height: 75,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                image: FileImage(image), // picked file
                fit: BoxFit.cover)),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: InkWell(
          onTap: ()async{
            await _showDialog(context);
            imageUploadAndDownload();
            },
          child: Text(
            'Profile',
            style: TextStyle(
                fontSize: 17,
                color: AppColor.white,
                fontWeight: FontWeight.w500,
                fontFamily: 'Montserrat-Thin'),
          ),
        ),
      ),
    ],
  );

}
