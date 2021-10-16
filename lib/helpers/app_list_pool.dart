import 'package:louvor_app/models/user.dart';

class AppListPool {

   static final List<String> serviceRoles= ['Vocal', 'Teclado', 'Violão', 'Guitarra', 'Contrabaixo', 'Bateria', 'Téc. de som'];

   static final List<String> servicesPeriod= ['Período','Manhã','Noite'];

   static final List<String> mounths = ['Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho', 'Julho','Agosto','Setembro','Outubro','Novembro','Dezembro'];

   static final List<String> daysOfWeek = ['Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado', 'Domingo'];

   static final List<String> rehearsalTypes = ['Geral', 'Instrumental', 'Vocal'];


   static final List<String> usersName = [];

   static void fillUsers(List<User> allUsers ){
      allUsers.forEach((user) {
         int firstSpace = user.name.indexOf(' ');
         int lastName = user.name.lastIndexOf(' ');
         if(firstSpace != -1){
            usersName.add(user.name.substring(0, firstSpace)  + user.name.substring(lastName, user.name.length ) );
         } else {
            usersName.add(user.name);
         }
      });
   }

}