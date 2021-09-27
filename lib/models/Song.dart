import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Song extends ChangeNotifier {

  final Firestore firestore = Firestore.instance;

  DocumentReference get firestoreRef => firestore.document('songs/$id');

  String id;
  String nome;
  String artista;
  String tom;
  String livro;
  String data;
  String cifra;
  String letra;
  String uid;
  String ativo;
  String videoUrl;

  Song({this.id, this.nome, this.artista, this.tom, this.cifra, this.data, this.letra, this.uid, this.ativo, this.videoUrl});

  Song.byMap(String id, Map<String, dynamic> json){
    this.id = id;
    this.artista = json['artista'];
    this.ativo = json['ativo'];
    this.cifra = json['cifra'];
    this.data = json['data'];
    this.id = json['id'];
    this.letra = json['letra'];
    this.nome = json['titulo'];
    this.tom = json['tom'];
    this.uid = json['uid'];
    this.videoUrl = json['videoUrl'];
  }

  Song.fromDocument(DocumentSnapshot document){
    id = document.documentID;
    nome = document['titulo'] as String;
    artista = document['artista'] as String;
    tom = document['tom'] as String;
    livro = document['livro'] as String;
    data = document['data'] as String;
    cifra = document['cifra'] as String;
    letra = document['tags'] as String;
    uid = document['uid'] as String;
    ativo = document['ativo'] as String;
    videoUrl = document['videoUrl'] as String;

  }

  Future<void> save() async {
    final Map<String, dynamic> blob = {
      'titulo': nome,
      'artista': artista,
      'tom': tom,
      'data': data,
      'cifra': cifra,
      'tags': letra,
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

  Song.fromTituloDescricao(String titulo, String descricao, String livro, String tom, String data) {
    this.nome = titulo;
    this.artista = descricao;
    this.tom = tom;
    this.livro = livro;
    this.cifra = cifra;
    this.data = data;
  }

  Song.fromJson(Map<String, dynamic> json)
      : nome = json['titulo'],
        artista = json['artista'],
        tom = json['tom'],
        letra = json['tags'],
        cifra = json['cifra'],
        data = json['data'],
        uid = json['uid'],
        ativo = json['ativo'],
        videoUrl = json['videoUrl'];

  Map toJson() => {
    'titulo': nome,
    'artista': artista,
    'tom': tom,
    'tags': letra,
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
      'tags': letra,
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
        cifra: cifra,
        data: data,
        letra: letra,
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
class Book{
  String nome;
  String abreviatura;
  String testamento;

  Book();

  Book.fromNameTestament(String nome, String abreviatura, String testamento){
    this.nome = nome;
    this.abreviatura = abreviatura;
    this.testamento = testamento;
  }
}