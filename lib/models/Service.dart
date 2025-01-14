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

  Map<String, List<String>> team = new Map();

  Service({this.id, this.dirigente, this.data, this.ativo, this.lstSongs, this.team});

  Service.fromDocument(DocumentSnapshot document){
    id = document.documentID;
    dirigente = document['dirigente'] as String;
    data = (document['data'] as Timestamp).toDate();
    ativo = document['ativo'] as String;

    Map.from(document.data['lstSongs']).
        forEach((key, value) { if (lstSongs == null)
                                      lstSongs = [];

                                Song s = Song.byMap(key, value);
                                s.id = key;
                                lstSongs.add(s);
                              });

    if(document['team'] != null) {
      Map.from(document['team']).
      forEach((key, value) {
        //team.putIfAbsent(key, () => value);
        generateTeam(key, value);
      });
    }

  }

  Map<String, List<String>> generateTeam(String role, List<dynamic> volunteers){

    List<String> teste = [];
    volunteers.forEach((volunteer) => teste.add(volunteer.toString()));

    team.putIfAbsent(role, () => teste);
  }

  Service.fromMap(Map<dynamic, dynamic> map)
      : dirigente = map['dirigente'],
        ativo = map['ativo'],
        data = map['data'],
        lstSongs = map['lstSongs'].map( (set) {
                                                return Set.from(set);
                                              }).toList();

  Map<String, dynamic> toMap() =>
      {
        "dirigente": this.dirigente,
        "ativo": this.ativo,
        "data": this.data,
        "lstSongs": this.dynamicSongs,
        "team": this.team,
      };

  Future<void> save() async {

    final Map<String, dynamic> blob = {
      'data': data,
      'dirigente': dirigente,
      'ativo': ativo,
      'lstSongs': lstSongs,
      'team': team
    };

    if (ativo == null){
      ativo = 'True';
    }


    if (id == null) {

        if (this.dynamicSongs == null){
          this.dynamicSongs = new Map();
        }

        if(this.lstSongs == null){
          this.lstSongs = new List();
        }

        this.lstSongs.forEach((element) => this.dynamicSongs.addAll(element.toMap()));

        final doc = await firestore.collection('services').add(this.toMap());
        id = doc.documentID;

        print('SALVANDO $blob $data $dirigente');
    } else {
        print('ATUALIZANDO $blob $data $dirigente');

        this.lstSongs.forEach((element) => this.dynamicSongs.addAll(element.toMap()));
        await firestoreRef.updateData(this.toMap());
    }

    notifyListeners();
  }

  Service clone() {
    print('CLONEI');
    return Service(
      id: id,
      dirigente: dirigente,
      data: data,
      ativo: ativo,
      lstSongs: lstSongs,
      team: team
    );
  }

  void delete(Service s) {
    s.ativo = 'False';
    s.save();
    notifyListeners();
  }
}
