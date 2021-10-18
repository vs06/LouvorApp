import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:louvor_app/helpers/app_list_pool.dart';
import 'package:louvor_app/helpers/date_utils.dart';
import 'package:louvor_app/helpers/notification_utils.dart';
import 'package:louvor_app/models/Service.dart';
import 'package:louvor_app/models/service_manager.dart';
import 'package:louvor_app/models/user_manager.dart';
import 'package:louvor_app/screens/services/services_screen.dart';
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
                s.ativo = 'False';
                context.read<ServiceManager>().update(s);

                //remover esse Service do allServices
                context.read<ServiceManager>().removeFromAllServices(s);

                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ServicesScreen.buildByMonth(s.data)));
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
            height: getSongsOfService().length > 45 ? 130: 110,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                border: isHighlightService() ?  Border.all(color: Colors.blueAccent, width: 5): Border(),
                color: service.data.isBefore(DateTime.now()) ? CupertinoColors.systemGrey3 : Colors.white,
                borderRadius: BorderRadius.circular(4)
            ),

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
                            DateUtilsCustomized.convertDatePtBr(service.data),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Visibility(
                           visible: !service.data.isBefore(DateTime.now()),
                                 child: GestureDetector(
                                          onTap: (){
                                                      sendMessageWhatsAppNotification();
                                                    },
                                            child: Icon(
                                               Icons.check_circle,
                                               color: songsSelectedColorStatus(service),
                                               size: 20,
                                             ),
                                 )
                          ),
                          Text(
                            ' '+ dirigenteNameToTile(service.dirigente),
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Theme.of(context).primaryColor
                            ),
                          ),
                          Visibility(
                            visible: UserManager.isUserAdmin && service.data.isAfter(DateTime.now()),
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
                          getSongsOfService(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            color: (getSongsOfService() == 'Músicas: ' && service.data.difference(DateTime.now()).inDays < 7) ? Colors.red : Colors.grey[800],
                            fontSize: 12,
                            fontWeight: (getSongsOfService() == 'Músicas: ' && service.data.difference(DateTime.now()).inDays < 7) ? FontWeight.bold : FontWeight.normal,
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

    if(service.team != null){
        service.team.forEach((key, value) {
          if(key == 'Vocal') {
            value.forEach((volunteer) => singersVolunteers += ', ' + volunteer);
          }
        }
        );
    }

    singersVolunteers = singersVolunteers.replaceAll('Vocal: ,','Vocal: ');
    return singersVolunteers;
  }

  String getMusiciansVolunteers(){
    String musiciansVolunteers = 'Instrumental: ';

    if(service.team != null){
        service.team.forEach((key, value) {
          if(key != 'Vocal') {
            value.forEach((volunteer) => musiciansVolunteers +=', ' +  volunteer);
          }
        }
        );
    }

    musiciansVolunteers = musiciansVolunteers.replaceAll('Instrumental: ,','Instrumental: ');
    return musiciansVolunteers;
  }

  String getSongsOfService(){
    String songs = 'Músicas: ';

    service.lstSongs.forEach((element) {
      songs += element.nome + ', ';
    });

    if(service.lstSongs.length > 0){
      songs = songs.substring(0, songs.length -2);
    }

    return songs;
  }

  ///Se primeiro nome não se repetir nos usuários, retorna somente primeiro nome
  ///Se repetir, retorna o primeiro nome mais a primeira letra do primeiro sobre nome
  String dirigenteNameToTile(String dirigenteName){
    if(dirigenteName == null || dirigenteName == ''){
      return '';
    }

    var firstSpace = service.dirigente.indexOf(' ');

    if(firstSpace == -1){
      if(dirigenteName.length > 10){
        return dirigenteName.substring(0,9);  
      }
      return dirigenteName;
    }

    var firstName = service.dirigente.substring(0, firstSpace);

    //Se precisar de sobrenome
    if(AppListPool.usersName.where((element) => element.contains(firstName)).length > 1) {
      return firstName + dirigenteName.substring(firstSpace, firstSpace+2);
    } else {
      return firstName;
    }

  }

  Color songsSelectedColorStatus(Service service){

    if(service.lstSongs.length > 0){
      return Colors.green;
    }

    DateTime currentDay = DateTime.now();
    if(service.data.difference(currentDay).inDays < 7){
      return Colors.red;
    }

    return Colors.blueGrey;
  }

  sendMessageWhatsAppNotification() {
    if(songsSelectedColorStatus(service) == Colors.red){
      final strWhatsMessage = service.dirigente + ', você fara a abertura do culto de: ${DateUtilsCustomized.convertDatePtBr(service.data)}.\nFaltam: ${(DateTime.now().day - service.data.day)*-1} dias para o culto.'
                                                + '\nO culto ainda não teve as músicas cadastradas.\nPoderia verificar?';
      NotificationUtils.sendNotificationWhatsUp(strWhatsMessage);
    }
  }

  isHighlightService(){
    return service.data.day == DateTime.now().day &&
           service.data.month == DateTime.now().month &&
           service.data.year == DateTime.now().year &&
           (service.data.hour + 2) > DateTime.now().hour;//após 2 horas no inicio do culta, retorna false;

  }
}