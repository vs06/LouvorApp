
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'Song.dart';

class Rehearsal extends ChangeNotifier {

  final Firestore fireStore = Firestore.instance;

  DocumentReference get fireStoreReference => fireStore.document('rehearsals/$id');

  String id;
  bool isActive;
  DateTime data;
  String type;
  List<Song> lstSongs = [];
  Map<String, dynamic> dynamicSongs = new Map();

  Rehearsal({this.id, this.type, this.data, this.isActive, this.lstSongs});

  Rehearsal.fromDocument(DocumentSnapshot document){
    id = document.documentID;
    type = document['type'] as String;
    data = (document['data'] as Timestamp).toDate();
    isActive = document['ativo'] as bool;

    Map.from(document.data['lstSongs']).
    forEach((key, value) { if (lstSongs == null)
      lstSongs = [];

    Song s = Song.byMap(key, value);
    s.id = key;
    lstSongs.add(s);
    });

  }

  Rehearsal.fromMap(Map<dynamic, dynamic> map)
      : type = map['type'],
        isActive = map['isActive'],
        data = map['data'],
        lstSongs = map['lstSongs'].map( (set) {
          return Set.from(set);
        }).toList();

  Map<String, dynamic> toMap() =>
      {
        "type": this.type,
        "isActive": this.isActive,
        "data": this.data,
        "lstSongs": this.dynamicSongs,
      };

  Future<void> save() async {

    final Map<String, dynamic> blob = {
      'data': data,
      'type': type,
      'isActive': isActive,
      'lstSongs': lstSongs
    };

    if (id == null) {

      if (this.dynamicSongs == null){
        this.dynamicSongs = new Map();
      }

      if(this.lstSongs == null){
        this.lstSongs = new List();
      }

      this.lstSongs.forEach((element) => this.dynamicSongs.addAll(element.toMap()));

      final doc = await fireStore.collection('services').add(this.toMap());
      id = doc.documentID;

    } else {

      this.lstSongs.forEach((element) => this.dynamicSongs.addAll(element.toMap()));
      await fireStoreReference.updateData(this.toMap());
    }

    notifyListeners();
  }

  Rehearsal clone() {
    return Rehearsal(
        id: id,
        type: type,
        data: data,
        isActive: isActive,
        lstSongs: lstSongs
    );
  }

  void delete(Rehearsal rehearsal) {
    rehearsal.isActive = false;
    rehearsal.save();
    notifyListeners();
  }

}

