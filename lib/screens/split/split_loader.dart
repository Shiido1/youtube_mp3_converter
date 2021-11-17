import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:provider/provider.dart';

class SplitLoader extends StatefulWidget {
  SplitLoader({Key key}) : super(key: key);

  @override
  _SplitLoaderState createState() => _SplitLoaderState();
}

class _SplitLoaderState extends State<SplitLoader> {
  Timer _timer;
  int seconds = 59;
  int minutes = 4;
  int counter = 0;
  SplitLoaderProvider _splitLoaderProvider;

  _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (minutes == 0 && seconds == 0) {
        setState(() {
          _timer.cancel();
        });
        _splitLoaderProvider.updateShowing(false);
        showToast(context,
            message: 'Failed to split song. Try again',
            backgroundColor: Colors.white,
            textColor: Colors.black,
            gravity: 1);
        Navigator.pop(context);
      } else {
        counter++;
        if (seconds == 0 && minutes != 0) {
          setState(() {
            minutes--;
            seconds = 59;
          });
        } else
          setState(() {
            seconds--;
          });
      }
    });
  }

  @override
  void initState() {
    _splitLoaderProvider =
        Provider.of<SplitLoaderProvider>(context, listen: false);
    _splitLoaderProvider.updateShowing(true);
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    _splitLoaderProvider.updateShowing(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String sec = seconds < 10 ? '0$seconds' : '$seconds';
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(
                value: (counter / 300).toDouble(),
                valueColor: AlwaysStoppedAnimation(Colors.red[500]),
                strokeWidth: 7,
                backgroundColor: Colors.white30,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Splitting, please wait 0$minutes:$sec',
              style: TextStyle(
                  color: Colors.white, fontSize: 18, fontFamily: 'Montserrat'),
            )
          ],
        ),
      ),
    );
  }
}

class SplitLoaderProvider extends ChangeNotifier {
  bool isShowing = false;

  updateShowing(bool showing) {
    isShowing = showing;
  }
}
