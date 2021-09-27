import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:louvor_app/common/custom_drawer/custom_drawer.dart';
import 'package:louvor_app/helpers/app_list_pool.dart';
import 'package:louvor_app/models/Service.dart';
import 'package:louvor_app/models/service_manager.dart';
import 'package:louvor_app/screens/services/components/service_list_tile.dart';
import 'package:provider/provider.dart';

import 'components/search_dialog.dart';
import 'components/service_list_tile.dart';

class ServicesScreen extends StatelessWidget {

  ServicesScreen();
  DateTime filterByMounth;
  ServicesScreen.buildByMounth(this.filterByMounth);

  @override
  Widget build(BuildContext context) {

    List<Service> lstServicesUsedAsResume = [];

    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Consumer<ServiceManager>(
          builder: (_, serviceManager, __) {
            if (serviceManager.search.isEmpty) {
              return const Text('Cultos');
            } else {
              return LayoutBuilder(
                builder: (_, constraints) {
                  return GestureDetector(
                    onTap: () async {
                      final search = await showDialog<String>(
                          context: context,
                          builder: (_) => SearchDialog(serviceManager.search));
                      if (search != null) {
                        serviceManager.search = search;
                      }
                    },
                    child: Container(
                        width: constraints.biggest.width,
                        child: Text(
                          'Cultos: ${serviceManager.search}',
                          textAlign: TextAlign.center,
                        )),
                  );
                },
              );
            }
          },
        ),
        centerTitle: true,
        actions: <Widget>[
          Consumer<ServiceManager>(
            builder: (_, serviceManager, __) {
              if (serviceManager.search.isEmpty) {
                return IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    final search = await showDialog<String>(
                        context: context,
                        builder: (_) => SearchDialog(serviceManager.search));
                    if (search != null) {
                      serviceManager.search = search;
                    }
                  },
                );
              } else {
                return IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () async {
                    serviceManager.search = '';
                  },
                );
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed('/service',);
            },
          )
        ],
      ),
      body: Consumer<ServiceManager>(
        builder: (_, serviceManager, __) {
          final filteredServices = serviceManager.filteredServicesByMounth(filterByMounth);
          lstServicesUsedAsResume = [];
          filteredServices.forEach((service) => lstServicesUsedAsResume.add(service));
          return ListView.builder(
              padding: const EdgeInsets.all(4),
              itemCount: filteredServices.length,
              itemBuilder: (_, index) {
                return ServiceListTile(filteredServices[index]);
              });
        },
      ),
        floatingActionButton:
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              child: Icon(
                Icons.list,
                size: 30,
              ),
              onPressed: () {
                showAlertDialog1(context, lstServicesUsedAsResume);
              },
            ),
          ],
        )

    );
  }

  showAlertDialog1(BuildContext context, List<Service> lstServicesUsedAsResume) {
    // configura o button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {  Navigator.of(context).pop(); },
    );

    // configura o  AlertDialog
    AlertDialog alerta = AlertDialog(
      title: Text("Resumo alocações mês"),
      content: Text(volunteersMonthResume(lstServicesUsedAsResume)),
      actions: [
        okButton,
      ],
    );
    // exibe o dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alerta;
      },
    );
  }

  String volunteersMonthResume(List<Service> lstServicesOfMonth){
    String stringResume = '';

    Map<String, Map<String, int>> mapRoleVolunteerQuantity = new Map();

    lstServicesOfMonth.forEach((service) {
                                            if(service.team != null){
                                                service.team.forEach((role, listVolunteer) {
                                                      addToMap(mapRoleVolunteerQuantity, role, listVolunteer);
                                                });
                                            }
                                         }
                               );

    mapRoleVolunteerQuantity.forEach((role, volunteers) {
                                                          stringResume += role+'\n';
                                                          volunteers.forEach((volunteer, quantity) {
                                                            stringResume += '\t\t- ${volunteer} : ${quantity}\n';
                                                          });

                                    });
  return stringResume+'\n';

  }
  
  void addToMap(Map<String, Map<String, int>> mapRoleVolunteerQuantity, String role, List<String> listVolunteer){

    listVolunteer.forEach((volunteer) {
      if(mapRoleVolunteerQuantity.containsKey(role)){
        if(mapRoleVolunteerQuantity[role].containsKey(volunteer)){
          mapRoleVolunteerQuantity[role][volunteer] = mapRoleVolunteerQuantity[role][volunteer]+1;
        }else{
          mapRoleVolunteerQuantity[role].putIfAbsent(volunteer, () => 1);
        }
      }else{
        mapRoleVolunteerQuantity.putIfAbsent(role, () => {volunteer: 1});
      }
    });

  }

}
