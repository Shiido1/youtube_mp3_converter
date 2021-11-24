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
    if (!(_subfolderBox?.isOpen ?? false))
      _subfolderBox = await openSubfolderBox();
    if (!(_bookBox?.isOpen ?? false)) _bookBox = await openBookBox();
    Map folder = _folderBox.get(oldName);
    List subfolders = folder['subfolders'] ?? [];
    List books = folder['books'] ?? [];
    for (String subfolder in subfolders) {
      Subfolder sub = Subfolder.fromMap(_subfolderBox.get(subfolder));
      sub.fname = newName;
      _subfolderBox.put(subfolder, sub.toJson());
    }
    for (String book in books) {
      Book myBook = Book.fromMap(_bookBox.get(book));
      myBook.fname = newName;
      _bookBox.put(book, myBook.toJson());
    }
    _folderBox.delete(oldName);
    folder['name'] = newName;
    _folderBox.put(newName, folder);
  }

  //subfolders
  createSubfolder(Subfolder subfolder) async {
    if (!(_subfolderBox?.isOpen ?? false))
      _subfolderBox = await openSubfolderBox();
    if (!(_folderBox?.isOpen ?? false)) _folderBox = await openFolderBox();
    Map folders = _folderBox.get(subfolder.fname);
    if (folders != null) {
      List subfolds = folders['subfolders'];
      subfolds.add(subfolder.name);
      folders['subfolders'] = subfolds;
      _folderBox.put(subfolder.fname, folders);
    }

    _subfolderBox.put(subfolder.name, subfolder.toJson());
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
    if (!(_bookBox?.isOpen ?? false)) _bookBox = await openBookBox();
    Map contents = _subfolderBox.get(subfolder.name);
    Map folders = _folderBox.get(subfolder.fname);
    if (folders != null) {
      List subfolds = folders['subfolders'];
      subfolds.remove(subfolder.name);
      subfolds.add(newName);
      folders['subfolders'] = subfolds;
      _folderBox.put(subfolder.fname, folders);
    }
    List books = contents['books'];
    for (String book in books) {
      Book myBook = Book.fromMap(_bookBox.get(book));
      myBook.sname = newName;
      _bookBox.put(book, myBook.toJson());
    }
    contents['name'] = newName;
    _subfolderBox.delete(subfolder.name);
    _subfolderBox.put(newName, contents);
  }

  deleteSubfolder(Subfolder subfolder) async {
    if (!(_subfolderBox?.isOpen ?? false))
      _subfolderBox = await openSubfolderBox();
    if (!(_bookBox?.isOpen ?? false)) _bookBox = await openBookBox();
    if (!(_folderBox?.isOpen ?? false)) _folderBox = await openFolderBox();

    Map subfolderDetails = _subfolderBox.get(subfolder.name);
    List books = subfolderDetails['books'] ?? [];
    for (int i = 0; i < books.length; i++) {
      _bookBox.delete(books[i]);
    }
    Map folders = _folderBox.get(subfolder.fname);
    if (folders != null) {
      List subfolds = folders['subfolders'];
      subfolds.remove(subfolder.name);
      folders['subfolders'] = subfolds;
      _folderBox.put(subfolder.fname, folders);
    }
    _subfolderBox.delete(subfolder.name);
  }

  // deleteThis() async {
  //   if (!(_subfolderBox?.isOpen ?? false))
  //     _subfolderBox = await openSubfolderBox();
  //   if (!(_folderBox?.isOpen ?? false)) _folderBox = await openFolderBox();
  //   _subfolderBox.delete('Namtes');
  //   Map folder = _folderBox.get('Notme');
  //   List subfolder = folder['subfolders'];
  //   subfolder.remove('Namtes');
  //   _folderBox.put('Notme', folder);
  // }

  //books
  addBook(Book book) async {
    if (!(_bookBox?.isOpen ?? false)) _bookBox = await openBookBox();
    if (!(_subfolderBox?.isOpen ?? false))
      _subfolderBox = await openSubfolderBox();
    if (!(_folderBox?.isOpen ?? false)) _folderBox = await openFolderBox();

    if (book.sname != null && book.sname.isNotEmpty) {
      Map subfolder = _subfolderBox.get(book.sname);
      if (subfolder != null) {
        List books = subfolder['books'];
        books.add(book.name);
        subfolder['books'] = books;
        _subfolderBox.put(book.sname, subfolder);
      }
    } else {
      Map folder = _folderBox.get(book.fname);
      if (folder != null) {
        List books = folder['books'];
        books.add(book.name);
        folder['books'] = books;
        _folderBox.put(book.fname, folder);
      }
    }
    _bookBox.put(book.name, book.toJson());
  }

  deleteBook(Book book) async {
    if (!(_bookBox?.isOpen ?? false)) _bookBox = await openBookBox();
    if (!(_subfolderBox?.isOpen ?? false))
      _subfolderBox = await openSubfolderBox();
    if (!(_folderBox?.isOpen ?? false)) _folderBox = await openFolderBox();

    if (book.sname != null && book.sname.isNotEmpty) {
      Map subfolder = _subfolderBox.get(book.sname);
      if (subfolder != null) {
        List books = subfolder['books'];
        books.remove(book.name);
        subfolder['books'] = books;
        _subfolderBox.put(book.sname, subfolder);
      }
    } else {
      Map folder = _folderBox.get(book.fname);
      if (folder != null) {
        List books = folder['books'];
        books.remove(book.name);
        folder['books'] = books;
        _folderBox.put(book.fname, folder);
      }
    }
    _bookBox.delete(book.name);
  }

  Future<Book> getBook(String bookName) async {
    if (!(_bookBox?.isOpen ?? false)) _bookBox = await openBookBox();
    return Book.fromMap(_bookBox.get(bookName));
  }

  clearAll() async {
    if (!(_bookBox?.isOpen ?? false)) _bookBox = await openBookBox();
    if (!(_subfolderBox?.isOpen ?? false))
      _subfolderBox = await openSubfolderBox();
    if (!(_folderBox?.isOpen ?? false)) _folderBox = await openFolderBox();
    _bookBox.clear();
    _folderBox.clear();
    _subfolderBox.clear();
  }
}
