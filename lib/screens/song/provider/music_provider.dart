import 'dart:convert';
import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audio_session/audio_session.dart' as asp;
import 'package:flutter/material.dart';
import 'package:mp3_music_converter/database/model/song.dart';
import 'package:mp3_music_converter/database/repository/song_repository.dart';
import 'package:mp3_music_converter/screens/recorded/provider/record_provider.dart';

import '../../../utils/helper/instances.dart';

enum PlayerType { ALL, SHUFFLE, REPEAT }

void _entryPoint() {
  AudioServiceBackground.run(() => AudioPlayerTask());
}

class AudioPlayerTask extends BackgroundAudioTask {
  AudioPlayer audioPlayer;
  static const POSITION_EVENT = 'POSITION_EVENT';
  static const DURATION_EVENT = 'DURATION_EVENT';
  static const STATE_CHANGE = 'STATE_CHANGE';
  static const STATE_CHANGE2 = 'STATE_CHANGE2';
  static const PLAY_ACTION = 'PLAY_ACTION';
  static const CHANGE_TYPE = 'CHANGE_TYPE';
  static const SET_VOLUME = 'SET_VOLUME';
  static const SEEK = 'SEEK';
  int index;
  PlayerType playerType = PlayerType.ALL;
  asp.AudioSession audioSession;

  void initPlayer() {
    audioPlayer = AudioPlayer();

    audioPlayer.onPlayerCompletion.listen((event) {
      List<MediaItem> mediaItems = AudioServiceBackground.queue;
      switch (playerType) {
        case PlayerType.ALL:
          if (index != null && index < mediaItems.length - 1) {
            index = index + 1;
            AudioServiceBackground.setMediaItem(mediaItems[index]);
            AudioService.customAction(PLAY_ACTION);
          } else {
            audioPlayer.state = AudioPlayerState.STOPPED;
          }
          break;
        case PlayerType.SHUFFLE:
          playRandom(mediaItems);
          break;
        case PlayerType.REPEAT:
          AudioService.customAction(PLAY_ACTION);
          break;
      }

      _broadcastState();
    });

    audioPlayer.onPlayerStateChanged.listen((event) {
      AudioServiceBackground.sendCustomEvent({STATE_CHANGE: event});
      _broadcastState();
    });

    audioPlayer.onAudioPositionChanged.listen((position) {
      AudioServiceBackground.sendCustomEvent(
          {POSITION_EVENT: position.inSeconds});
      _broadcastState();
    });

    audioPlayer.onDurationChanged.listen((duration) {
      AudioServiceBackground.sendCustomEvent(
          {DURATION_EVENT: duration.inSeconds});
      AudioServiceBackground.setMediaItem(
          AudioServiceBackground.mediaItem.copyWith(duration: duration));
      AudioServiceBackground.sendCustomEvent(
          {STATE_CHANGE2: audioPlayer.state});

      _broadcastState();
    });
  }

  AudioProcessingState _getProcessingState() {
    switch (audioPlayer.state) {
      case AudioPlayerState.STOPPED:
        return AudioProcessingState.stopped;
        break;
      case AudioPlayerState.PLAYING:
        return AudioProcessingState.ready;
        break;
      case AudioPlayerState.PAUSED:
        return AudioProcessingState.ready;
        break;
      case AudioPlayerState.COMPLETED:
        return AudioProcessingState.completed;
        break;
      default:
        return AudioProcessingState.ready;
    }
  }

  savePlayingSong(Map song) {
    preferencesHelper.saveValue(key: 'last_play', value: json.encode(song));
  }

  Future<void> _broadcastState({Duration position}) async {
    await AudioServiceBackground.setState(
        controls: [
          MediaControl.skipToPrevious,
          audioPlayer.state == AudioPlayerState.PLAYING
              ? MediaControl.pause
              : MediaControl.play,
          MediaControl.stop,
          MediaControl.skipToNext
        ],
        playing: audioPlayer.state == AudioPlayerState.PLAYING,
        processingState: _getProcessingState(),
        position: position != null ? position : Duration());
  }

