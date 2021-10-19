import 'package:cloud_firestore/cloud_firestore.dart';

class UserApp {

  String? id;
  String? name;
  String? email;
  String? password;
  String? isAdmin;
  String? ativo;
  String? confirmPassword;


  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  DocumentReference get firestoreRef => firestore.doc('users/$id');

  UserApp({ this.isAdmin,
            this.email,
            this.password,
            this.name,
            this.id,
            this.ativo
          });

  UserApp.fromDocument(DocumentSnapshot document){
    id = document.id;
    name = document.data()!['name'] as String;
    email = document.data()!['email'] as String;
    isAdmin = document.data()!['isAdmin'] as String;
    ativo = document.data()!['ativo'] as String;
  }

  Future<void> userInactivated() async {
    this.isAdmin = 'FALSE';
    this.ativo = 'FALSE';
    await firestoreRef.set(toMap());
  }

  Future<void> saveData() async {
    await firestoreRef.set(toMap());
  }

  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'email': email,
      'ativo': ativo,
      'isAdmin': isAdmin,
    };
  }
}