import 'package:flutter/material.dart';
import 'package:mp3_music_converter/screens/bookworm/subscription/subscription.dart';
import 'package:page_transition/page_transition.dart';

class SubsriptionDialog extends StatelessWidget {
  final String text;
  const SubsriptionDialog(this.text);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.grey[500],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(
                  color: Colors.black, fontSize: 16, fontFamily: 'Montserrat'),
            ),
            SizedBox(height: 10),
            Text(
              'Subsribe now?',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'No',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  color: Colors.black38,
                  elevation: 0,
                ),
                MaterialButton(
                  onPressed: () async {
                    Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child: Subscription(),
                          type: PageTransitionType.rightToLeft),
                    );
                  },
                  child: Text(
                    'Yes',
                    style: TextStyle(color: Colors.black, fontSize: 17),
                  ),
                  color: Colors.white38,
                  elevation: 0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