  void handleInterruptions(asp.AudioSession audioSession) async {
    bool interrupted = false;
    audioSession.becomingNoisyEventStream.listen((event) async {
      await onPause();
    });

    audioPlayer.onPlayerStateChanged.listen((event) {
      interrupted = false;
      if (event == AudioPlayerState.PLAYING) audioSession.setActive(true);
    });
    audioSession.interruptionEventStream.listen((event) async {
      if (event.begin) {
        switch (event.type) {
          case asp.AudioInterruptionType.duck:
            if (audioSession.androidAudioAttributes.usage ==
                asp.AndroidAudioUsage.game)
              await AudioService.customAction(AudioPlayerTask.SET_VOLUME, 0.3);
            interrupted = false;
            break;
          case asp.AudioInterruptionType.pause:
          case asp.AudioInterruptionType.unknown:
            await onPause();
            interrupted = true;
            break;
        }
      } else {
        switch (event.type) {
          case asp.AudioInterruptionType.duck:
            await AudioService.customAction(AudioPlayerTask.SET_VOLUME, 1);
            interrupted = false;
            break;
          case asp.AudioInterruptionType.pause:
            if (interrupted) {
              await onPlay();
              interrupted = false;
            }
            break;
          case asp.AudioInterruptionType.unknown:
            if (interrupted) {
              await onPlay();
              interrupted = false;
            }
            break;
        }
      }
    });
  }

  @override
  Future<void> onStart(Map<String, dynamic> params) async {
    initPlayer();
    await _broadcastState();
    return super.onStart(params);
  }

  @override
  Future<void> onStop() async {
    await audioPlayer.stop();
    await _broadcastState();
    return super.onStop();
  }

  @override
  Future<void> onPlay() async {
    await audioPlayer.resume();
    _broadcastState();
    return super.onPlay();
  }

  @override
  Future<void> onSkipToQueueItem(String mediaId) {
    List<MediaItem> mediaItems = AudioServiceBackground.queue;
    MediaItem mediaItem =
        mediaItems.firstWhere((element) => element.id == mediaId);
    AudioServiceBackground.setMediaItem(mediaItem);
    return super.onSkipToQueueItem(mediaId);
  }

  void playRandom(List<MediaItem> songs) {
    Random r = new Random();
    int songIndex = r.nextInt(songs.length);
    index = songIndex;
    AudioServiceBackground.setMediaItem(songs[index]);
    AudioService.customAction(PLAY_ACTION);
  }

  @override
  Future<void> onSkipToNext() {
    List<MediaItem> mediaItems = AudioServiceBackground.queue;

    if (index != null && index < mediaItems.length - 1) {
      index = index + 1;
      AudioServiceBackground.setMediaItem(mediaItems[index]);
      AudioService.customAction(PLAY_ACTION);
    }
    return super.onSkipToNext();
  }

  @override
  Future<void> onSkipToPrevious() {
    List<MediaItem> mediaItems = AudioServiceBackground.queue;

    if (index != null && index > 0) {
      index = index - 1;
      AudioServiceBackground.setMediaItem(mediaItems[index]);
      AudioService.customAction(PLAY_ACTION);
    }

    return super.onSkipToPrevious();
  }

  @override
  Future<void> onPause() async {
    await audioPlayer.pause();
    _broadcastState();
    return super.onPause();
  }

  @override
  Future onCustomAction(String name, arguments) async {
    if (name == PLAY_ACTION) {
      List<MediaItem> mediaItems = AudioServiceBackground.queue;
      MediaItem mediaItem = AudioServiceBackground.mediaItem;
      savePlayingSong({
        'artist': mediaItem.artist,
        'album': mediaItem.album,
        'id': mediaItem.id,
        'title': mediaItem.title,
        'filePath': mediaItem.extras['filePath'],
        'fileName': mediaItem.extras['fileName'],
        'favourite': mediaItem.extras['favourite'],
        'image': mediaItem.extras['image']
      });
      if (mediaItems != null && mediaItems.isNotEmpty)
        index = mediaItems.indexWhere((element) => element.id == mediaItem.id);
      audioSession = await asp.AudioSession.instance;
      audioSession
          .configure(asp.AudioSessionConfiguration.music())
          .then((value) async {
        handleInterruptions(audioSession);

        if (await audioSession.setActive(true)) {
          await audioPlayer.play(mediaItem.id,
              isLocal: true, position: Duration(seconds: 0));
        } else {
          print('could not play');
        }
      });
    }
    if (name == CHANGE_TYPE) {
      if (arguments == 'ALL') playerType = PlayerType.ALL;
      if (arguments == 'SHUFFLE') playerType = PlayerType.SHUFFLE;
      if (arguments == 'REPEAT') playerType = PlayerType.REPEAT;
    }
    if (name == SET_VOLUME) {
      audioPlayer.setVolume(arguments);
    }
    if (name == SEEK) {
      Duration newDuration = Duration(seconds: arguments);
      audioPlayer.seek(newDuration);
    }
    _broadcastState();
    return super.onCustomAction(name, arguments);
  }

  @override
  Future<void> onUpdateQueue(List<MediaItem> queue) {
    AudioServiceBackground.setQueue(queue);
    return super.onUpdateQueue(queue);
  }

