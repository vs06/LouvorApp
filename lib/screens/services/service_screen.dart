import 'package:flutter/material.dart';
import 'package:louvor_app/models/Song.dart';
import 'package:louvor_app/models/Service.dart';
import 'package:provider/provider.dart';
import 'package:louvor_app/models/song_manager.dart';
import 'package:louvor_app/models/service_manager.dart';

class ServiceScreen extends StatelessWidget {

  ServiceScreen(Service s) : service = s != null ? s.clone() : Service();

  final Service service;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return ChangeNotifierProvider.value(
        value: service,
    child: Scaffold(
      appBar: AppBar(
        title: service != null ? Text("Culto") : Text(service.data),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: formKey,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                TextFormField(
                      initialValue: service.data,
                      onSaved: (data) => service.data = data,
                      decoration: const InputDecoration(
                        hintText: 'Data',
                        border: InputBorder.none,
                        labelText: 'Data',
                      ),
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: TextFormField(
                      initialValue: service.dirigente,
                      onSaved: (dr) => service.dirigente = dr,
                      decoration: const InputDecoration(
                        hintText: 'Dirigente',
                        border: InputBorder.none,
                        labelText: 'Dirigente',
                      ),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ),
            // TODO Incluir lista de músicas aqui
            Padding(padding: const EdgeInsets.only(top: 8),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text(
                      'Insira as músicas aqui +',
                      style: TextStyle(
                      fontSize: 16,),)
                    ],
                ),
            ),
            // TODO End
            Consumer<Service>(
               builder: (_, service, __) {
                 return RaisedButton(
                   onPressed: () async {
                     if (formKey.currentState.validate()) {
                       formKey.currentState.save();
                       await service.save();
                       context.read<ServiceManager>().update(service);
                       Navigator.of(context).pop();
                     }
                   },
                   textColor: Colors.white,
                   color: primaryColor,
                   disabledColor: primaryColor.withAlpha(100),
                   child: const Text(
                     'Salvar',
                     style: TextStyle(fontSize: 18.0),
                   ),
                 );
               },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ),
    );
  }
}