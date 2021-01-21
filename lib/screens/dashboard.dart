import 'package:flutter/material.dart';
import 'package:mp3_music_converter/string_assets/assets.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: new BoxDecoration(
        color: Color(0xff000000),
        image: new DecorationImage(
          fit: BoxFit.cover,
          colorFilter: new ColorFilter.mode(
              Colors.black.withOpacity(0.5), BlendMode.dstATop),
          image: new AssetImage(
            AppAssets.bgImage2,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.red,
            height: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(AppAssets.logo),
                SizedBox(
                  width: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        'profile',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.6),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 150, 20),
              child: Text(
                'Converter',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 22,
                    fontWeight: FontWeight.w800),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.6),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 60, 20),
              child: Text(
                'Create your Music',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 21.5,
                    fontWeight: FontWeight.w800),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.6),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 60, 20),
              child: Text(
                'Radio World Wide',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.6),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 60, 20),
              child: Text(
                'Disk Jockey',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.6),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 60, 20),
              child: Text(
                'Plan',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