  @override
  Future<void> onUpdateMediaItem(MediaItem mediaItem) {
    AudioServiceBackground.setMediaItem(mediaItem);
    return super.onUpdateMediaItem(mediaItem);
  }
}

class MusicProvider with ChangeNotifier {
  Duration totalDuration = Duration();
  Duration progress = Duration();
  Song currentSong;
  Song drawerItem;
  List<Song> songs = [];
  List<Song> allSongs = [];
  List playLists = [];
  List playListSongTitle = [];
  List<Song> favoriteSongs = [];
  bool shuffleSong = false;
  bool repeatSong = false;
  int _currentSongIndex = -1;
  int get length => songs.length;
  int get songNumber => _currentSongIndex + 1;
  String currentSongID = '';

  AudioPlayerState audioPlayerState;
  // PlayerControlCommand playerControlCommand;
  PlayerType playerType = PlayerType.ALL;

  Future<void> initProvider() async {
    SongRepository.init();
    await initPlayer();
  }

  getSongs() async {
    allSongs = await SongRepository.getSongs();
    notifyListeners();
  }

  getPlayListNames() async {
    playLists = await SongRepository.getPlayListNames();
    notifyListeners();
  }

  getPlayListSongTitle(key) async {
    playListSongTitle = await SongRepository.getPlayListsSongs(key);
    notifyListeners();
  }

  getFavoriteSongs() async {
    favoriteSongs = await SongRepository.getFavoriteSongs();
    notifyListeners();
  }

  updateSong(Song song) {
    songs.forEach((element) {
      if (element.fileName == song.fileName) {
        element = song;
      }
    });
    SongRepository.addSong(song);
    notifyListeners();
  }

  Future<void> initPlayer() async {
    await AudioService.start(backgroundTaskEntrypoint: _entryPoint);
    AudioService.customEventStream.listen((event) async {
      if (event[AudioPlayerTask.DURATION_EVENT] != null) {
        totalDuration =
            Duration(seconds: event[AudioPlayerTask.DURATION_EVENT]) ??
                Duration();

        if (songs == null || songs.isEmpty)
          songs = convertMediaItemToSong(
              AudioService.queue ?? [AudioService.currentMediaItem]);
        if (currentSong == null) {
          currentSong = Song(
            artistName: AudioService.currentMediaItem.artist,
            fileName: AudioService.currentMediaItem.extras['fileName'],
            favorite: AudioService.currentMediaItem.extras['favourite'],
            filePath: AudioService.currentMediaItem.extras['filePath'],
            image: AudioService.currentMediaItem.extras['image'],
            songName: AudioService.currentMediaItem.title,
          );

          updateDrawer(currentSong);
        }

        notifyListeners();
      }
      if (event[AudioPlayerTask.POSITION_EVENT] != null) {
        progress = Duration(seconds: event[AudioPlayerTask.POSITION_EVENT]) ??
            Duration();
        notifyListeners();
      }
      if (event[AudioPlayerTask.STATE_CHANGE] != null) {
        audioPlayerState = event[AudioPlayerTask.STATE_CHANGE];
        notifyListeners();
      }
      if (event[AudioPlayerTask.STATE_CHANGE2] != null) {
        audioPlayerState = event[AudioPlayerTask.STATE_CHANGE2];
        notifyListeners();
      }
    });

    AudioService.currentMediaItemStream.listen((event) {
      if (event != null) {
        currentSongID = event.id;
        currentSong = songs.firstWhere((element) => element.file == event.id,
            orElse: () => Song(
                  artistName: event.artist,
                  fileName: event.extras['fileName'],
                  favorite: event.extras['favourite'],
                  filePath: event.extras['filePath'],
                  image: event.extras['image'],
                  songName: event.title,
                ));
        updateDrawer(currentSong);
      }

      notifyListeners();
    });
  }

  void updateLocal(MediaItem song) {
    if (audioPlayerState != AudioPlayerState.PLAYING &&
        audioPlayerState != AudioPlayerState.PAUSED) {
      progress = Duration();
      totalDuration = Duration();
      currentSong = songs.firstWhere((element) => element.file == song.id,
          orElse: () => Song(
                artistName: song.artist,
                fileName: song.extras['fileName'],
                favorite: song.extras['favourite'],
                filePath: song.extras['filePath'],
                image: song.extras['image'],
                songName: song.title,
              ));
      AudioService.updateMediaItem(song);
      notifyListeners();
    }
  }

  void updateDrawer(Song log) {
    drawerItem = log;
  }

  void seekToSecond(int second) {
    AudioService.customAction(AudioPlayerTask.SEEK, second);
  }

