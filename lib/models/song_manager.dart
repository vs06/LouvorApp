import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:louvor_app/models/user.dart';
import 'package:louvor_app/models/user_manager.dart';

import 'Song.dart';

class SongManager extends ChangeNotifier{

  SongManager(){
   // _loadAllSongs();
  }

  final Firestore firestore = Firestore.instance;

  User user;

  List<Song> allSongs = [];

  String _search = '';

  String get search => _search;
  set search(String value){
    _search = value;
    notifyListeners();
  }

  List<Song> get filteredSongs {
    final List<Song> filteredSongs = [];

    if(search.isEmpty){
      filteredSongs.addAll(allSongs);
    } else {
      filteredSongs.addAll(
          allSongs.where(
                  (p) => p.nome.toLowerCase().contains(search.toLowerCase())
          )
      );
    }

    return filteredSongs;
  }

  Future<void> _loadAllSongs() async {
    final QuerySnapshot snapSongs =
    await firestore.collection('songs').getDocuments();

    allSongs = snapSongs.documents.map(
            (d) => Song.fromDocument(d)).toList();

    notifyListeners();
  }

  Future<void> _loadAllSong(UserManager userManager) async {
    final QuerySnapshot snapSongs =
    await firestore.collection('songs').where('ativo', isEqualTo: 'TRUE').getDocuments();

    allSongs = snapSongs.documents.map(
            (d) => Song.fromDocument(d)).toList();

    notifyListeners();
  }

  void update(Song song){
    allSongs.removeWhere((s) => s.id == song.id);
    song.uid = user.id;
    allSongs.add(song);
    song.save();
  notifyListeners();
}

  updateUser(UserManager userManager) {
    user = userManager.user;

    if(user != null){
      _loadAllSong(userManager);
    }
  }

}