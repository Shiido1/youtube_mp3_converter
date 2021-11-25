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
  bool showModal = true;
  String createdBookPath;
  String createdBookName;
  bool isPlaying = false;
  bool ttsCompleted = false;
  bool hasError = false;
  bool lastPage = false;
  //false means the book is being read out while true means the user is playing a test voice from tts settings
  bool settings = false;

  // initProvider(BuildContext context) {
  //   // _provider = Provider.of<MusicProvider>(context, listen: false);
  //   // this.context = context;
  //   AudioService.customEventStream.listen(
  //     (event) {
  //       if (event[AudioPlayerTask.TtsIsPlaying] != null) {
  //         isPlaying = event[AudioPlayerTask.TtsIsPlaying] ?? false;
  //         print('isPlaying: $isPlaying');
  //       }
  //       if (event[AudioPlayerTask.TtsCompletion] != null) {
  //         ttsCompleted = event[AudioPlayerTask.TtsCompletion] ?? false;
  //         print('ttsComplete: $ttsCompleted');
  //       }
  //       if (event[AudioPlayerTask.TtsOnError] != null) {
  //         hasError = event[AudioPlayerTask.TtsOnError] ?? false;
  //         print('hasError: $hasError');
  //       }
  //       notifyListeners();
  //     },
  //   );
  // }

  getFolders() async {
    allFolders = await BookwormServices().getFolders();
    notifyListeners();
  }

  updateShowModal(bool showModal) {
    this.showModal = showModal;
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
    // print(currentSubfolder.toJson());
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
