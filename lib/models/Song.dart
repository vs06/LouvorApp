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

  Song({this.id, this.nome, this.artista, this.tom, this.cifra, this.data, this.letra, this.uid, this.ativo}){}

  Song.fromDocument(DocumentSnapshot document){
    id = document.documentID;
    nome = document['titulo'] as String;
    artista = document['texto_base'] as String;
    tom = document['tema'] as String;
    livro = document['livro'] as String;
    data = document['data'] as String;
    cifra = document['texto'] as String;
    letra = document['tags'] as String;
    uid = document['uid'] as String;
    ativo = document['ativo'] as String;
  }

  Future<void> save() async {
    final Map<String, dynamic> blob = {
      'titulo': nome,
      'texto_base': artista,
      'tema': tom,
      'data': data,
      'texto': cifra,
      'tags': letra,
      'uid': uid,
      'ativo': ativo,
    };
    if (ativo == null)
      ativo = 'True';
    
    if(id == null){
      final doc = await firestore.collection('songs').add(blob);
      id = doc.documentID;
    } else {
      await firestoreRef.updateData(blob);
    }

    notifyListeners();
  }

  //Sermon();

  Song.fromTituloDescricao(String titulo, String descricao, String livro, String tema, String data) {
    this.nome = titulo;
    this.artista = descricao;
    this.tom = tema;
    this.livro = livro;
    this.cifra = cifra;
    this.data = data;
  }

  Song.fromJson(Map<String, dynamic> json)
      : nome = json['titulo'],
        artista = json['descricao'],
        tom = json['status'],
        livro = json['livro'],
        letra = json['tags'],
        cifra = json['texto'],
        data = json['data'],
        uid = json['uid'],
        ativo = json['ativo'];

  Map toJson() => {
    'titulo': nome,
    'descricao': artista,
    'status': tom,
    'livro': livro,
    'tags': letra,
    'texto': cifra,
    'data': data,
    'uid': uid,
    'ativo': ativo
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
        ativo: ativo
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