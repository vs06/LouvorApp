import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:louvor_app/models/song_manager.dart';
import 'package:louvor_app/models/user.dart';
import 'package:louvor_app/models/user_manager.dart';

import 'Song.dart';
import 'Tag.dart';

class TagManager extends ChangeNotifier{

  TagManager(){
   // _loadAllSongs();
  }

  final Firestore fireStore = Firestore.instance;

  User user;

  static List<Tag> allTags = [];

  static List<String> allTagsAsStrings(){
    List<String> tags = [];
    allTags.forEach((tag) => tags.add(tag.tag));
    return tags;
  }

  String _search = '';

  String get search => _search;
  set search(String value){
    _search = value;
    notifyListeners();
  }

  List<Tag> get filteredTags {
    final List<Tag> filteredTags = [];

    if(search.isEmpty){
      filteredTags.addAll(allTags);
    } else {
      filteredTags.addAll(
          allTags.where(
                  (t) => t.tag.toLowerCase().contains(search.toLowerCase())
          )
      );
    }

    return filteredTags;
  }

  Future<void> _loadAllTag() async {
    final QuerySnapshot snapSongs =
    await fireStore.collection('tags').where('isActive', isEqualTo: true).getDocuments();

    allTags = snapSongs.documents.map((d) => Tag.fromDocument(d)).toList();

    notifyListeners();
  }

  void update(Tag tag){
    allTags.removeWhere((s) => s.id == tag.id);
    allTags.add(tag);
    tag.save();
  notifyListeners();
}

  updateUser(UserManager userManager) {
    user = userManager.user;
    if(user != null){
      _loadAllTag();
    }
  }

}