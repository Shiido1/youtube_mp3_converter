import 'package:flutter/material.dart';
import 'package:mp3_music_converter/screens/bookworm/model/model.dart';
import 'package:mp3_music_converter/screens/bookworm/services/book_services.dart';

class BookwormProvider extends ChangeNotifier {
  List<dynamic> allFolders = [];
  List<Book> books = [];
  Folder currentFolder;
  Subfolder currentSubfolder;

  getFolders() async {
    allFolders = await BookwormServices().getFolders();
    notifyListeners();
  }

  getFolderContents(String folderName) async {
    currentFolder = await BookwormServices().getFolderContents(folderName);
    notifyListeners();
  }

  getSubfolderContents(String subfolderName) async {
    currentSubfolder =
        await BookwormServices().getSubfolderContents(subfolderName);
    notifyListeners();
  }

  getBookDetails(List<String> bookList) async {
    for (String bookName in bookList) {
      Book book = await BookwormServices().getBook(bookName);
      books.add(book);
    }
    notifyListeners();
  }
}
