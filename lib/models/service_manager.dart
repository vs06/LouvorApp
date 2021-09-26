import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:louvor_app/models/user.dart';
import 'package:louvor_app/models/user_manager.dart';

import 'package:louvor_app/models/Service.dart';

class ServiceManager extends ChangeNotifier{

  ServiceManager(){
   // _loadAllSongs();
  }

  final Firestore firestore = Firestore.instance;

  User user;

  List<Service> allServices = [];

  String _search = '';

  String get search => _search;
  set search(String value){
    _search = value;
    notifyListeners();
  }

  List<Service> get filteredServices {
    final List<Service> filteredServices = [];

    if(search.isEmpty){
      filteredServices.addAll(allServices);
    } else {
      filteredServices.addAll(
          allServices.where(
                  (p) => p.data.toString().toLowerCase().contains(search.toLowerCase())
          )
      );
    }

    return filteredServices;
  }

  List<Service> filteredServicesByMounth(DateTime DateTime) {
    final List<Service> filteredServices = [];

    filteredServices.addAll(allServices.where(
                                              (service) => ((service.data.year == DateTime.year) && (service.data.month == DateTime.month) )
                                              )
                            );

    filteredServices.sort((a, b) => b.data.compareTo(a.data));

    return filteredServices;
  }

  Future<void> _loadAllServices() async {
    final QuerySnapshot snapServices =
    await firestore.collection('services').getDocuments();

    allServices = snapServices.documents.map(
            (d) => Service.fromDocument(d)).toList();

    notifyListeners();
  }

  Future<void> _loadAllService(UserManager userManager) async {
    final QuerySnapshot snapServices =
    await firestore.collection('services').where('ativo', isEqualTo: 'True').getDocuments();

    allServices = snapServices.documents.map(
            (d) => Service.fromDocument(d)).toList();

    notifyListeners();
  }

  void update(Service service){
    allServices.removeWhere((s) => s.id == service.id);
    allServices.add(service);
    service.save();
    notifyListeners();
  }

  updateUser(UserManager userManager) {
    user = userManager.user;
    if(user != null){
      _loadAllService(userManager);
    }
  }

}