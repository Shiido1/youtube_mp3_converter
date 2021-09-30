import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mp3_music_converter/database/model/song.dart';
import 'package:mp3_music_converter/database/repository/song_repository.dart';
import 'package:mp3_music_converter/screens/recorded/model/recorder_model.dart';
import 'package:mp3_music_converter/screens/recorded/provider/record_provider.dart';
import 'package:mp3_music_converter/screens/recorded/public_share.dart';
import 'package:mp3_music_converter/screens/recorded/recorded_drawer.dart';
import 'package:mp3_music_converter/screens/recorded/recorder_services.dart';
import 'package:mp3_music_converter/screens/song/provider/music_provider.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:http/http.dart' as http;
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';
import 'package:mp3_music_converter/widgets/progress_indicator.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_search/dropdown_search.dart';

class UploadSong extends StatefulWidget {
  final bool isRecord;
  final RecorderModel model;
  final bool isPrivate;

  UploadSong(this.isRecord, {this.model, this.isPrivate = false});

  @override
  _UploadSongState createState() => _UploadSongState();
}

class _UploadSongState extends State<UploadSong> {
  final _formKey = GlobalKey<FormState>();
  Map selectedVal;
  List genre;
  bool other = false;
  TextEditingController _songNameController;
  TextEditingController _songGenreController;
  TextEditingController _commentController;
  TextEditingController _artistNameController;
  TextEditingController _selectedSongController;
  bool showImage = false;
  bool showSongName = false;
  File selectedImage;
  File selectedSong;
  String songName;
  CustomProgressIndicator _progressIndicator;

