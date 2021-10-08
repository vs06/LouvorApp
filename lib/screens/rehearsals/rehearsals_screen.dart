import 'package:flutter/material.dart';
import 'package:louvor_app/common/custom_drawer/custom_drawer.dart';
import 'package:louvor_app/models/Rehearsal.dart';
import 'package:louvor_app/models/rehearsal_manager.dart';
import 'package:louvor_app/models/user_manager.dart';
import 'package:provider/provider.dart';

import 'components/rehearsal_list_tile.dart';
import 'components/search_dialog.dart';

class RehearsalsScreen extends StatelessWidget {

  RehearsalsScreen();
  DateTime filterByMonth;
  RehearsalsScreen.buildByMonth(this.filterByMonth);

  @override
  Widget build(BuildContext context) {

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
        title: Consumer<RehearsalManager>(
          builder: (_, rehearsalManager, __) {
            if (rehearsalManager.search.isEmpty) {
              return const Text('Ensaios');
            } else {
              return LayoutBuilder(
                builder: (_, constraints) {
                  return GestureDetector(
                    onTap: () async {
                      final search = await showDialog<String>(
                          context: context,
                          builder: (_) => SearchDialog(rehearsalManager.search));
                      if (search != null) {
                        rehearsalManager.search = search;
                      }
                    },
                    child: Container(
                        width: constraints.biggest.width,
                        child: Text(
                          'Ensaios: ${rehearsalManager.search}',
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
          Consumer<RehearsalManager>(
            builder: (_, rehearsalManager, __) {
              if (rehearsalManager.search.isEmpty) {
                return IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    final search = await showDialog<String>(
                                              context: context,
                                              builder: (_) => SearchDialog(rehearsalManager.search)
                                          );
                    if (search != null) {
                      rehearsalManager.search = search;
                    }
                  },
                );
              } else {
                return IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () async {
                    rehearsalManager.search = '';
                  },
                );
              }
            },
          ),
          Visibility(
              visible: UserManager.isUserAdmin,
              child:
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/rehearsal',);
                  },
                )
          )
        ],
      ),
      body: Consumer<RehearsalManager>(
        builder: (_, rehearsalManager, __) {
          final filteredRehearsals = rehearsalManager.filteredRehearsalsByMounth(filterByMonth);
          return ListView.builder(
              padding: const EdgeInsets.all(4),
              itemCount: filteredRehearsals.length,
              itemBuilder: (_, index) {
                return RehearsalListTile(filteredRehearsals[index]);
              });
        },
      )
    );
  }
}
