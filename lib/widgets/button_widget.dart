import 'package:flutter/material.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';

class ButtonWidget extends StatelessWidget {
  final Color color;
  final Color textColor;
  final Color splashColor;
  final String text;
  final double textSize;
  final VoidCallback callback;

  ButtonWidget(
      {@required this.color,
      @required this.text,
      this.textSize,
      @required this.textColor,
      @required this.callback,
      @required this.splashColor});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: color,
      splashColor: splashColor,
      onPressed: callback,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2.0),
          side: BorderSide(color: color)),
      child: TextViewWidget(
        text: text,
        color: textColor,
        textSize: textSize ?? 16,
      ),
    );
  }
}
