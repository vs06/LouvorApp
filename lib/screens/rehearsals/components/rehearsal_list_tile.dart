import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:louvor_app/helpers/date_utils.dart';
import 'package:louvor_app/models/Rehearsal.dart';
import 'package:louvor_app/models/rehearsal_manager.dart';
import 'package:louvor_app/models/user_manager.dart';
import 'package:provider/provider.dart';

import '../rehearsals_screen.dart';

class RehearsalListTile extends StatelessWidget {
  const RehearsalListTile(this.rehearsal);

  final Rehearsal rehearsal;

  _showAlertDialog(BuildContext context, String conteudo, Rehearsal r) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmação'),
          content: Text(conteudo),
          actions: [
            TextButton(
              child: Text('Não'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text('Sim'),
              onPressed: () {
                r.isActive = false;
                context.read<RehearsalManager>().update(r);

                //remover esse Service do allRehearsals
                context.read<RehearsalManager>().removeFromAllRehearsals(r);

                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        RehearsalsScreen.buildByMonth(r.data)));
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/rehearsal', arguments: rehearsal);
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        child: Container(
          height: 90,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
              border: (rehearsal.data!.day == DateTime.now().day &&
                      rehearsal.data!.month == DateTime.now().month)
                  ? Border.all(color: Colors.blueAccent, width: 5)
                  : Border(),
              color: rehearsal.data!.isBefore(DateTime.now())
                  ? CupertinoColors.systemGrey3
                  : Colors.white,
              borderRadius: BorderRadius.circular(4)),
          child: Row(
            children: <Widget>[
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateUtilsCustomized.convertDatePtBr(rehearsal.data!),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          ' ${rehearsal.type}',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Theme.of(context).primaryColor),
                        ),
                        Visibility(
                          visible: rehearsal.data!.isAfter(DateTime.now()) &&
                              (UserManager.isUserAdmin == true),
                          child: GestureDetector(
                            onTap: () {
                              _showAlertDialog(
                                  context,
                                  'Confirma a exclusão desse ensaio?',
                                  rehearsal);
                            },
                            child: Icon(
                              Icons.delete,
                              color: Colors.blueGrey,
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        getSongsOfRehearsal(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 15,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String getSongsOfRehearsal() {
    String songs = 'Músicas: ';

    rehearsal.lstSongs?.forEach((musica) {
      songs += (musica.nome! + ', ');
    });

    return songs.substring(0, songs.length - 2);
  }
}