  List<MediaItem> convertSongToMediaItem(List<Song> songs) {
    List<MediaItem> item = [];
    for (int i = 0; i < songs.length; i++) {
      item.insert(
          i,
          MediaItem(
              artist: songs[i].artistName ?? 'Unknown artist',
              title: songs[i].songName ?? 'Unknown',
              id: songs[i].file,
              album: songs[i].songName ?? 'Unknown',
              extras: {
                'image': songs[i].image,
                'filePath': songs[i].filePath,
                'fileName': songs[i].fileName,
                'favourite': songs[i].favorite,
              }));
    }
    return item;
  }

  List<Song> convertMediaItemToSong(List<MediaItem> items) {
    List<Song> playingSongs = [];
    for (int i = 0; i < items.length; i++) {
      playingSongs.insert(
          i,
          Song(
              artistName: items[i].artist,
              songName: items[i].title,
              fileName: items[i].extras['fileName'],
              filePath: items[i].extras['filePath'],
              favorite: items[i].extras['favourite'],
              image: items[i].extras['image']));
    }
    return playingSongs;
  }

  void playAudio(
    Song song,
  ) async {
    currentSong = song;
    if (song.file == currentSongID) return;
    await addActionToAudioService(() async =>
        await AudioService.updateQueue(convertSongToMediaItem(songs)));
    await addActionToAudioService(
        () async => await AudioService.skipToQueueItem(song.file));
    await addActionToAudioService(() async =>
        await AudioService.customAction(AudioPlayerTask.PLAY_ACTION));

    notifyListeners();
  }

  Future<dynamic> addActionToAudioService(Function callback) async {
    if (AudioService.running == null || !AudioService.running)
      await initPlayer();
    return callback();
  }

  void resumeAudio() async {
    await addActionToAudioService(() async => await AudioService.play());
    notifyListeners();
  }

  void pauseAudio() async {
    await addActionToAudioService(() async => await AudioService.pause());
    notifyListeners();
  }

  Future next() async {
    await addActionToAudioService(() async => await AudioService.skipToNext());
    notifyListeners();
  }

  Future prev() async {
    await addActionToAudioService(
        () async => await AudioService.skipToPrevious());
    notifyListeners();
  }

  Future shuffle(bool force) async {
    shuffleSong = true;
    await addActionToAudioService(() async => await AudioService.customAction(
        AudioPlayerTask.CHANGE_TYPE, 'SHUFFLE'));
    if (force) {
      Random r = new Random();
      int songIndex = r.nextInt(songs.length);
      playAudio(songs[songIndex]);
    }
    notifyListeners();
  }

  Future stopShuffle() async {
    shuffleSong = false;
    await addActionToAudioService(
        () => AudioService.customAction(AudioPlayerTask.CHANGE_TYPE, 'ALL'));
    notifyListeners();
  }

  Future repeat(Song song) async {
    repeatSong = true;
    await addActionToAudioService(
        () => AudioService.customAction(AudioPlayerTask.CHANGE_TYPE, 'REPEAT'));
    notifyListeners();
  }

  Future undoRepeat() async {
    repeatSong = false;
    await addActionToAudioService(
        () => AudioService.customAction(AudioPlayerTask.CHANGE_TYPE, 'ALL'));
    notifyListeners();
  }

  handlePlaying() async {
    switch (audioPlayerState) {
      case AudioPlayerState.STOPPED:
        updateAndPlay();
        break;
      case AudioPlayerState.PAUSED:
        resumeAudio();
        break;
      case AudioPlayerState.PLAYING:
        pauseAudio();
        break;
      case AudioPlayerState.COMPLETED:
        updateAndPlay();
        break;
      default:
        updateAndPlay();
    }
  }

  updateAndPlay() async {
    if (currentSong != null) {
      await AudioService.updateMediaItem(MediaItem(
          artist: currentSong.artistName ?? 'Unknown artist',
          title: currentSong.songName ?? 'Unknown',
          id: currentSong.file,
          album: currentSong.songName ?? 'Unknown',
          extras: {
            'image': currentSong.image,
            'filePath': currentSong.filePath,
            'fileName': currentSong.fileName,
            'favourite': currentSong.favorite,
          }));
      await addActionToAudioService(
          () => AudioService.customAction(AudioPlayerTask.PLAY_ACTION));
    }
  }

  setCurrentIndex(int index) {
    _currentSongIndex = index;
  }

  int get currentIndex => _currentSongIndex;

  bool get canNextSong => _currentSongIndex == length - 1;
  bool get canPrevSong => _currentSongIndex == 0;
}
