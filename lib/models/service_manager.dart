import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:louvor_app/models/user_app.dart';
import 'package:louvor_app/models/user_manager.dart';

import 'package:louvor_app/models/Service.dart';

class ServiceManager extends ChangeNotifier{

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  UserApp? user;

  List<Service>? allServices = [];

  String _search = '';

  ServiceManager(){
    // _loadAllSongs();
  }

  String get search => _search;

  set search(String value){
    _search = value;
    notifyListeners();
  }

  List<Service> get filteredServices {
    final List<Service> filteredServices = [];

    if(search.isEmpty){
      filteredServices.addAll(allServices ?? []);
    } else {
      filteredServices.addAll(
          allServices!.where(
                  (p) => p.data.toString().toLowerCase().contains(search.toLowerCase())
          )
      );
    }

    return filteredServices;
  }

  void removeFromAllServices(Service serviceRemoved){
    allServices!.removeWhere((service) => service.id == serviceRemoved.id);
  }

  List<Service> filteredServicesByMonth(DateTime? dateTime) {
    List<Service> filteredServices = [];

    _loadAllServicesByDate(dateTime!);
    //filteredServices.addAll(allServices);
    filteredServices.addAll(allServices!.where(
                                              (service) => ((service.data?.year == dateTime.year) && (service.data?.month == dateTime.month) )
                                              )
                            );

    //TODO ARRUMAR COM NULL SAFETY
    //filteredServices.sort((a, b) => a.data.compareTo(b.data));

    if(_search != ''){
      List<Service> filteredServicesSearch = [];

      filteredServices.forEach((service) {
                                service.team?.forEach((key, volunteers) {
                                                            volunteers.forEach((volunteer) {
                                                              if(volunteer.contains(_search)){
                                                                if(!filteredServicesSearch.any((element) => element.id == service.id)){
                                                                  filteredServicesSearch.add(service);
                                                                }
                                                              }
                                                            }
                                                           );
                                                        }
                                                    );
                                          }
      );

      return sortFilteredServices(filteredServicesSearch);//filteredServicesSearch;

    }

    return sortFilteredServices(filteredServices);//filteredServices
  }


  ///De cima para baixo
  ///mais acima são os cultos mais próximos
  ///descendo próximas datas
  ///ao fim cultos que já ocorreram
  List<Service> sortFilteredServices( List<Service> lstService){
    //qual á data atual?
    DateTime dateTime = DateTime.now();

    List<Service> beforeListService = lstService.where((element) => element.data!.isBefore(dateTime)).toList();
    List<Service> afterListService = lstService.where((element) => element.data!.isAfter(dateTime)).toList();
    afterListService.addAll(beforeListService);

    return afterListService;
  }

  Future<void> _loadAllServices() async {
    final QuerySnapshot snapServices =
    await firestore.collection('services').where('ativo', isEqualTo: 'True')
                                          .get().then((QuerySnapshot querySnapshot) => querySnapshot);

    allServices = snapServices.docs.map(
            (d) => Service.fromDocument(d)).toList();

    notifyListeners();
  }

  Future<void> _loadAllServicesByDate(DateTime dateTime) async {
    final lastDayOfMonth = new DateTime(dateTime.year,dateTime.month+1,1);
    final firstDayOfMount = new DateTime(dateTime.year,dateTime.month,1);
    QuerySnapshot snapServices =
    await firestore.collection('services')
        .where('data', isGreaterThanOrEqualTo: firstDayOfMount)
        .where('data', isLessThanOrEqualTo: lastDayOfMonth)
        .where('ativo', isEqualTo: 'True')
        .get().then((QuerySnapshot querySnapshot) => querySnapshot);

    allServices = snapServices.docs.map(
            (d) => Service.fromDocument(d)).toList();
    //notifyListeners();
  }

  Future<void> _loadAllService(UserManager userManager) async {
    final QuerySnapshot snapServices =
    await firestore.collection('services').where('ativo', isEqualTo: 'True')
        .get().then((QuerySnapshot querySnapshot) => querySnapshot);

    allServices = snapServices.docs.map(
            (d) => Service.fromDocument(d)).toList();

    notifyListeners();
  }

  void update(Service service){
    allServices!.removeWhere((s) => s.id == service.id);
    allServices!.add(service);
    service.save();
    notifyListeners();
  }

  updateUser(UserManager userManager) {
    user = userManager.userApp;
    if(user != null){
      _loadAllService(userManager);
    }
  }

}