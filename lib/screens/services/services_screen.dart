import 'package:flutter/material.dart';
import 'package:louvor_app/common/custom_drawer/custom_drawer.dart';
import 'package:louvor_app/models/service_manager.dart';
import 'package:louvor_app/screens/services/components/service_list_tile.dart';
import 'package:provider/provider.dart';

import 'components/search_dialog.dart';
import 'components/service_list_tile.dart';

class ServicesScreen extends StatelessWidget {

  ServicesScreen();

  ServicesScreen.buildByMounth(DateTime dateTime);

  @override
  Widget build(BuildContext context) {
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
              Navigator.of(context).pushNamed(
                '/service',
              );
            },
          )
        ],
      ),
      body: Consumer<ServiceManager>(
        builder: (_, serviceManager, __) {
          final filteredServices = serviceManager.filteredServices;
          return ListView.builder(
              padding: const EdgeInsets.all(4),
              itemCount: filteredServices.length,
              itemBuilder: (_, index) {
                return ServiceListTile(filteredServices[index]);
              });
        },
      ),
    );
  }
}