  getSongCategories() async {
    String url = 'https://youtubeaudio.com/api/categoryapi';
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List decodedResponse = jsonDecode(response.body)['data'];
        setState(() {
          genre = decodedResponse;
        });
      } else {
        showToast(context,
            message: 'Failed to get details. Try again later',
            backgroundColor: Colors.white,
            textColor: Colors.black);
        Navigator.pop(context);
      }
    } catch (e) {
      showToast(context,
          message: 'Failed to get details. Try again later',
          backgroundColor: Colors.white,
          textColor: Colors.black);
      Navigator.pop(context);
    }
  }

  Future<File> pickFile(String type) async {
    FileType fileType = type == 'image' ? FileType.image : FileType.audio;
    FilePickerResult picker =
        await FilePicker.platform.pickFiles(type: fileType);
    if (fileType == FileType.audio)
      songName = picker?.names?.first == null ? songName : picker.names.first;

    if (picker?.files?.first?.path != null)
      return File(picker.files.first.path);
    return type == 'image' ? selectedImage : selectedSong;
  }

  uploadSong({File image, File song}) async {
    String baseUrl = 'http://www.youtubeaudio.com/api/uploadsongapi';
    String token = await preferencesHelper.getStringValues(key: 'token');
    _progressIndicator.show();

    try {
      var postUri = Uri.parse(baseUrl);
      var request = new http.MultipartRequest("POST", postUri);
      request.headers['Content-Type'] = 'multipart/form-data';
      request.fields['token'] = token;
      request.fields['title'] = _songNameController.text;
      request.fields['songname'] = _songNameController.text;
      request.fields['artist'] = _artistNameController.text;
      request.fields['comment'] = _commentController.text;
      request.fields['genre'] = selectedVal['name'];
      request.fields['category'] = selectedVal['id'].toString();

      request.files.add(await http.MultipartFile.fromPath('music', song.path));
      request.files.add(await http.MultipartFile.fromPath('image', image.path));

      var response = await request.send();
      await _progressIndicator.dismiss();
      if (response.statusCode == 200) {
        String jsonData = await response.stream.bytesToString();
        var decodedData = jsonDecode(jsonData);
        print(decodedData);

        if (decodedData['message']
            .toString()
            .toLowerCase()
            .contains('success')) {
          showToast(context,
              message: 'Song uploaded successfully!',
              backgroundColor: Colors.white,
              textColor: Colors.black);
          if (widget.isRecord) {
            updateRecordDetails(
                decodedData['musicid'].toString(), decodedData['libid']);
          } else {
            saveSongToHive(
                artistName: _artistNameController.text,
                songName: _songNameController.text,
                fileName: songName,
                path: song.path,
                image: decodedData['path'][0] == '/'
                    ? 'https://youtubeaudio.com' + decodedData['path']
                    : decodedData['path'],
                libid: decodedData['libid'],
                musicid: decodedData['musicid'].toString());
          }

          if (!widget.isRecord) Navigator.pop(context);
        } else
          showToast(context,
              message: 'Failed to upload song. Please try again',
              backgroundColor: Colors.white,
              textColor: Colors.black);
      } else {
        print(response.reasonPhrase);
        showToast(context,
            message: 'Failed to upload song. Please try again',
            backgroundColor: Colors.white,
            textColor: Colors.black);
      }
    } catch (e) {
      print(e);
      _progressIndicator.dismiss();
      showToast(context,
          message: 'Failed to upload song. Please try again',
          backgroundColor: Colors.white,
          textColor: Colors.black);
    }
  }

  saveSongToHive(
      {String musicid,
      int libid,
      String songName,
      String artistName,
      String image,
      String path,
      String fileName}) {
    List songPath = path.split('/');

    songPath.removeLast();
    if (path.endsWith('/')) songPath.removeLast();

    SongRepository.addSong(
      Song(
        artistName: artistName,
        favorite: false,
        musicid: musicid,
        songName: songName,
        libid: libid,
        image: image,
        filePath: songPath.join('/'),
        fileName: fileName,
        lastPlayDate: DateTime.now(),
      ),
    );
    Provider.of<MusicProvider>(context, listen: false).getSongs();
  }

  updateRecordDetails(String musicid, int libid) async {
    await RecorderServices()
        .editRecording(widget.model, musicid: musicid.toString(), libid: libid);

    Provider.of<RecordProvider>(context, listen: false).getRecords();
    if (!widget.isPrivate) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PublicShare(libid),
        ),
      );
    } else {
      Navigator.pop(context);
      showRecorderPrivateShareDialog(context, libid);
    }
  }

  @override
  void initState() {
    this._progressIndicator = CustomProgressIndicator(this.context);
    _songGenreController = TextEditingController();
    _commentController = TextEditingController();
    _songNameController = TextEditingController();
    _artistNameController = TextEditingController();
    _selectedSongController = TextEditingController();
    getSongCategories();
    super.initState();
  }

  @override
  void dispose() {
    _songGenreController.dispose();
    _songNameController.dispose();
    _commentController.dispose();
    _artistNameController.dispose();
    _selectedSongController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.black,
        title: TextViewWidget(
          text: 'Upload Song',
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
      body: genre == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    SizedBox(height: 20),
                    if (!widget.isRecord)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: TextButton(
                              onPressed: () async {
                                selectedSong = await pickFile('audio');
                                setState(() {
                                  showSongName =
                                      selectedSong != null ? true : false;
                                  _selectedSongController.text = songName;
                                });
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white)),
                              child: Text(
                                'Choose Song',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          if (showSongName)
                            Container(
                              margin: EdgeInsets.only(bottom: 20),
                              child: TextFormField(
                                controller: _selectedSongController,
                                decoration: decoration.copyWith(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 3),
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                readOnly: true,
                                minLines: 1,
                                maxLines: 3,
                                style: TextStyle(color: Colors.white54),
                              ),
                            ),
                        ],
                      ),
                    TextFormField(
                      textCapitalization: TextCapitalization.words,
                      controller: _songNameController,
                      style: TextStyle(color: AppColor.white),
                      decoration: decoration.copyWith(
                          labelText: 'Song name', hintText: 'Enter song name'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (val) {
                        return val.isNotEmpty ? null : 'Enter song name';
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      textCapitalization: TextCapitalization.words,
                      controller: _artistNameController,
                      style: TextStyle(color: AppColor.white),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: decoration.copyWith(
                          labelText: 'Artist name',
                          hintText: 'Enter artist name'),
                      validator: (val) {
                        return val.isNotEmpty ? null : 'Enter artist name';
                      },
                    ),
                    SizedBox(height: 20),
                    DropdownSearch(
                      mode: Mode.MENU,
                      label: 'Song genre',
                      items: genre.map((e) => e['name']).toList(),
                      hint: 'Select song genre',
                      maxHeight: 500,
                      popupShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      dropdownSearchDecoration: decoration.copyWith(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 12)),
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      popupBackgroundColor: Colors.black,

                      popupItemBuilder: (context, data, val) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          child: Text(
                            data,
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        );
                      },
                      validator: (val) {
                        return val == null ? 'Select a genre' : null;
                      },
                      onChanged: (val) {
                        setState(() {
                          selectedVal = genre
                              .firstWhere((element) => element['name'] == val);
                        });
                      },
                      emptyBuilder: (context, data) {
                        return Container(
                          alignment: Alignment.topCenter,
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            'No result',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      },

                      dropdownBuilder: (context, data, val) {
                        return Text(
                          val == null || val.isEmpty
                              ? 'Select song genre'
                              : val,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        );
                      },
                      dropDownButton: Icon(Icons.arrow_drop_down,
                          color: Colors.white, size: 30),
                      searchFieldProps: TextFieldProps(
                          decoration: decoration.copyWith(
                            hintText: 'Search song genre',
                            hintStyle: TextStyle(color: Colors.white54),
                          ),
                          style: TextStyle(color: Colors.white)),
                      //   .copyWith(
                      //       border: OutlineInputBorder(
                      //         borderSide: BorderSide(color: AppColor.black),
                      //       ),
                      //       focusedBorder: OutlineInputBorder(
                      //         borderSide: BorderSide(color: AppColor.black),
                      //       ),
                      //       enabledBorder: OutlineInputBorder(
                      //         borderSide: BorderSide(color: AppColor.black),
                      //       ),
                      //       hintText: 'Enter song genre',
                      //       hintStyle: TextStyle(color: Colors.black54)),
                      // ),
                      showSearchBox: true,
                    ),
                    // DropdownButtonFormField(
                    //     style: TextStyle(
                    //       color: Colors.white,
                    //     ),
                    //     items: genre
                    //         .map((e) => DropdownMenuItem(
                    //               child: Text(e['name']),
                    //               value: e,
                    //             ))
                    //         .toList(),
                    //     value: selectedVal,
                    //     dropdownColor: Colors.brown[800],
                    //     decoration:
                    //         decoration.copyWith(hintText: 'Select song genre'),
                    //     autovalidateMode: AutovalidateMode.onUserInteraction,
                    //     onChanged: (val) {
                    //       setState(() {
                    //         selectedVal = val;
                    //       });
                    //     },
                    //     validator: (val) {
                    //       return val == null ? 'Select a genre' : null;
                    //     }),
                    SizedBox(height: 20),
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _commentController,
                      decoration: decoration.copyWith(
                        labelText: 'Comment',
                        hintText: 'Add comment here',
                      ),
                      validator: (val) {
                        return val.isNotEmpty ? null : 'Enter comment';
                      },
                      style: TextStyle(
                        color: AppColor.white,
                      ),
                      minLines: 2,
                      maxLines: 5,
                      maxLength: 150,
                    ),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () async {
                          selectedImage = await pickFile('image');
                          setState(() {
                            showImage = selectedImage != null ? true : false;
                          });
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white)),
                        child: Text(
                          'Choose image',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    if (showImage)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          height: 150,
                          width: 150,
                          margin: EdgeInsets.only(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Image preview',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                height: 100,
                                width: 100,
                                child: Image(
                                  image: FileImage(selectedImage),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red)),
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          ),
                        ),
                        SizedBox(width: 70),
                        TextButton(
                          onPressed: () {
                            if (_formKey.currentState.validate() &&
                                selectedImage == null)
                              showToast(context,
                                  message: 'Please select an image',
                                  backgroundColor: Colors.white,
                                  textColor: Colors.black);
                            if (_formKey.currentState.validate() &&
                                selectedSong == null &&
                                !widget.isRecord)
                              showToast(context,
                                  message: 'Please select a song to upload',
                                  backgroundColor: Colors.white,
                                  textColor: Colors.black);
                            if (_formKey.currentState.validate() &&
                                selectedImage != null &&
                                widget.isRecord) {
                              uploadSong(
                                  image: selectedImage,
                                  song: File(widget.model.path));
                            }
                            if (_formKey.currentState.validate() &&
                                selectedImage != null &&
                                selectedSong != null &&
                                !widget.isRecord) {
                              uploadSong(
                                  image: selectedImage, song: selectedSong);
                            }
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.blue)),
                          child: Text(
                            'Upload',
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
