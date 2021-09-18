import 'package:flutter/material.dart';

Future<String> showNameSong(BuildContext context) {
  TextEditingController songController = TextEditingController();
  TextEditingController artistController = TextEditingController();
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            artistController.addListener(() {
              setState(() {});
            });
            songController.addListener(() {
              setState(() {});
            });
            return Dialog(
              backgroundColor: Color.fromRGBO(40, 40, 40, 1),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Theme(
                  data: Theme.of(context).copyWith(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Enter the following',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          autofocus: true,
                          cursorHeight: 20,
                          controller: songController,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: 'Song name',
                            hintStyle: TextStyle(color: Colors.white70),
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 2)),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          autofocus: true,
                          cursorHeight: 20,
                          controller: artistController,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: 'Artist name',
                            hintStyle: TextStyle(color: Colors.white70),
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 2)),
                          ),
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context, null);
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  'CANCEL',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: artistController.text.trim().length > 0 &&
                                      songController.text.trim().length > 0
                                  ? () async {
                                      Navigator.pop(context,
                                          '${songController.text.trim()}+${artistController.text.trim()}');
                                    }
                                  : null,
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  'SPLIT',
                                  style: TextStyle(
                                      color:
                                          artistController.text.trim().length >
                                                      0 &&
                                                  songController.text
                                                          .trim()
                                                          .length >
                                                      0
                                              ? Colors.blue
                                              : Colors.blue.withOpacity(0.5),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      });
}
