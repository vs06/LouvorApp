import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:louvor_app/models/user.dart';
import 'package:louvor_app/models/user_manager.dart';

import 'package:louvor_app/models/Service.dart';

import 'Rehearsal.dart';

class RehearsalManager extends ChangeNotifier{

  RehearsalManager(){
   // _loadAllSongs();
  }

  final Firestore firestore = Firestore.instance;

  User user;

  List<Rehearsal> allRehearsals = [];

  String _search = '';

  String get search => _search;
  set search(String value){
    _search = value;
    notifyListeners();
  }

  List<Rehearsal> get filteredRehearsals {
    final List<Rehearsal> filteredRehearsals = [];

    if(search.isEmpty){
      filteredRehearsals.addAll(allRehearsals);
    } else {
      filteredRehearsals.addAll(
          allRehearsals.where((p) => p.data.toString().toLowerCase().contains(search.toLowerCase()))
      );
    }

    return filteredRehearsals;
  }

  void removeFromAllRehearsals(Rehearsal rehearsalRemoved){
    allRehearsals.removeWhere((rehearsal) => rehearsal.id == rehearsalRemoved.id);
  }


  List<Rehearsal> filteredRehearsalsByMounth(DateTime DateTime) {
    List<Rehearsal> filteredRehearsals = [];

    _loadAllRehearsalsbyDate(DateTime);
    filteredRehearsals.addAll(allRehearsals.where(
            (rehearsal) => ((rehearsal.data.year == DateTime.year) && (rehearsal.data.month == DateTime.month) )
    )
    );

    filteredRehearsals.sort((a, b) => a.data.compareTo(b.data));

    return sortFilteredRehearsals(filteredRehearsals);
  }

  ///De cima para baixo
  ///mais acima são os ensaios mais próximos
  ///descendo próximas datas
  ///ao fim ensaios que já ocorreram
  List<Rehearsal> sortFilteredRehearsals( List<Rehearsal> lstRehearsal){
    //qual á data atual?
    DateTime dateTime = DateTime.now();

    List<Rehearsal> beforeListRehearsal = lstRehearsal.where((rehearsal) => rehearsal.data.isBefore(dateTime)).toList();
    List<Rehearsal> afterListRehearsal = lstRehearsal.where((rehearsal) => rehearsal.data.isAfter(dateTime)).toList();
    afterListRehearsal.addAll(beforeListRehearsal);

    return afterListRehearsal;
  }

  Future<void> _loadAllRehearsal() async {
    final QuerySnapshot snapRehearsals =
    await firestore.collection('rehearsals').where('isActive', isEqualTo: true).getDocuments();

    allRehearsals = snapRehearsals.documents.map(
            (d) => Rehearsal.fromDocument(d)).toList();

    notifyListeners();
  }

  Future<void> _loadAllRehearsalsbyDate(DateTime dateTime) async {
    final lastdayofmounth = new DateTime(dateTime.year,dateTime.month+1,1);
    final firstdayofmount = new DateTime(dateTime.year,dateTime.month,1);
    QuerySnapshot snapRehearsals =
    await firestore.collection('rehearsals')
        .where('data', isGreaterThanOrEqualTo: firstdayofmount)
        .where('data', isLessThanOrEqualTo: lastdayofmounth)
        .where('isActive', isEqualTo: true).getDocuments();

    allRehearsals = snapRehearsals.documents.map(
            (d) => Rehearsal.fromDocument(d)).toList();
    notifyListeners();
  }

  Future<void> _loadAllRehearsals(UserManager userManager) async {
    final QuerySnapshot snapRehaersals =
    await firestore.collection('rehearsals').where('isActive', isEqualTo: true).getDocuments();

    allRehearsals = snapRehaersals.documents.map(
            (d) => Rehearsal.fromDocument(d)).toList();

    notifyListeners();
  }

  void update(Rehearsal rehearsal){
    allRehearsals.removeWhere((r) => r.id == rehearsal.id);
    allRehearsals.add(rehearsal);
    rehearsal.save();
    notifyListeners();
  }

  updateUser(UserManager userManager) {
    user = userManager.user;
    if(user != null){
      _loadAllRehearsals(userManager);
    }
  }

}