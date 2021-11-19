import 'package:flutter/material.dart';
import 'package:mp3_music_converter/screens/bookworm/model/model.dart';
import 'package:mp3_music_converter/screens/bookworm/services/book_services.dart';

enum location { Folder, Subfolder }

class BookwormProvider extends ChangeNotifier {
  List<dynamic> allFolders = [];
  List<Book> folderBooks = [];
  List<Book> subfolderBooks = [];
  Folder currentFolder;
  Subfolder currentSubfolder;

  getFolders() async {
    allFolders = await BookwormServices().getFolders();
    notifyListeners();
  }

  getFolderContents(String folderName) async {
    currentFolder = await BookwormServices().getFolderContents(folderName);
    getBookDetails(currentFolder?.books, location.Folder);
    notifyListeners();
  }

  getSubfolderContents(String subfolderName) async {
    currentSubfolder =
        await BookwormServices().getSubfolderContents(subfolderName);
    print(currentSubfolder.toJson());
    getBookDetails(currentSubfolder?.books, location.Subfolder);
    notifyListeners();
  }

  getBookDetails(List bookList, location loc) async {
    List<Book> bookPlaceHolder = [];
    for (String bookName in bookList) {
      Book book = await BookwormServices().getBook(bookName);
      bookPlaceHolder.add(book);
    }
    if (loc == location.Folder)
      folderBooks = bookPlaceHolder;
    else
      subfolderBooks = bookPlaceHolder;
    notifyListeners();
  }
}
