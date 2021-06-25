import 'package:flutter/material.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';

class DropDownSplit extends StatefulWidget {
  @override
  _DropDownSplitState createState() => _DropDownSplitState();
}

class _DropDownSplitState extends State<DropDownSplit> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(left: 70, right: 23),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Container(
            height: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextViewWidget(text: 'Instrumental',color: Color.fromRGBO(234, 113, 98, 1)),
                Icon(Icons.mic, size: 18, color: Colors.white),
              ],
            ),
          ),
        ),
        Divider(color: Color.fromRGBO(80, 80, 80, 1)),
        Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Container(
            height: 14,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextViewWidget(text: 'Vocals', color: Color.fromRGBO(234, 113, 98, 1)),
                Icon(Icons.mic, size: 18, color: Colors.white),
              ],
            ),
          ),
        ),
        Divider(color: Color.fromRGBO(80, 80, 80, 1)),
      ]),
    );
  }
}
