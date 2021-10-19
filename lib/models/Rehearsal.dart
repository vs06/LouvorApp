
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:louvor_app/models/Service.dart';

import 'Song.dart';

class Rehearsal extends Service {

  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  DocumentReference get fireStoreReference => fireStore.doc('rehearsals/$id');

  String? id;
  bool? isActive;
  DateTime? data;
  String? type;
  List<Song>? lstSongs = [];
  Map<String, dynamic>? dynamicSongs = new Map();

  Rehearsal({this.id, this.type, this.data, this.isActive, this.lstSongs});

  Rehearsal.fromDocument(DocumentSnapshot document){
    id = document.id;
    type = document['type'] as String;
    data = (document['data'] as Timestamp).toDate();
    isActive = document['isActive'] as bool;

    Map.from(document.data()?['lstSongs']).
    forEach((key, value) { if (lstSongs == null)
      lstSongs = [];

    Song s = Song.byMap(key, value);
    s.id = key;
    lstSongs?.add(s);
    });

  }

  Rehearsal.fromMap(Map<dynamic, dynamic> map)
      : type = map['type'],
        isActive = map['isActive'],
        data = map['data'],
        lstSongs = map['lstSongs'].map( (set) {
          return Set.from(set);
        }).toList();

  Map<String, dynamic> toMap() =>
      {
        "type": this.type,
        "isActive": this.isActive,
        "data": this.data,
        "lstSongs": this.dynamicSongs,
      };

  Future<void> save() async {

    final Map<String, dynamic> blob = {
      'data': data,
      'type': type,
      'isActive': isActive,
      'lstSongs': lstSongs
    };

    if (id == null) {

      if (this.dynamicSongs == null){
        this.dynamicSongs = new Map();
      }

      if(this.lstSongs == null){
        this.lstSongs = [];
      }

      this.lstSongs?.forEach((element) => this.dynamicSongs?.addAll(element.toMap()));

      final doc = await fireStore.collection('rehearsals').add(this.toMap());
      id = doc.id;

    } else {

      this.lstSongs?.forEach((element) => this.dynamicSongs?.addAll(element.toMap()));
      await fireStoreReference.update(this.toMap());
    }

    notifyListeners();
  }

  Rehearsal clone() {
    return Rehearsal(
        id: id,
        type: type,
        data: data,
        isActive: isActive,
        lstSongs: lstSongs
    );
  }

  static Rehearsal serviceCastToRehearsal(Service service, String rehearsalType){
    return Rehearsal(
        id: service.id,
        type: rehearsalType,
        data: service.data,
        isActive: true,
        lstSongs: service.lstSongs
    );
  }

}

