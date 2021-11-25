import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:mp3_music_converter/screens/bookworm/model/model.dart';
import 'package:mp3_music_converter/screens/bookworm/services/book_services.dart';
import 'package:mp3_music_converter/screens/song/provider/music_provider.dart';
import 'package:pdf_render/pdf_render_widgets2.dart';
import 'package:pdf_text/pdf_text.dart';

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

  initProvider(BuildContext context) {
    // _provider = Provider.of<MusicProvider>(context, listen: false);
    // this.context = context;
    AudioService.customEventStream.listen(
      (event) {
        if (event[AudioPlayerTask.TtsIsPlaying] != null) {
          isPlaying = event[AudioPlayerTask.TtsIsPlaying] ?? false;
          print('isPlaying: $isPlaying');
        }
        if (event[AudioPlayerTask.TtsCompletion] != null) {
          ttsCompleted = event[AudioPlayerTask.TtsCompletion] ?? false;
          print('ttsComplete: $ttsCompleted');
        }
        if (event[AudioPlayerTask.TtsOnError] != null) {
          hasError = event[AudioPlayerTask.TtsOnError] ?? false;
          print('hasError: $hasError');
        }
        notifyListeners();
      },
    );
  }

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

  startTts({String text, Book book, int page, int total}) async {
    if (page != null && total != null) lastPage = page == total ? true : false;
    // _provider.playerFunction = PlayerFunction.TTS;

    await addActionToAudioService(
      () => AudioService.customAction(
          AudioPlayerTask.CHANGEPLAYERFUNCTION, 'TTS'),
    );
    await addActionToAudioService(
      () => AudioService.customAction(
        AudioPlayerTask.TtsSPEAK,
      ),
    );

    notifyListeners();
  }

  getItems() {
    // getMediaItems(context, force: true);
  }

  stopTts() async {
    await addActionToAudioService(
      () => AudioService.customAction(AudioPlayerTask.TtsSTOP),
    );
    // _provider.playerFunction = PlayerFunction.MUSIC;
    await addActionToAudioService(
      () => AudioService.customAction(
          AudioPlayerTask.CHANGEPLAYERFUNCTION, 'MUSIC'),
    );
  }

  setPitch(double pitch) async {
    // currentPitch = pitch;
    await addActionToAudioService(
      () => AudioService.customAction(AudioPlayerTask.TtsSetPitch, pitch),
    );
  }

  setVoice(Map<String, String> voice) async {
    // currentVoice = voice;
    await addActionToAudioService(
      () => AudioService.customAction(AudioPlayerTask.TtsSetVoice, voice),
    );
  }

  setRate(double rate) async {
    // currentRate = rate;
    await addActionToAudioService(
      () => AudioService.customAction(AudioPlayerTask.TtsSetSpeechRate, rate),
    );
  }
}
