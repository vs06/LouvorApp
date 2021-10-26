import 'package:flutter/material.dart';
import 'package:louvor_app/common/custom_drawer/custom_drawer.dart';
import 'package:louvor_app/helpers/app_list_pool.dart';
import 'package:louvor_app/helpers/date_utils.dart';
import 'package:louvor_app/helpers/multi_utils.dart';
import 'package:louvor_app/models/Service.dart';
import 'package:louvor_app/models/service_manager.dart';
import 'package:louvor_app/screens/services/components/service_list_tile.dart';
import 'package:louvor_app/screens/services/services_month_creator_screen.dart';
import 'package:provider/provider.dart';
import 'package:louvor_app/models/user_manager.dart';

import 'components/search_dialog.dart';
import 'components/service_list_tile.dart';


class ServicesScreen extends StatefulWidget{

  DateTime? filterByMonth;

  ServicesScreen.buildByMonth(this.filterByMonth);

  ServicesScreen();

  bool isSearchFill = false;

  @override
  State<StatefulWidget> createState() {
    return ServicesScreenState();
  }

}
class ServicesScreenState extends State<ServicesScreen>{

  @override
  Widget build(BuildContext context) {
    List<Service> _filteredServices = [];
    List<Service> lstServicesUsedAsResume = [];

    return Scaffold(
        drawer: CustomDrawer(),
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              );
            },
          ),
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
                            builder: (_) =>
                                SearchDialog(serviceManager.search));
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
                        setState(() {
                          widget.isSearchFill = true;
                        });
                      }
                    },
                  );
                } else {
                  return IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () async {
                      serviceManager.search = '';
                      setState(() {
                        widget.isSearchFill = false;
                      });
                    },
                  );
                }
              },
            ),
            Visibility(
                visible: UserManager.isUserAdmin == true,
                child: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      '/service',
                    );
                  },
                ))
          ],
        ),
        body: Consumer<ServiceManager>(
          builder: (_, serviceManager, __) {
            _filteredServices = serviceManager.filteredServicesByMonth(widget.filterByMonth);
            orderTeamRoles(_filteredServices);
            lstServicesUsedAsResume = [];
            _filteredServices.forEach((service) => lstServicesUsedAsResume.add(service));
            return _filteredServices.length > 0
                ? ListView.builder(
                    padding: const EdgeInsets.all(4),
                    itemCount: _filteredServices.length,
                    itemBuilder: (_, index) {
                      return ServiceListTile(_filteredServices[index]);
                    })
                : Center(
                    child: Text( serviceManager.search.isEmpty ? 'Sem Cultos\nCadastrados em: ${DateUtilsCustomized.monthBr(widget.filterByMonth)}' : 'Sem resultado\npara sua pesquisa.',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w800,
                                      color: Theme.of(context).primaryColor),
                               )
                        );
          },
        ),
        floatingActionButton: Visibility(
          visible: UserManager.isUserAdmin == true && !widget.isSearchFill,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                child: Icon(
                  Icons.list,
                  size: 30,
                ),
                onPressed: () {
                  if (_filteredServices.length > 0) {
                    showAlertDialog1(context, lstServicesUsedAsResume);
                  } else {
                    //rederizar para criação automatica
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ServicesMonthCreatorScreen(widget.filterByMonth)));
                  }
                },
              ),
            ],
          ),
        ));
  }

  showAlertDialog1(
      BuildContext context, List<Service> lstServicesUsedAsResume) {
    // configura o button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
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

  String volunteersMonthResume(List<Service> lstServicesOfMonth) {
    String stringResume = '';

    Map<String, Map<String, int>> mapRoleVolunteerQuantity = new Map();

    lstServicesOfMonth.forEach((service) {
      //Considerar Dirigente no vocal
      if (service.dirigente != null && service.dirigente != '') {
        if (service.team == null) {
          service.team = new Map();
          service.team!.putIfAbsent('Vocal', () => [service.dirigente ?? '']);
        } else {
          if (!service.team!.containsKey('Vocal')) {
            service.team!.putIfAbsent('Vocal', () => [service.dirigente ?? '']);
          } else {
            service.team!['Vocal']!.add(service.dirigente ?? '');
          }
        }
      }

      if (service.team != null) {
        service.team!.forEach((role, listVolunteer) {
          addToMap(mapRoleVolunteerQuantity, role, listVolunteer);
        });
      }
    });

    mapRoleVolunteerQuantity.forEach((role, volunteers) {
      stringResume += role + '\n';
      volunteers.forEach((volunteer, quantity) {
        stringResume += '\t\t- ${volunteer} : ${quantity}\n';
      });
    });

    if (stringResume == '')
      return stringResume + 'Sem alocações cadastradas.\n';

    return stringResume + '\n';
  }

  void addToMap(Map<String, Map<String, int>> mapRoleVolunteerQuantity,
      String role, List<String> listVolunteer) {
    listVolunteer.forEach((volunteer) {
      if (mapRoleVolunteerQuantity.containsKey(role)) {
        if (mapRoleVolunteerQuantity[role]!.containsKey(volunteer)) {
          mapRoleVolunteerQuantity[role]![volunteer] =
              (mapRoleVolunteerQuantity[role]![volunteer] ?? 0) + 1;
        } else {
          mapRoleVolunteerQuantity[role]!.putIfAbsent(volunteer, () => 1);
        }
      } else {
        mapRoleVolunteerQuantity.putIfAbsent(role, () => {volunteer: 1});
      }
    });
  }

  void orderTeamRoles(List<Service> filteredServices) {
    filteredServices.forEach((service) {
      if (MultiUtils.isMapNotNullNotEmpty(service.team)) {
        Map<String, List<String>> teamSorted = new Map();

        AppListPool.serviceRoles.forEach((role) {
          if (service.team!.keys.contains(role)) {
            teamSorted.putIfAbsent(role, () => service.team![role] ?? []);
          }
        });

        service.team = teamSorted;
      }
    });
  }
}
