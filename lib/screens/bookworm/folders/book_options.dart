import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mp3_music_converter/screens/bookworm/model/model.dart';
import 'package:mp3_music_converter/screens/bookworm/provider/bookworm_provider.dart';
import 'package:mp3_music_converter/screens/bookworm/services/book_services.dart';
import 'package:http/http.dart' as http;
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';
import 'package:mp3_music_converter/widgets/progress_indicator.dart';
import 'package:provider/provider.dart';

showBookOptions(BuildContext context, Book book) {
  return showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.grey[900],
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (_) {
                      return ShowConfirmRemoveBookOption(book);
                    },
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_forever,
                        color: Colors.white,
                      ),
                      SizedBox(width: 20),
                      Text(
                        'Remove book',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      });
}

class ShowConfirmRemoveBookOption extends StatefulWidget {
  final Book book;
  ShowConfirmRemoveBookOption(this.book);

  @override
  _ShowConfirmRemoveBookOptionState createState() =>
      _ShowConfirmRemoveBookOptionState();
}

class _ShowConfirmRemoveBookOptionState
    extends State<ShowConfirmRemoveBookOption> {
  removeBook() async {
    String url = 'https://youtubeaudio.com/api/book/deletebook';
    String token = await preferencesHelper.getStringValues(key: 'token');
    CustomProgressIndicator _progressIndicator =
        CustomProgressIndicator(context);
    BookwormProvider provider =
        Provider.of<BookwormProvider>(context, listen: false);
    print(token);

    try {
      _progressIndicator.show();
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
          {'token': token, 'id': widget.book.id},
        ),
      );
      _progressIndicator.dismiss();
      print(jsonDecode(response.body));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['message'].toString().toLowerCase().contains('delete')) {
          Navigator.pop(context);
          await BookwormServices().deleteBook(widget.book);
          showToast(context,
              message: 'Book deleted', backgroundColor: Colors.green);

          provider.getFolderContents(provider?.currentFolder?.name);
          if (provider.currentSubfolder != null)
            provider.getSubfolderContents(provider.currentSubfolder.name);
        } else
          showToast(context,
              message: data['message'], backgroundColor: Colors.red);
      } else {
        if (_progressIndicator.isShowing()) await _progressIndicator.dismiss();
        final data = jsonDecode(response.body);
        Navigator.pop(context);
        showToast(context,
            message: data['message'], backgroundColor: Colors.red);
      }
    } catch (e) {
      if (_progressIndicator.isShowing()) await _progressIndicator.dismiss();
      showToast(context,
          message: 'An error occurred', backgroundColor: Colors.red);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'This action would delete this book from this location. Continue?',
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text('No',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: Text(
            'Yes',
            style: TextStyle(
                fontSize: 18, color: Colors.red, fontWeight: FontWeight.w500),
          ),
          onPressed: () {
            removeBook();
          },
        ),
      ],
    );
  }
}
