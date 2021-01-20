import 'package:flutter/material.dart';

class DownloadAndSaveScreen extends StatefulWidget {
  @override
  _DownloadAndSaveScreenState createState() => _DownloadAndSaveScreenState();
}

class _DownloadAndSaveScreenState extends State<DownloadAndSaveScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: new BoxDecoration(
          color: Color(0xff000000),
          image: new DecorationImage(
            fit: BoxFit.cover,
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.5), BlendMode.dstATop),
            // image: AssetImage('assets/image.svg'),
            image: new NetworkImage(
              'http://www.allwhitebackground.com/images/2/2582-190x190.jpg',
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
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Enter Youtube Url',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      )),
                ),
              ),
              // Image.asset("assets/image.svg"),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Title: Chukwu Okike_ God of Creation',
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
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              onPressed: () {},
                              color: Colors.green,
                              child: Text(
                                'Download',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              )),
                          SizedBox(width: 10),
                          FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              color: Colors.red,
                              onPressed: () {},
                              child: Text(
                                'Save to lib',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Row(
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
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w800),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
