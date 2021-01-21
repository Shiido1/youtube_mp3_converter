import 'package:flutter/material.dart';
import 'package:mp3_music_converter/string_assets/assets.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                )),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 320),
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
                child: Container(
                  child: TextFormField(
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
                      labelText: 'Name',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 250),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Sign Up',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w800),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Login',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
