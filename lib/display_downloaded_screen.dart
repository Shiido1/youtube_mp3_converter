import 'package:flutter/material.dart';

import 'database/model/log.dart';
import 'database/repository/log_repository.dart';

class DownloadedScreen extends StatefulWidget {
  @override
  _DownloadedScreenState createState() => _DownloadedScreenState();
}

class _DownloadedScreenState extends State<DownloadedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: LogRepository.getLogs(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            List<dynamic> logList = snapshot.data;
            if (logList.isNotEmpty) {
              return ListView.builder(
                itemCount: logList.length,
                itemBuilder: (BuildContext context, int index) {
                  Log _log = logList[index];
                  return Column(
                    children: [
                      ListTile(
                        title: Text(_log?.fileName ?? ''),
                        subtitle: Text(_log?.filePath ?? ''),
                        onTap: () => print(
                            'to play this video use this: ${_log?.filePath}/${_log?.fileName}'),
                      ),
                      Divider(
                        thickness: 1,
                      )
                    ],
                  );
                },
              );
            }
            return ListTile(
              title: Text('File Name'),
              subtitle: Text('path'),
            );
          }
          return Center(child: Text('No Music Files.'));
        },
      ),
    );
  }
}
