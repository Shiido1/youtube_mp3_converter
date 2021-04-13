import 'package:flutter/material.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';

class DropDownSplit extends StatefulWidget {
  // final String text;
  // final Icon icon;

  // DropDownSplit({Key key, @required this.text, @required this.icon})
  //     : super(key: key);

  @override
  _DropDownSplitState createState() => _DropDownSplitState();
}

class _DropDownSplitState extends State<DropDownSplit> {
  var valueChoose;
  List listItem = [
    Row(
      children: [
        TextViewWidget(text: 'Instrumental', color: AppColor.bottomRed),
        IconButton(icon: Icon(Icons.mic), onPressed: () {})
      ],
    ),
    Row(
      children: [
        TextViewWidget(text: 'Vocals', color: AppColor.bottomRed),
        IconButton(icon: Icon(Icons.mic), onPressed: () {})
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
      child: Container(
        height: 45,
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColor.background, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: DropdownButton(
                hint: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextViewWidget(
                    color: AppColor.background,
                    text: '',
                    textSize: 16,
                  ),
                ),
                isExpanded: true,
                underline: SizedBox(),
                iconSize: 20,
                value: valueChoose,
                onChanged: (newValue) {
                  setState(() {
                    valueChoose = newValue;
                  });
                },
                items: listItem.map((e) {
                  return DropdownMenuItem(value: e, child: e);
                }).toList()),
          ),
        ),
      ),
    );
  }
}
