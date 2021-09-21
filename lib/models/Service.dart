import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:louvor_app/models/Song.dart';

class Service extends ChangeNotifier {

  final Firestore firestore = Firestore.instance;

  DocumentReference get firestoreRef => firestore.document('services/$id');

  String id;
  String ativo;
  DateTime data;
  String dirigente;
  List<Song> lstSongs = [];
  Map<String, dynamic> dynamicSongs = new Map();

  Service(
      {this.id, this.dirigente, this.data, this.ativo, this.lstSongs});

  Service.fromDocument(DocumentSnapshot document){
    id = document.documentID;
    dirigente = document['dirigente'] as String;
    data = (document['data'] as Timestamp).toDate();
    ativo = document['ativo'] as String;

    Map.from(document.data['lstSongs']).forEach((key, value) {
      if (lstSongs == null)
        lstSongs = [];
      Song s = Song.byMap(key, value);
      s.id = key;
      lstSongs.add(s);
    });

    lstSongs.forEach((element) {
      print(element.id);
    });
  }

  Future<void> save() async {
    final Map<String, dynamic> blob = {
      'data': data,
      'dirigente': dirigente,
      'ativo': ativo,
      'lstSongs': lstSongs,
    };
    if (ativo == null)
      ativo = 'True';

    if (id == null) {
      if (this.dynamicSongs == null)
        this.dynamicSongs = new Map();

      this.lstSongs.forEach((element) =>
          this.dynamicSongs.addAll(element.toMap()));

      final doc = await firestore.collection('services').document().setData(
          this.toMap());
      id = firestore
          .collection('services')
          .document()
          .documentID;
      print('SALVANDO $blob $data $dirigente');
    } else {
      print('ATUALIZANDO $blob $data $dirigente');

      this.lstSongs.forEach((element) =>
          this.dynamicSongs.addAll(element.toMap()));
      await firestoreRef.updateData(this.toMap());
    }

    notifyListeners();
  }

  // Service.fromData(String data) {
  //   this.data = data;
  // }

  Service.fromMap(Map<dynamic, dynamic> map)
      : dirigente = map['dirigente'],
        ativo = map['ativo'],
        data = map['data'],
        lstSongs = map['lstSongs'].map(
                (set) {
              return Set.from(set);
            }
        ).toList();

  Map<String, dynamic> toMap() =>
      {
        "dirigente": this.dirigente,
        "ativo": this.ativo,
        "data": this.data,
        "lstSongs": this.dynamicSongs,
      };

  Service clone() {
    print('CLONEI');
    return Service(
      id: id,
      dirigente: dirigente,
      data: data,
      ativo: ativo,
      lstSongs: lstSongs,
    );
  }

  void delete(Service s) {
    s.ativo = 'False';
    s.save();
    notifyListeners();
  }
}
