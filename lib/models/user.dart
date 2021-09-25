import 'package:cloud_firestore/cloud_firestore.dart';

class User {

  final Firestore firestore = Firestore.instance;

  DocumentReference get firestoreRef => firestore.document('users/$id');

  User({this.isAdmin, this.email, this.password, this.name, this.id, this.ativo});

  User.fromDocument(DocumentSnapshot document){
    id = document.documentID;
    name = document.data['name'] as String;
    email = document.data['email'] as String;
    isAdmin = document.data['isAdmin'] as String;
    ativo = document.data['ativo'] as String;
  }

  String id;
  String name;
  String email;
  String password;
  String isAdmin;
  String ativo;

  String confirmPassword;

  Future<void> userInactivated() async {
    this.isAdmin = 'False';
    this.ativo = 'False';
    await firestoreRef.setData(toMap());
  }

  Future<void> saveData() async {
    await firestoreRef.setData(toMap());
  }

  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'email': email,
      'ativo': ativo,
    };
  }
}