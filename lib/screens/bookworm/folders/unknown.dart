import 'dart:typed_data';

import 'package:flutter/material.dart';

class Unknown extends StatefulWidget {
  final Uint8List image;

  Unknown(this.image);

  @override
  _UnknownState createState() => _UnknownState();
}

class _UnknownState extends State<Unknown> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Image.memory(widget.image),
      ),
    );
  }
}
