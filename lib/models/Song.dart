import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Song extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  DocumentReference get firestoreRef => firestore.doc('songs/$id');

  late String? id;
  late String? nome;
  late String? artista;
  late String? tom;
  late String? palmas;
  late String? data;
  late String? cifra;
  late String? tags;
  late String? letra;
  late String? uid;
  late String? ativo;
  late String? videoUrl;
  late String? bpm;

  Song(
      {this.id,
      this.nome,
      this.artista,
      this.tom,
      this.palmas,
      this.cifra,
      this.tags,
      this.data,
      this.letra,
      this.uid,
      this.ativo,
      this.videoUrl,
      this.bpm});

  Song.byMap(String id, Map<String, dynamic> json) {
    this.id = id;
    this.id = json['id'];
    this.nome = json['titulo'];
    this.artista = json['artista'];
    this.tom = json['tom'];
    this.palmas = json['palmas'];
    this.data = json['data'];
    this.cifra = json['cifra'];
    this.tags = json['tags'];
    this.letra = json['letra'];
    this.uid = json['uid'];
    this.ativo = json['ativo'];
    this.videoUrl = json['videoUrl'];
    this.bpm = json['bpm'];
  }

  Song.fromDocument(DocumentSnapshot document) {
    id = document.id;
    nome = document['titulo'] ?? '';
    artista = document['artista'] ?? '';
    tom = document['tom'] ?? '';
    palmas = document['palmas'] ?? '';
    data = document['data'] ?? '';
    cifra = document['cifra'] ?? '';
    tags = document['tags'] ?? '';
    letra = document['letra'] ?? '';
    uid = document['uid'] ?? '';
    ativo = document['ativo'] ?? '';
    videoUrl = document['videoUrl'] ?? '';
    bpm = document.data().toString().contains('bpm') ? document['bpm'] : '-1';
  }

  Future<void> save() async {
    final Map<String, dynamic> blob = {
      'titulo': nome,
      'artista': artista,
      'tom': tom,
      'palmas': palmas,
      'data': data,
      'cifra': cifra,
      'tags': tags,
      'letra': letra,
      'uid': uid,
      'ativo': ativo,
      'videoUrl': videoUrl,
      'bpm': bpm,
    };
    if (ativo == null) ativo = 'TRUE';

    if (id == null) {
      final doc = await firestore.collection('songs').add(blob);
      id = doc.id;
    } else {
      await firestoreRef.update(blob);
    }

    notifyListeners();
  }

  Song.fromJson(Map<String, dynamic> json)
      : nome = json['titulo'],
        artista = json['artista'],
        tom = json['tom'],
        palmas = json['palmas'],
        letra = json['letra'],
        tags = json['tags'],
        cifra = json['cifra'],
        data = json['data'],
        uid = json['uid'],
        ativo = json['ativo'],
        videoUrl = json['videoUrl'],
        bpm = json['bpm'];

  Map toJson() => {
        'titulo': nome,
        'artista': artista,
        'tom': tom,
        'palmas': palmas,
        'letra': letra,
        'tags': tags,
        'cifra': cifra,
        'data': data,
        'uid': uid,
        'ativo': ativo,
        'videoUrl': videoUrl,
        'bpm': bpm
      };

  Map<String, dynamic> toMap() => {
        id!: {
          'titulo': nome,
          'artista': artista,
          'tom': tom,
          'palmas': palmas,
          'letra': letra,
          'tags': tags,
          'cifra': cifra,
          'data': data,
          'uid': uid,
          'ativo': ativo,
          'videoUrl': videoUrl,
          'bpm': bpm
        }
      };

  Song clone() {
    return Song(
        id: id,
        nome: nome,
        artista: artista,
        tom: tom,
        palmas: palmas,
        cifra: cifra,
        data: data,
        letra: letra,
        tags: tags,
        uid: uid,
        ativo: ativo,
        videoUrl: videoUrl,
        bpm: bpm);
  }

  void delete(Song s) {
    s.ativo = 'False';
    s.save();
    notifyListeners();
  }
}
