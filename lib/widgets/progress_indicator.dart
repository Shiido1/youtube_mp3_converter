import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';

bool _isShowing = false;
String _dialogMessage = "Loading...";
BuildContext _context, _dismissingContext;

// ignore: must_be_immutable
class _Body extends StatefulWidget {
  _State _dialog = _State();

  @override
  State<StatefulWidget> createState() {
    return _dialog;
  }

  update() {
    _dialog.update();
  }
}

class _State extends State<_Body> {
  update() {
    setState(() {});
  }

  @override
  void dispose() {
    _isShowing = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.50),
      // this is the main reason of transparency at next screen. I am ignoring rest implementation but what i have achieved is you can see.
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SpinKitCircle(
            itemBuilder: (BuildContext context, int index) {
              return DecoratedBox(
                decoration: BoxDecoration(
                    color: index.isEven ? AppColor.white : AppColor.background,
                    shape: BoxShape.circle),
              );
            },
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            _dialogMessage == null ? "" : _dialogMessage,
            style: TextStyle(color: Colors.black, fontSize: 20),
          )
        ],
      )),
    );
  }
}

class CustomProgressIndicator {
  _Body _dialog;

  CustomProgressIndicator(BuildContext context) {
    _context = context;
  }

  bool isShowing() {
    return _isShowing;
  }

  Future<bool> dismiss() {
    return Future.delayed(const Duration(milliseconds: 100), () {
      if (_isShowing) {
        try {
          _isShowing = false;
          if (Navigator.of(_dismissingContext).canPop())
            Navigator.of(_dismissingContext).pop();

          return Future.value(true);
        } catch (_) {
          return Future.value(false);
        }
      } else {
        return Future.value(false);
      }
    });
  }

  void show({String message}) {
    new Future.delayed(const Duration(milliseconds: 50), () {
      _show(message: message);
    });
  }

  void _show({String message}) {
    _dialogMessage = message;
    if (!_isShowing) {
      _dialog = new _Body();
      _isShowing = true;

      showGeneralDialog(
        barrierDismissible: false,
        barrierColor: Colors.white.withOpacity(0.50),
        transitionDuration: const Duration(milliseconds: 200),
        context: _context,
        pageBuilder: (BuildContext context, Animation animation,
            Animation secondaryAnimation) {
          _dismissingContext = context;

          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: _dialog,
          );
        },
      );
    }
  }
}
