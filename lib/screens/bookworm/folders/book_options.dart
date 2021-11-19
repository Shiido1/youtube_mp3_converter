import 'package:flutter/material.dart';
import 'package:mp3_music_converter/screens/bookworm/model/model.dart';
import 'package:mp3_music_converter/screens/bookworm/services/book_services.dart';

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
    await BookwormServices().deleteBook(widget.book);
    Navigator.pop(context);
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
