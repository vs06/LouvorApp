import 'package:url_launcher/url_launcher.dart';

class NotificationUtils {

  static void sendNotificationWhatsUp(String msg) async {
    try{

      //Funciona mais ou menos, "abre" o grupo, mas não tras a msg
      //var whatsappURl_android = "https://chat.whatsapp.com/FNS0IsdeyTg3ClTuC1H0mn?text=teste";

      //Abre o whats, pergunta pra quem enviar, e salva a msg
      var whatsappURl_android = "whatsapp://send?phone=&text=${msg}";

      if(await canLaunch(whatsappURl_android)){
        await launch(whatsappURl_android);
      }

    }catch(e){
      //TODO
    }
  }

}