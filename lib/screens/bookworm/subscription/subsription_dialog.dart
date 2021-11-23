import 'package:flutter/material.dart';

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
                  onPressed: () async {},
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
