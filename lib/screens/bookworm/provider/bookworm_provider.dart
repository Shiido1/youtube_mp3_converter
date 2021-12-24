import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart' as asp;
import 'package:flutter/material.dart';
import 'package:flutter_radio/flutter_radio.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:mp3_music_converter/screens/bookworm/model/model.dart';
import 'package:mp3_music_converter/screens/bookworm/services/book_services.dart';
import 'package:mp3_music_converter/screens/song/provider/music_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

enum location { Folder, Subfolder }

void _entryPoint2() {
  AudioServiceBackground.run(() => BookwormAudioPlayer());
}

Future<dynamic> addActionToBookwormAudioService(Function callback) async {
  if (!AudioService.connected) await AudioService.connect();
  if (AudioService.running == null || !AudioService.running) {
    await AudioService.start(
        backgroundTaskEntrypoint: _entryPoint2,
        androidNotificationClickStartsActivity: false);
  }
  return callback();
}

class BookwormAudioPlayer extends BackgroundAudioTask {
  FlutterTts flutterTts;
  asp.AudioSession audioSession;
  bool isPlaying = false;
  //flutterTts for reading books
  static const TtsSPEAK = 'ttsSpeak';
  static const TtsSTOP = 'ttsStop';
  static const TtsIsPlaying = 'ttsIsPlaying';
  static const TtsCompletion = 'ttsCompletionHandler';
  static const TtsSetVoice = 'ttsSetVoice';
  static const TtsSetPitch = 'ttsSetPitch';
  static const TtsSetSpeechRate = 'ttsSetSpeechRate';
  static const TtsOnError = 'ttsOnError';
  static const TtsPlayTestVoice = 'ttsPlayTestVoice';

  handleInterruptions(asp.AudioSession audioSession) {
    audioSession.interruptionEventStream.listen((event) async {
      if (event.begin) {
        if (isPlaying) {
          switch (event.type) {
            case asp.AudioInterruptionType.duck:
              if (audioSession.androidAudioAttributes.usage ==
                  asp.AndroidAudioUsage.game) await flutterTts.setVolume(0.3);
              break;
            case asp.AudioInterruptionType.pause:
            case asp.AudioInterruptionType.unknown:
              await flutterTts.setVolume(0.3);
              break;
          }
        }
      } else {
        switch (event.type) {
          case asp.AudioInterruptionType.duck:
          case asp.AudioInterruptionType.pause:
          case asp.AudioInterruptionType.unknown:
            await flutterTts.setVolume(1);
            break;
        }
      }
    });
  }

  void initAudio() async {
    flutterTts = FlutterTts();

    flutterTts.setCompletionHandler(() async {
      print('complete');
      AudioServiceBackground.sendCustomEvent({TtsCompletion: true});
      AudioServiceBackground.sendCustomEvent({TtsIsPlaying: false});
      AudioServiceBackground.sendCustomEvent({TtsOnError: false});
    });

    flutterTts.setCancelHandler(() async {
      print('cancelled');
      AudioServiceBackground.sendCustomEvent({TtsCompletion: false});
      AudioServiceBackground.sendCustomEvent({TtsIsPlaying: false});
      AudioServiceBackground.sendCustomEvent({TtsOnError: false});
    });

    flutterTts.setErrorHandler((message) async {
      print('handled');
      AudioServiceBackground.sendCustomEvent({TtsCompletion: false});
      AudioServiceBackground.sendCustomEvent({TtsIsPlaying: false});
      AudioServiceBackground.sendCustomEvent({TtsOnError: true});
    });

    flutterTts.setStartHandler(() async {
      print('started');
      AudioServiceBackground.sendCustomEvent({TtsCompletion: false});
      AudioServiceBackground.sendCustomEvent({TtsIsPlaying: true});
      AudioServiceBackground.sendCustomEvent({TtsOnError: false});
    });
  }

  Future<void> _broadcastState() async {
    await AudioServiceBackground.setState(
      controls: [
        MediaControl.stop,
      ],
      playing: true,
      processingState: AudioProcessingState.ready,
    );
  }

  @override
  Future<void> onStop() async {
    await flutterTts.stop();
    await _broadcastState();
    return super.onStop();
  }

