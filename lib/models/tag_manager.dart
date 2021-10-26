import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:louvor_app/models/user_app.dart';
import 'package:louvor_app/models/user_manager.dart';

import 'Tag.dart';

class TagManager extends ChangeNotifier{

  TagManager(){
   // _loadAllSongs();
  }

  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  UserApp? user;

  static List<Tag> allTags = [];

  static List<String> allTagsAsStrings(){
    List<String> tags = [];
    allTags.forEach((tag) {
                             if(tag.tag != null){
                               String x = tag.tag ?? '';
                               if(x != ''){
                                 tags.add(x);
                               }
                             }
                          }
                   );
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
                  (t) => t.tag!.toLowerCase().contains(search.toLowerCase())
          )
      );
    }

    return filteredTags;
  }

  Future<void> _loadAllTag() async {
    final QuerySnapshot snapSongs =
    await fireStore.collection('tags').where('isActive', isEqualTo: true)
                                      .get().then((QuerySnapshot querySnapshot) => querySnapshot);

    allTags = snapSongs.docs.map((d) => Tag.fromDocument(d)).toList();

    notifyListeners();
  }

  void update(Tag tag){
    allTags.removeWhere((s) => s.id == tag.id);
    allTags.add(tag);
    tag.save();
  notifyListeners();
}

  updateUser(UserManager userManager) {
    user = userManager.userApp;
    if(user != null){
      _loadAllTag();
    }
  }

}