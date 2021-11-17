class Folder {
  String name;
  String id;
  List books;
  List subfolders;

  Folder(
      {this.name, this.id, this.books = const [], this.subfolders = const []});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> folderMap = Map();
    folderMap['name'] = this.name;
    folderMap['id'] = this.id;
    folderMap['books'] = this.books;
    folderMap['subfolders'] = this.subfolders;
    return folderMap;
  }

  Folder.fromMap(Map folder) {
    this.books = folder['books'];
    this.name = folder['name'];
    this.id = folder['id'];
    this.subfolders = folder['subfolders'];
  }
}

class Subfolder {
  String name;
  String id;
  String fid;
  List books;
  String fname;

  Subfolder({this.name, this.id, this.books = const [], this.fid, this.fname});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> subfolderMap = Map();
    subfolderMap['name'] = this.name;
    subfolderMap['id'] = this.id;
    subfolderMap['books'] = this.books;
    subfolderMap['fid'] = this.fid;
    subfolderMap['fname'] = this.fname;
    return subfolderMap;
  }

  Subfolder.fromMap(Map subfolder) {
    this.books = subfolder['books'];
    this.name = subfolder['name'];
    this.id = subfolder['id'];
    this.fid = subfolder['fid'];
    this.fname = subfolder['fname'];
  }
}

class Book {
  String name;
  String id;
  String fid;
  String sid;
  String path;
  String fname;
  String sname;

  Book(
      {this.name,
      this.id,
      this.fid,
      this.sid,
      this.path,
      this.fname,
      this.sname});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> bookMap = Map();
    bookMap['name'] = this.name;
    bookMap['id'] = this.id;
    bookMap['fid'] = this.fid;
    bookMap['sid'] = this.sid;
    bookMap['path'] = this.path;
    bookMap['fname'] = this.fname;
    bookMap['sname'] = this.sname;
    return bookMap;
  }

  Book.fromMap(Map book) {
    this.fid = book['fid'];
    this.name = book['name'];
    this.id = book['id'];
    this.sid = book['sid'];
    this.path = book['path'];
    this.fname = book['fname'];
    this.sname = book['sname'];
  }
}
