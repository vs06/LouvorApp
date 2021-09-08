import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Service extends ChangeNotifier {

  final Firestore firestore = Firestore.instance;

  DocumentReference get firestoreRef => firestore.document('services/$id');

  String id;
  String ativo;
  String data;
  String dirigente;

  Service({this.id, this.dirigente, this.data, this.ativo}){}

  Service.fromDocument(DocumentSnapshot document){
    id = document.documentID;
    data = document['data'] as String;
    dirigente = document['dirigente'] as String;
    ativo = document['ativo'] as String;
  }

  Future<void> save() async {
    final Map<String, dynamic> blob = {
      'data': data,
      'dirigente': dirigente,
      'ativo' : ativo,
    };
    if (ativo == null)
      ativo = 'True';

    if(id == null){
      final doc = await firestore.collection('services').add(blob);
      id = doc.documentID;
    } else {
      await firestoreRef.updateData(blob);
    }

    notifyListeners();
  }

  //Sermon();

  Service.fromData(String data) {
    this.data = data;
  }

  Service.fromJson(Map<String, dynamic> json)
      : dirigente = json['dirigente'],
        data = json['data'],
        ativo = json['ativo'];

  Map toJson() => {
    'dirigente': dirigente,
    'data': data,
    'ativo': ativo
  };

  Service clone(){
    return Service(
        id: id,
        dirigente: dirigente,
        data: data,
        ativo: ativo
    );
  }

  void delete(Service s){
    s.ativo = 'False';
    s.save();
    notifyListeners();
  }
}
