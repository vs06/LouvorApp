import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Song extends ChangeNotifier {

  final Firestore firestore = Firestore.instance;

  DocumentReference get firestoreRef => firestore.document('songs/$id');

  String id;
  String nome;
  String artista;
  String tom;
  String palmas;
  String data;
  String cifra;
  String tags;
  String letra;
  String uid;
  String ativo;
  String videoUrl;

  Song({this.id, this.nome, this.artista, this.tom, this.palmas, this.cifra, this.tags, this.data, this.letra, this.uid, this.ativo, this.videoUrl});

  Song.byMap(String id, Map<String, dynamic> json){
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
  }

  Song.fromDocument(DocumentSnapshot document){
    id = document.documentID;
    nome = document['titulo'] as String;
    artista = document['artista'] as String;
    tom = document['tom'] as String;
    palmas = document['palmas'] as String;
    data = document['data'] as String;
    cifra = document['cifra'] as String;
    tags = document['tags'] as String;
    letra = document['letra'] as String;
    uid = document['uid'] as String;
    ativo = document['ativo'] as String;
    videoUrl = document['videoUrl'] as String;

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
    };
    if (ativo == null)
      ativo = 'TRUE';
    
    if(id == null){
      final doc = await firestore.collection('songs').add(blob);
      id = doc.documentID;
    } else {
      await firestoreRef.updateData(blob);
    }

    notifyListeners();
  }

  // Song.fromTituloDescricao(String titulo, String descricao, String livro, String tom, String data) {
  //   this.nome = titulo;
  //   this.artista = descricao;
  //   this.tom = tom;
  //   this.livro = livro;
  //   this.cifra = cifra;
  //   this.data = data;
  // }

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
        videoUrl = json['videoUrl'];

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
    'videoUrl' : videoUrl
  };

  Map<String,dynamic> toMap() => {
    id: {
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
      'videoUrl' : videoUrl
    }
  };

  Song clone(){
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
        videoUrl: videoUrl
    );
  }

  void delete(Song s){
    s.ativo = 'False';
    s.save();
    notifyListeners();
  }
}