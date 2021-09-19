import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:louvor_app/models/Song.dart';

class Service extends ChangeNotifier {

  final Firestore firestore = Firestore.instance;

  DocumentReference get firestoreRef => firestore.document('services/$id');

  String id;
  String ativo;
  String data;
  String dirigente;
  List<String> songs;
  List<Song> lstSongs = new List<Song>();

  Service({this.id, this.dirigente, this.data, this.ativo, this.songs}){}

  Service.fromDocument(DocumentSnapshot document){
    id = document.documentID;
    data = document['data'] as String;
    dirigente = document['dirigente'] as String;
    ativo = document['ativo'] as String;
    songs = List.from(document.data['songs']);
  }

  Future<void> save() async {
    final Map<String, dynamic> blob = {
      'data': data,
      'dirigente': dirigente,
      'ativo' : ativo,
      'songs': songs,
    };
    if (ativo == null)
      ativo = 'True';

    if(id == null){
      final doc = await firestore.collection('services').add(blob);
      id = doc.documentID;
      print('SALVANDO $blob $data $dirigente $songs');
    } else {
      print('ATUALIZANDO $blob $data $dirigente $songs');
      await firestoreRef.updateData(blob);
    }

    notifyListeners();
  }

  //Sermon();

  Service.fromData(String data) {
    this.data = data;
  }

  Service.fromJson(Map<String, dynamic> json) {
  dirigente = json['dirigente'];
  ativo = json['ativo'];
  data = json['data'];
  songs = json['songs'].cast<String>();
}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dirigente'] = this.dirigente;
    data['ativo'] = this.ativo;
    data['data'] = this.data;
    data['songs'] = this.songs;
    return data;
  }

  Service clone(){
    print('CLONEI');
    return Service(
        id: id,
        dirigente: dirigente,
        data: data,
        ativo: ativo,
        songs: songs
    );
  }

  void delete(Service s){
    s.ativo = 'False';
    s.save();
    notifyListeners();
  }
}
