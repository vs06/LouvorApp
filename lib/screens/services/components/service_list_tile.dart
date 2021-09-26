import 'package:flutter/material.dart';
import 'package:louvor_app/helpers/date_utils.dart';
import 'package:louvor_app/models/Service.dart';
import 'package:louvor_app/models/service_manager.dart';
import 'package:louvor_app/models/user_manager.dart';
import 'package:provider/provider.dart';

class ServiceListTile extends StatelessWidget {

  const ServiceListTile(this.service);

  final Service service;

  _showAlertDialog(BuildContext context, String conteudo, Service s) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmação'),
          content: Text(conteudo),
          actions: [
            FlatButton(
              child: Text('Não'),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: Text('Sim'),
              onPressed: () {
                //TODO fix this POG
                s.delete(s);
                context.read<ServiceManager>().update(s);
                Navigator.pop(context);
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
        Navigator.of(context).pushNamed('/service', arguments: service);
      },
       child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4)
          ),
          child: Container(
            height: 110,
            padding: const EdgeInsets.all(6),
            child: Row(
              children: <Widget>[
                const SizedBox(width: 16,),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateUtils.convertDatePtBr(service.data),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            ' ${service.dirigente}',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Theme.of(context).primaryColor
                            ),
                          ),
                          Visibility(
                            visible: UserManager.isUserAdmin,
                            child: GestureDetector(
                                      onTap: () {
                                        _showAlertDialog(context, 'Confirma a exclusão desse culto?', service);
                                      },
                                      child: Icon(Icons.delete, color: Colors.blueGrey,),
                                  ),
                          )

                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          getSingersVolunteers(),
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          getMusiciansVolunteers(),
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          getSongsofaService(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
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

  String getSingersVolunteers(){
    String singersVolunteers = 'Vocal: ';
    service.team.forEach((key, value) {
                                        if(key == 'Vocal') {
                                          value.forEach((volunteer) => singersVolunteers += ', ' + volunteer);
                                        }
                                      }
                        );

    singersVolunteers = singersVolunteers.replaceAll('Vocal: ,','Vocal: ');
    return singersVolunteers;
  }

  String getMusiciansVolunteers(){
    String musiciansVolunteers = 'Instrumental: ';

    service.team.forEach((key, value) {
                                        if(key != 'Vocal') {
                                          value.forEach((volunteer) => musiciansVolunteers +=', ' +  volunteer);
                                        }
                                      }
    );

    musiciansVolunteers = musiciansVolunteers.replaceAll('Instrumental: ,','Instrumental: ');
    return musiciansVolunteers;
  }

  String getSongsofaService(){
    String songs = 'Músicas: ';

    service.lstSongs.forEach((element) {
      songs += element.nome + ' ,';
    });

    return songs;
  }
}