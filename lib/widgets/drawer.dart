import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 150, bottom: 120),
      child: Container(
        decoration: new BoxDecoration(
          color: Colors.green,
        ),
        child: Drawer(
          child: Column(
            children: [
              Text(
                'God',
              )
            ],
          ),
        ),
      ),
    );
  }
}
