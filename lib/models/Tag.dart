import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Tag extends ChangeNotifier {

  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  DocumentReference get fireStoreReference => fireStore.doc('tags/$id');

  String? id;
  String? tag;
  bool? isActive;

  Tag({this.id, this.tag, this.isActive});

  Tag.newTag(String tag){
    this.tag = tag;
    this.isActive = true;
  }

  Tag.byMap(String id, Map<String, dynamic> json){
    this.id = id;
    this.tag = json['tag'];
    this.isActive = json['isActive'];

  }

  Tag.fromDocument(DocumentSnapshot document){
    id = document.id;
    tag = document['tag'] as String;
    isActive = document['isActive'] as bool;
  }

  Future<void> save() async {
    final Map<String, dynamic> blob = {
      'tag': tag,
      'isActive': isActive,

    };

    if(id == null){
      final doc = await fireStore.collection('tags').add(blob);
      id = doc.id;
    } else {
      await fireStoreReference.update(blob);
    }

    notifyListeners();
  }

  Tag.fromJson(Map<String, dynamic> json)
      : tag = json['tag'],
        isActive = json['isActive'];

  Map toJson() => {
    'tag': tag,
    'isActive': isActive
  };

  Map<String,dynamic> toMap() => {
    id!: {
      'tag': tag,
      'ativo': isActive
    }
  };

  void delete(Tag t){
    t.isActive = false;
    t.save();
    notifyListeners();
  }

}