  @override
  Future<void> onStart(Map<String, dynamic> params) async {
    initAudio();
    await _broadcastState();
    return super.onStart(params);
  }

  @override
  Future onCustomAction(String name, arguments) async {
    if (name == TtsSPEAK) {
      String text;
      PdfDocument doc;

      MediaItem mediaItem = MediaItem(
          id: 'tts', album: '', title: arguments['title'] ?? 'Bookworm Reader');
      await AudioServiceBackground.setMediaItem(mediaItem);
      if (await FlutterRadio?.isPlaying()) await FlutterRadio.stop();

      audioSession = await asp.AudioSession.instance;
      audioSession
          .configure(asp.AudioSessionConfiguration.music())
          .then((value) async {
        handleInterruptions(audioSession);

        if (arguments['text'] == null) {
          doc = PdfDocument(
              inputBytes: File(arguments['path']).readAsBytesSync());
          text = PdfTextExtractor(doc).extractText(
              startPageIndex: arguments['page'] - 1,
              endPageIndex: arguments['page'] - 1);
        } else {
          text = arguments['text'];
        }

        if (await audioSession.setActive(true)) {
          if (text != null && text.isNotEmpty) {
            await flutterTts.awaitSpeakCompletion(true);
            flutterTts.speak(text);
          } else
            flutterTts.completionHandler();
        }
      });
    }

    if (name == TtsSTOP) {
      await onStop();
    }

    if (name == TtsSetVoice) {
      await flutterTts
          .setVoice({'name': arguments['name'], 'locale': arguments['locale']});
    }

    if (name == TtsSetPitch) {
      await flutterTts.setPitch(arguments);
    }

    if (name == TtsSetSpeechRate) {
      await flutterTts.setSpeechRate(arguments);
    }

    return super.onCustomAction(name, arguments);
  }
}

class BookwormProvider extends ChangeNotifier {
  List<dynamic> allFolders = [];
  List<Book> folderBooks = [];
  List<Book> subfolderBooks = [];
  Folder currentFolder;
  Subfolder currentSubfolder;
  bool showModal = true;
  String createdBookPath;
  String createdBookName;

  Map voice;
  double pitch;
  double rate;

  bool isPlaying = false;
  bool ttsCompleted = false;
  bool hasError = false;
  int currentPage;
  int maxPage;

  initProvider() {
    AudioService.customEventStream.listen(
      (event) {
        if (!isPlayingMusic) {
          if (event[BookwormAudioPlayer.TtsIsPlaying] != null) {
            isPlaying = event[BookwormAudioPlayer.TtsIsPlaying] ?? false;
            // print('isPlaying: $isPlaying');
          }
          if (event[BookwormAudioPlayer.TtsCompletion] != null) {
            ttsCompleted = event[BookwormAudioPlayer.TtsCompletion] ?? false;
            print('ttsComplete: $ttsCompleted');
          }
          if (event[BookwormAudioPlayer.TtsOnError] != null) {
            hasError = event[BookwormAudioPlayer.TtsOnError] ?? false;
            print('hasError: $hasError');
          }
          notifyListeners();
        }
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

  startTts(Book book) async {
    await setVoice(voice);
    await setPitch(pitch);
    await setRate(rate == 0.0 ? 0.1 : rate);
    isPlaying = true;
    await addActionToBookwormAudioService(
      () async => AudioService.customAction(
        BookwormAudioPlayer.TtsSPEAK,
        {'path': book.path, 'title': book.name, 'page': currentPage},
      ),
    );
  }

  stopTts() async {
    isPlaying = false;
    await addActionToBookwormAudioService(
      () async => await AudioService.customAction(
        BookwormAudioPlayer.TtsSTOP,
      ),
    );
  }

  setVoice(Map voice) async {
    await addActionToBookwormAudioService(
      () async => await AudioService.customAction(
          BookwormAudioPlayer.TtsSetVoice, voice),
    );
  }

  setPitch(double pitch) async {
    await addActionToBookwormAudioService(
      () async => await AudioService.customAction(
          BookwormAudioPlayer.TtsSetPitch, pitch),
    );
  }

  setRate(double rate) async {
    await addActionToBookwormAudioService(
      () async => await AudioService.customAction(
          BookwormAudioPlayer.TtsSetSpeechRate, rate),
    );
  }
}
