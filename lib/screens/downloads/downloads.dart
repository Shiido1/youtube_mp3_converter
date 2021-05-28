import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';

class Downloads extends StatefulWidget {
  Downloads({Key key}) : super(key: key);

  @override
  _DownloadsState createState() => _DownloadsState();
}

class _DownloadsState extends State<Downloads> {
  List<DownloadTask> downloads = [];

  init() async {
    downloads = await FlutterDownloader.loadTasks();
    setState(() {});
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  String message(DownloadTaskStatus status) {
    if (status == DownloadTaskStatus(1)) return 'Waiting';
    if (status == DownloadTaskStatus(2)) return 'Downloading';
    if (status == DownloadTaskStatus(3)) return 'Download Complete';
    if (status == DownloadTaskStatus(4)) return 'Download Failed';
    if (status == DownloadTaskStatus(5)) return 'Download Canceled';
    if (status == DownloadTaskStatus(6)) return 'Download Paused';
    return 'Unknown Status';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.black,
        title: TextViewWidget(
          text: 'Downloads',
          color: AppColor.bottomRed,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_sharp,
            color: AppColor.bottomRed,
          ),
        ),
      ),
      body: downloads == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : downloads.isEmpty
              ? Center(
                  child: Text(
                    'No Downloads',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColor.white,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: downloads.length,
                  itemBuilder: (context, value) {
                    int index = downloads.length - 1 - value;
                    DownloadTask _download = downloads[index];
                    return Column(
                      children: [
                        ListTile(
                          title: Text(
                            _download.filename,
                            style: TextStyle(color: AppColor.white),
                          ),
                          trailing: _download.status == DownloadTaskStatus(3) ||
                                  _download.status == DownloadTaskStatus(5) ||
                                  _download.status == DownloadTaskStatus(0)
                              ? null
                              : _download.status == DownloadTaskStatus(4)
                                  ? IconButton(
                                      icon: Icon(
                                        IconData(58673,
                                            fontFamily: 'MaterialIcons'),
                                        color: AppColor.white,
                                        size: 30,
                                      ),
                                      onPressed: () {
                                        FlutterDownloader.retry(
                                            taskId: _download.taskId);
                                        init();
                                      },
                                    )
                                  : Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        if (_download.status ==
                                                DownloadTaskStatus(2) ||
                                            _download.status ==
                                                DownloadTaskStatus(6))
                                          IconButton(
                                              icon: Icon(
                                                _download.status ==
                                                        DownloadTaskStatus(6)
                                                    ? Icons.play_arrow
                                                    : Icons.pause,
                                                color: AppColor.white,
                                                size: 30,
                                              ),
                                              onPressed: () {
                                                if (_download.status ==
                                                    DownloadTaskStatus(6))
                                                  FlutterDownloader.resume(
                                                      taskId: _download.taskId);
                                                else
                                                  FlutterDownloader.pause(
                                                      taskId: _download.taskId);
                                                init();
                                              }),
                                        IconButton(
                                            icon: Icon(
                                              Icons.stop,
                                              color: AppColor.white,
                                              size: 30,
                                            ),
                                            onPressed: () {
                                              FlutterDownloader.cancel(
                                                  taskId: _download.taskId);
                                              init();
                                            })
                                      ],
                                    ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          message(_download.status),
                          style: TextStyle(color: Colors.grey),
                        ),
                        if (index != 0) Divider(color: AppColor.white)
                      ],
                    );
                  }),
    );
  }
}
