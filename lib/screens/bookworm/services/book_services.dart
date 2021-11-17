import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mp3_music_converter/database/hive_boxes.dart';
import 'package:mp3_music_converter/screens/bookworm/model/model.dart';

class BookwormServices {
  Box<Map> _folderBox;
  Box<Map> _subfolderBox;
  Box<Map> _bookBox;

  Future<Box<Map>> openFolderBox() {
    return PgHiveBoxes.openBox<Map>('folders');
  }

  Future<Box<Map>> openSubfolderBox() {
    return PgHiveBoxes.openBox<Map>('subfolders');
  }

  Future<Box<Map>> openBookBox() {
    return PgHiveBoxes.openBox<Map>('books');
  }

  //folders
  createFolder(Folder folder) async {
    if (!(_folderBox?.isOpen ?? false)) _folderBox = await openFolderBox();
    _folderBox.put(folder.name, folder.toJson());
  }

  Future<List> getFolders() async {
    if (!(_folderBox?.isOpen ?? false)) _folderBox = await openFolderBox();
    return _folderBox.keys.toList();
  }

  Future<Folder> getFolderContents(String folderName) async {
    if (!(_folderBox?.isOpen ?? false)) _folderBox = await openFolderBox();
    return Folder.fromMap(_folderBox.get(folderName));
  }

  deleteFolder(String folderName) async {
    if (!(_folderBox?.isOpen ?? false)) _folderBox = await openFolderBox();
    if (!(_subfolderBox?.isOpen ?? false))
      _subfolderBox = await openSubfolderBox();
    if (!(_bookBox?.isOpen ?? false)) _bookBox = await openBookBox();
    Map folder = _folderBox.get(folderName);
    List subfolders = folder['subfolders'] ?? [];
    List books = folder['books'] ?? [];

    for (int i = 0; i < subfolders.length; i++) {
      _subfolderBox.delete(subfolders[i]);
    }
    for (int i = 0; i < books.length; i++) {
      _bookBox.delete(books[i]);
    }
    _folderBox.delete(folderName);
  }

  renameFolder({@required String oldName, @required String newName}) async {
    if (!(_folderBox?.isOpen ?? false)) _folderBox = await openFolderBox();
    Map contents = _folderBox.get(oldName);
    _folderBox.delete(oldName);
    _folderBox.put(newName, contents);
  }

  //subfolders
  createSubfolder(Subfolder subfolder) async {
    if (!(_subfolderBox?.isOpen ?? false))
      _subfolderBox = await openSubfolderBox();
    Map folders = _folderBox.get(subfolder.fname);
    if (folders != null) {
      List subfolds = folders['subfolders'];
      subfolds.add(subfolder.name);
      folders['subfolders'] = subfolds;
      _folderBox.put(subfolder.fname, folders);
    }
    _folderBox.put(subfolder.name, subfolder.toJson());
  }

  Future<Subfolder> getSubfolderContents(String subfolderName) async {
    if (!(_subfolderBox?.isOpen ?? false))
      _subfolderBox = await openSubfolderBox();
    return Subfolder.fromMap(_subfolderBox.get(subfolderName));
  }

  renameSubfolder(
      {@required Subfolder subfolder, @required String newName}) async {
    if (!(_subfolderBox?.isOpen ?? false))
      _subfolderBox = await openSubfolderBox();
    if (!(_folderBox?.isOpen ?? false)) _folderBox = await openFolderBox();
    Map contents = _subfolderBox.get(subfolder.name);
    Map folders = _folderBox.get(subfolder.fname);
    if (folders != null) {
      List subfolds = folders['subfolders'];
      subfolds.remove(subfolder.name);
      subfolds.add(newName);
      folders['subfolders'] = subfolds;
      _folderBox.put(subfolder.fname, folders);
    }
    _subfolderBox.delete(subfolder.name);
    _subfolderBox.put(newName, contents);
  }

  deleteSubfolder(String subfolderName) async {
    if (!(_subfolderBox?.isOpen ?? false))
      _subfolderBox = await openSubfolderBox();
    if (!(_bookBox?.isOpen ?? false)) _bookBox = await openBookBox();
    Map subfolder = _subfolderBox.get(subfolderName);
    List books = subfolder['books'] ?? [];
    for (int i = 0; i < books.length; i++) {
      _bookBox.delete(books[i]);
    }
    _subfolderBox.delete(subfolderName);
  }

  //books
  addBook(Book book) async {
    if (!(_bookBox?.isOpen ?? false)) _bookBox = await openBookBox();
    if (!(_subfolderBox?.isOpen ?? false))
      _subfolderBox = await openSubfolderBox();
    if (!(_folderBox?.isOpen ?? false)) _folderBox = await openFolderBox();

    Map folder = _folderBox.get(book.fname);
    if (folder != null) {
      List books = folder['books'];
      books.add(book.name);
      folder['books'] = books;
      _folderBox.put(book.fname, folder);
    }

    if (book.sname != null && book.sname.isNotEmpty) {
      Map subfolder = _subfolderBox.get(book.sname);
      if (subfolder != null) {
        List books = subfolder['books'];
        books.add(book.name);
        subfolder['books'] = books;
        _folderBox.put(book.sname, subfolder);
      }
    }
    _bookBox.put(book.name, book.toJson());
  }

  deleteBook(Book book) async {
    if (!(_bookBox?.isOpen ?? false)) _bookBox = await openBookBox();
    if (!(_subfolderBox?.isOpen ?? false))
      _subfolderBox = await openSubfolderBox();
    if (!(_folderBox?.isOpen ?? false)) _folderBox = await openFolderBox();

    Map folder = _folderBox.get(book.fname);
    if (folder != null) {
      List books = folder['books'];
      books.remove(book.name);
      folder['books'] = books;
      _folderBox.put(book.fname, folder);
    }

    if (book.sname != null && book.sname.isNotEmpty) {
      Map subfolder = _subfolderBox.get(book.sname);
      if (subfolder != null) {
        List books = subfolder['books'];
        books.remove(book.name);
        subfolder['books'] = books;
        _folderBox.put(book.sname, subfolder);
      }
    }
    _bookBox.delete(book.name);
  }

  Future<Book> getBook(String bookName) async {
    if (!(_bookBox?.isOpen ?? false)) _bookBox = await openBookBox();
    return Book.fromMap(_bookBox.get(bookName));
  }
}
