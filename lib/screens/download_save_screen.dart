import 'package:flutter/material.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';

class DownloadAndSaveScreen extends StatefulWidget {
  @override
  _DownloadAndSaveScreenState createState() => _DownloadAndSaveScreenState();
}

class _DownloadAndSaveScreenState extends State<DownloadAndSaveScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: new BoxDecoration(
            color: Color(0xff000000),
            image: new DecorationImage(
              fit: BoxFit.cover,
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.5), BlendMode.dstATop),
              image: new AssetImage(
                AppAssets.bgImage1,
              ),
            ),
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 220),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    'Enter YouTube Url',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0, left: 20),
                  child: TextField(
                    decoration: new InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      border: new OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      labelText: 'Enter Youtube Url',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.4),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.asset(AppAssets.image1),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Chukwu Okike_ God of Creation',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      )),
                                  SizedBox(height: 10),
                                  Text('File Size: 3.07mb',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      )),
                                  SizedBox(height: 30),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton(
                        onPressed: () {},
                        color: Colors.green,
                        child: Text(
                          'Download',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )),
                    SizedBox(width: 20),
                    FlatButton(
                        color: Colors.red,
                        onPressed: () {},
                        child: Text(
                          'Save to lib',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ))
                  ],
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sign Up',
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.w800),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Login',
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.w800),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
