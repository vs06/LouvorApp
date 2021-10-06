import 'dart:async';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:url_launcher/url_launcher.dart';

class LoadingScreen extends StatefulWidget {

  String whatsUpMessage;

  LoadingScreen();

  LoadingScreen.whatsAppMessage(String whatsUpMessage){
    this.whatsUpMessage = whatsUpMessage;
  }

  @override
  State<StatefulWidget> createState() {
    return LoadingScreenState(whatsUpMessage);
  }
}

class LoadingScreenState extends State<LoadingScreen> {

  final String whatsUpMessage;
  LoadingScreenState(this.whatsUpMessage);

  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var duration = new Duration(milliseconds: 2500);
    return new Timer(duration, route);
  }

  route() {
    Navigator.of(context).pop();
    if(whatsUpMessage != null){
      sendNotificationWhatsUp(whatsUpMessage);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
        body:
        Center(
            child:
            AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(milliseconds: 500),
                child:
                Container(
                  height: 150,
                  width: 150,
                  child:
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 30,
                    shadowColor: Colors.lightBlue,
                    color: Colors.blue,
                    child:
                    LoadingBouncingGrid.square(
                      borderColor: Colors.lightBlueAccent,
                      borderSize: 3.0,
                      size: 80.0,
                      backgroundColor: Colors.white,
                      duration: Duration(milliseconds: 1500),
                    ),
                  ),
                )
            )
        )
    );

  }

  void sendNotificationWhatsUp(String msg) async {
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
