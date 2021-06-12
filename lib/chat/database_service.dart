import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  DatabaseReference _messages =
      FirebaseDatabase.instance.reference().child('messages');

  Future<void> sendMessage(
      {@required String message,
      @required String type,
      @required String id,
      @required String peerId,
      @required DatabaseReference path,
      String filePath = '',
      String fileName = '',
      @required String userName,
      @required String peerName,
      @required bool saveName}) async {
    await path.set({
      'message': message,
      'time': ServerValue.timestamp,
      'id': id,
      'type': type,
      'filePath': filePath,
      'name': fileName,
      'read': false,
      'key': path.key,
    });

    await _messages.child(peerId).child(id).child(path.key).set({
      'message': message,
      'time': ServerValue.timestamp,
      'id': id,
      'type': type,
      'filePath': filePath,
      'name': fileName,
      'read': false,
      'key': path.key,
    });

    await _messages.child(id).child(peerId).update({
      'time': ServerValue.timestamp,
      'lastMessage': type == 'text'
          ? message
          : type == 'image'
              ? 'Image file'
              : 'Audio file'
    });
    await _messages.child(peerId).child(id).update({
      'time': ServerValue.timestamp,
      'lastMessage': type == 'text'
          ? message
          : type == 'image'
              ? 'Image file'
              : 'Audio file'
    });
    if (saveName) setUserName(peerName, id, peerId, userName);
  }

  Future<void> setUserName(
      String peerName, String id, String peerId, String userName) async {
    await _messages.child(id).child(peerId).update({'name': peerName});
    await _messages.child(peerId).child(id).update({'name': userName});
  }

  Future<void> updateMessage(
      {@required String message,
      @required String id,
      @required String key,
      @required String peerId}) async {
    await _messages.child(id).child(peerId).child(key).update({
      'message': message,
      'time': ServerValue.timestamp,
    });

    await _messages.child(peerId).child(id).child(key).update({
      'message': message,
      'time': ServerValue.timestamp,
    });
  }

  Stream<Event> chatStream(String id, String peerId) {
    return _messages.child(id).child(peerId).onValue;
  }

  Stream<Event> allStream(String id) {
    return _messages.child(id).onValue;
  }

  Future<void> updateRead(
      {@required String key,
      @required String id,
      @required String peerId}) async {
    await _messages.child(id).child(peerId).child(key).update({'read': true});
    await _messages.child(peerId).child(id).child(key).update({'read': true});
  }
}
