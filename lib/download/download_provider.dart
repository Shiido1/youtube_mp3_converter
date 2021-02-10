import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

enum DownloadStatus { NotStarted, Started, Downloading, Complete }

class FileDownloaderProvider with ChangeNotifier {
  StreamSubscription _downloadSubscription;
  DownloadStatus _downloadStatus = DownloadStatus.NotStarted;
  int _downloadPercentage = 0;
  String _downloadFile = '';

  int get downloadPercentage => _downloadPercentage;
  DownloadStatus get downloadStatus => _downloadStatus;
  String get downloadedFile => _downloadFile;

  Future downloadFile(String url, String filename) async {
    bool _permissionReady = await _checkPermission();
    final Completer<void> completer = Completer<void>();

    if (!_permissionReady) {
      _checkPermission().then((hasGranted) {
        _permissionReady = hasGranted;
      });
    } else {
      var httpClient = http.Client();
      var request = new http.Request('GET', Uri.parse(url));
      var response = httpClient.send(request);

      final dir = Platform.isAndroid
          ? "sdcard/download"
          : (await getApplicationDocumentsDirectory()).path;

      List<List<int>> chunks = new List();
      int download = 0;
      updateDownloadStatus(DownloadStatus.Started);
      _downloadSubscription =
          response.asStream().listen((http.StreamedResponse r) {
        updateDownloadStatus(DownloadStatus.Downloading);
        r.stream.listen((List<int> chunk) async {
          print('downloadPercentage onListen: $_downloadPercentage');
          chunks.add(chunk);
          download == chunk.length;
          _downloadPercentage = (download / r.contentLength * 100).round();
          notifyListeners();
        }, onDone: () async {
          _downloadPercentage = (download / r.contentLength * 100).round();
          notifyListeners();
          print('downloadPercentage onDone: $_downloadPercentage');
          File file = new File('$dir/$filename');
          _downloadFile = '$dir/$filename';
          print(_downloadFile);
          final Uint8List bytes = Uint8List(r.contentLength);
          int offset = 0;
          for (List<int> chunk in chunks) {
            bytes.setRange(offset, offset + chunk.length, chunk);
            offset += chunk.length;
          }
          await file.writeAsBytes(bytes);
          updateDownloadStatus(DownloadStatus.Complete);
          _downloadSubscription?.cancel();
          _downloadPercentage = 0;
          notifyListeners();
          print('DownloadFile: Completed');
          completer.complete();
          return;
        });
      });
    }
    await completer.future;
  }

  void updateDownloadStatus(DownloadStatus status) {
    _downloadStatus = status;
    print('updateDownloadStatus: $status');
    notifyListeners();
  }

  Future<bool> _checkPermission() async {
    PermissionStatus permissionStatus = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    if (permissionStatus != PermissionStatus.granted) {
      Map<PermissionGroup, PermissionStatus> permissions =
          await PermissionHandler()
              .requestPermission([PermissionGroup.storage]);
      if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }
}
