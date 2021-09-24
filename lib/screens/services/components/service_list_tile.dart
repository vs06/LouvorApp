import 'package:flutter/material.dart';
import 'package:louvor_app/models/Service.dart';
import 'package:louvor_app/models/service_manager.dart';
import 'package:louvor_app/models/user_manager.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';


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
            height: 85,
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
                            _getDateService(service.data),
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
                          'Vocal: Daniele, Mariana, Valdir, Vitor',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          ' instrumental : Lucas, Marcio, Vitor, Leonardo',
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
  String _getDateService(DateTime datetime){

    var dayOfWeekPtbr = "";
      switch (DateFormat('EEEE').format(service.data).toUpperCase()) {
        case "SUNDAY":
          dayOfWeekPtbr = "Domingo";
          break;
        case "MONDAY":
          dayOfWeekPtbr = "Segunda";
          break;
        case "TUESDAY":
          dayOfWeekPtbr = "Terça";
          break;
        case "WEDNESDAY":
          dayOfWeekPtbr = "Quarta";
          break;
        case "THURSDAY":
          dayOfWeekPtbr = "Quinta";
          break;
        case "FRIDAY":
          dayOfWeekPtbr = "Sexta";
          break;
        case "SATURDAY":
          dayOfWeekPtbr = "Sábado";
          break;
      }

      var dayMounth =  DateFormat('dd/MM').format(service.data);
      var hourMinute24 = DateFormat('HH:mm').format(datetime);
      return datetime == null ? "" : dayOfWeekPtbr + " - " + dayMounth + " - "+ hourMinute24;
  }
}