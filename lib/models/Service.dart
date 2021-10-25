import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:louvor_app/models/Song.dart';

class Service extends ChangeNotifier {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  DocumentReference get firestoreRef => firestore.doc('services/$id');

  late String? id;
  late String? ativo;
  late DateTime? data;
  late String? dirigente;
  late List<Song>? lstSongs = [];
  late Map<String, dynamic>? dynamicSongs = new Map();

  Map<String, List<String>>? team = new Map();

  Service({this.id,this.dirigente, this.data, this.ativo,this.lstSongs, this.team});

  Service.fromDocument(DocumentSnapshot document){
    id = document.id;
    dirigente = document['dirigente'] ?? '';
    data = (document['data'] as Timestamp).toDate();
    ativo = document['ativo'] as String;

    Map.from(document.data()?['lstSongs']).
        forEach((key, value) { if (lstSongs == null)
                                      lstSongs = [];

                                Song s = Song.byMap(key, value);
                                s.id = key;
                                lstSongs?.add(s);
                              });

    if(document['team'] != null) {
      Map.from(document['team']).
      forEach((key, value) {
        //team.putIfAbsent(key, () => value);
        generateTeam(key, value);
      });
    }

  }

  Map<String, List<String>>? generateTeam(String role, List<dynamic> volunteers){

    List<String> teste = [];
    volunteers.forEach((volunteer) => teste.add(volunteer.toString()));

    team?.putIfAbsent(role, () => teste);
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
          this.lstSongs = [];
        }

        this.lstSongs?.forEach((element) => this.dynamicSongs?.addAll(element.toMap()));

        final doc = await firestore.collection('services').add(this.toMap());
        id = doc.id;

        print('SALVANDO $blob $data $dirigente');
    } else {
        print('ATUALIZANDO $blob $data $dirigente');

        this.lstSongs?.forEach((element) => this.dynamicSongs?.addAll(element.toMap()));
        await firestoreRef.update(this.toMap());
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

  static Service specialClone(Service? serviceOrigin) {
    Service serviceClone = new Service();

    serviceClone.lstSongs = [];
    serviceClone.lstSongs?.addAll(serviceOrigin!.lstSongs!.toList());

    serviceClone.team = new Map();
    
    if(serviceOrigin!.team != null){
     serviceOrigin!.team?.forEach((role, volunteers) {

       List<String> listNewReference = [];
       volunteers.forEach((volunteer) {
         listNewReference.add(volunteer)  ;
       });

       serviceClone.team?.putIfAbsent(role, ()=> listNewReference);
     });
    }

    // if(widget.service.team.containsKey(valueRoleDropDownSelected)){
    //   if(!widget.service.team[valueRoleDropDownSelected].contains(valueUserDropDownSelected)){
    //     setState(() {
    //       widget.service.team[valueRoleDropDownSelected].add(valueUserDropDownSelected);
    //     });
    //   }else{
    //     setState(() {
    //       widget.service.team.putIfAbsent(valueRoleDropDownSelected, () => [valueUserDropDownSelected]);
    //     });
    //   }
    // } else {
    //   setState(() {
    //     widget.service.team.putIfAbsent(valueRoleDropDownSelected, () => [valueUserDropDownSelected]);
    //   });
    // }

    serviceClone.ativo = serviceOrigin.ativo;
    serviceClone.dirigente = serviceOrigin.dirigente;
    serviceClone.data = serviceOrigin.data;
    return serviceClone;
  }

  void delete(Service s) {
    s.ativo = 'False';
    s.save();
    notifyListeners();
  }
}
