import 'package:flutter/material.dart';
import 'package:mp3_music_converter/database/repository/song_repository.dart';
import 'package:mp3_music_converter/playlist/create_playlist_screen.dart';
import 'package:mp3_music_converter/screens/song/provider/music_provider.dart';
import 'package:mp3_music_converter/screens/song/provider/music_provider_services.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/utils/page_router/navigator.dart';
import 'package:provider/provider.dart';

Future<Widget> selectPlayListScreen({BuildContext context, String songName}) {
  MusicProvider _musicProvider;
  ScrollController _scrollController = ScrollController();
  _musicProvider = Provider.of<MusicProvider>(context, listen: false);
  List playlists = _musicProvider.playLists;
  List songs = [];
  playlists.sort((a, b) =>
      a.toString().toLowerCase().compareTo(b.toString().toLowerCase()));
  List<bool> selected = List.generate(playlists.length, (index) => false);
  songs.add(songName);
  bool showOkButton = false;
  List playListName = [];
  String selectedAction = 'add';
  return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Color.fromRGBO(40, 40, 40, 1),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Theme(
                  data: Theme.of(context).copyWith(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          songName,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(4)),
                          child: DropdownButtonFormField(
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.white,
                              ),
                              onChanged: (val) {
                                selectedAction = val;
                                setState(() {});
                              },
                              value: selectedAction,
                              elevation: 50,
                              dropdownColor: Colors.black,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 20))),
                              items: [
                                DropdownMenuItem(
                                  child: Row(
                                    children: [
                                      Icon(Icons.playlist_add,
                                          color: Colors.white),
                                      SizedBox(width: 10),
                                      Text(
                                        'Add to playlist',
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                  value: 'add',
                                ),
                                DropdownMenuItem(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.delete_forever,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Remove from playlist',
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                  value: 'remove',
                                ),
                              ]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Divider(height: 20, color: Colors.white),
                      ),
                      Flexible(
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          controller: _scrollController,
                          itemExtent: 40,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: playlists.length,
                          itemBuilder: (context, index) {
                            return Theme(
                              data: ThemeData(
                                  unselectedWidgetColor: Colors.white60),
                              child: CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                contentPadding: EdgeInsets.only(left: 0),
                                activeColor: Color.fromRGBO(216, 19, 37, 1),
                                dense: true,
                                checkColor: Colors.white,
                                value: selected[index],
                                onChanged: (val) {
                                  setState(() {
                                    selected[index] = val;
                                    if (selected[index] == true)
                                      playListName.add(playlists[index]);
                                    if (selected[index] == false)
                                      playListName.remove(playlists[index]);
                                    if (selected.contains(true) == true)
                                      showOkButton = true;
                                    if (selected.contains(true) == false)
                                      showOkButton = false;
                                  });
                                },
                                title: Text(
                                  playlists[index],
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: selected[index]
                                          ? Color.fromRGBO(216, 19, 37, 1)
                                          : Colors.white60),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      if (selectedAction == 'add') SizedBox(height: 20),
                      if (selectedAction == 'add')
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: InkWell(
                            onTap: () async {
                              final result = await createPlayListScreen(
                                  context: context, showToastMessage: false);
                              String name = result
                                  .toString()
                                  .substring(6, result.toString().length - 2);
                              if (playlists.contains(name) == false) {
                                playlists.add(name);
                                playlists.sort((a, b) => a
                                    .toString()
                                    .toLowerCase()
                                    .compareTo(b.toString().toLowerCase()));
                                selected.insert(playlists.indexOf(name), true);
                                playListName.add(name);
                              }
                              if (playlists.contains(name) == true) {
                                selected[playlists.indexOf(name)] = true;
                                if (playListName.contains(name) == false)
                                  playListName.add(name);
                              }
                              showOkButton = true;
                              _scrollController
                                  .jumpTo(playlists.indexOf(name) * 40.0);
                              setState(() {});
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(color: Colors.black),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'New Playlist'.toUpperCase(),
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              PageRouter.goBack(context);
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: Text('CANCEL',
                                  style: TextStyle(
                                      color: Color.fromRGBO(216, 19, 37, 1),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                            ),
                          ),
                          InkWell(
                            onTap: showOkButton
                                ? () async {
                                    if (selectedAction == 'add') {
                                      for (String elements in playListName) {
                                        await SongRepository.addSongsToPlayList(
                                            elements, songs);
                                      }

                                      PageRouter.goBack(context);
                                      showToast(context, message: 'Song added');
                                    } else if (selectedAction == 'remove') {
                                      for (String elements in playListName) {
                                        await SongRepository
                                            .removeSongFromPlayList(
                                                playListName: elements,
                                                songs: songs);
                                        _musicProvider
                                            .getPlayListSongTitle(elements);
                                      }
                                      PageRouter.goBack(context);
                                      showToast(context,
                                          message: 'Song removed');
                                    }
                                  }
                                : null,
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'OK',
                                style: TextStyle(
                                    color: showOkButton
                                        ? Color.fromRGBO(216, 19, 37, 1)
                                        : Color.fromRGBO(216, 19, 37, 0.5),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      });
}
