import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:louvor_app/helpers/date_utils.dart';
import 'package:louvor_app/helpers/multi_utils.dart';
import 'package:louvor_app/helpers/string_utils.dart';
import 'package:louvor_app/models/Service.dart';
import 'package:louvor_app/models/Song.dart';
import 'package:louvor_app/models/service_manager.dart';
import 'package:louvor_app/models/user_manager.dart';
import 'package:louvor_app/screens/loading_screen.dart';
import 'package:louvor_app/screens/songs/songs_service_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'TeamServiceScreen.dart';

class ServiceScreen extends StatefulWidget {

  Service service;
  Service serviceWithoutChanges;

  TextEditingController dateController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ServiceScreen(Service s){
    service = s != null ? s.clone() : Service();
    if(service.data != null){
      dateController.text = DateFormat('dd/MM/yyyy').format(service.data).toString();
    }

    serviceWithoutChanges = service.clone();

  }

  ServiceScreen.modify(Service serviceWithChanges, Service serviceWithoutChanges){
    service = serviceWithChanges != null ? serviceWithChanges.clone() : Service();
    if(service.data != null){
      dateController.text = DateFormat('dd/MM/yyyy').format(service.data).toString();
    }

    this.serviceWithoutChanges = serviceWithoutChanges != null ? serviceWithoutChanges : null;

  }

  ServiceScreen.buildSongs(this.service);

  @override
  State<StatefulWidget> createState() {
    return ServiceScreenState();
  }
}

class ServiceScreenState extends State<ServiceScreen> {

  Future _selectDate(bool toggleNight) async {
    DateTime picked = await showDatePicker(context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2021),
        lastDate: DateTime(2050)
    );
    if (picked != null){
      setState(() => widget.dateController.text = "${picked.toLocal().day}/${picked.toLocal().month}/${picked.toLocal().year}");
      setState(() => widget.service.data = _getHourByToggle(picked, toggleNight));
    }

  }

  ScrollController _scrollVolunteersController = ScrollController();

  @override
  Widget build(BuildContext context) {

    final primaryColor = Theme.of(context).primaryColor;
    bool toggleNight = true;
    if(widget.service.data != null) {
      toggleNight = widget.service.data.hour >= 16;
    }

    return ChangeNotifierProvider.value(
      value: widget.service,
      child: Scaffold(
        appBar: AppBar(
          title: widget.service != null
              ? Text("Culto")
              : Text(DateFormat('dd/MM/yyyy').format(widget.service.data)),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: Form(
            key: widget.formKey,
            child:
            Padding(
              padding: const EdgeInsets.all(16),
              child:
              Column(
                children: <Widget>[
                  Row(
                      children: <Widget>[
                        Container(
                          width: 135,
                          child:
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: TextFormField(
                              initialValue: widget.service.dirigente,
                              enabled:  UserManager.isUserAdmin,
                              onSaved: (dr) => widget.service.dirigente = dr,
                              decoration: const InputDecoration(
                                hintText: 'Dirigente',
                                border: InputBorder.none,
                                labelText: 'Dirigente',
                                labelStyle: TextStyle(fontSize: 15),
                                icon: Icon(Icons.person_pin_sharp, size: 30,),
                              ),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 140,
                          child:
                              GestureDetector(
                                      onTap: () {
                                          if(UserManager.isUserAdmin){
                                            _selectDate(toggleNight);
                                          }
                                      },
                                child: AbsorbPointer(
                                  child:
                                  TextFormField(
                                    enabled:  UserManager.isUserAdmin,
                                    controller: widget.dateController,
                                    decoration: InputDecoration(
                                                    labelText: "Data",
                                                    border: InputBorder.none,
                                                    icon: Icon(Icons.calendar_today),
                                                  ),
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                    ),
                                    validator: (value) {
                                      if (widget.service.data == null)
                                        return "Insira uma data para o culto";
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                        ),

                        Container(
                          width: 50,
                          child:
                              Column(
                                children: [
                                  IconButton(
                                      icon: toggleNight
                                          ? Icon(Icons.nights_stay)
                                          : Icon(Icons.wb_sunny_sharp),
                                      color: Colors.blueGrey,
                                      onPressed: () {
                                            if(UserManager.isUserAdmin){
                                                setState(() {
                                                toggleNight = !toggleNight;
                                                });
                                                widget.service.data = _getHourByToggle(widget.service.data == null ? DateTime.now() : widget.service.data, toggleNight);
                                          }
                                      }),
                                ],
                              )
                        ),

                      ]
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child:Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                                      Text('Equipe',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: primaryColor,
                                        ),
                                      ),
                                      Visibility(visible: widget.service.data == null || (widget.service.data.isAfter(DateTime.now()) && UserManager.isUserAdmin),
                                                  child: GestureDetector(
                                                              onTap: () {
                                                                if (widget.formKey.currentState.validate()) {
                                                                  widget.formKey.currentState.save();
                                                                }

                                                                //Fix null pointer
                                                                if(widget.service.team == null)
                                                                  widget.service.team = new Map();

                                                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => TeamServiceScreen.buildTeamServiceScreen(widget.service)));
                                                              },
                                                              child: Icon(
                                                                (widget.service.team == null || widget.service.team.length == 0) ? Icons.add_circle_sharp: Icons.edit_outlined,
                                                                color: Colors.lightBlue,
                                                                size: 30,
                                                              ),
                                                  ),
                                      )
                                  ],
                    ),
                  ),

                   Expanded(
                     flex: 2,
                      child:
                        Scrollbar(
                          isAlwaysShown: true,
                          controller: _scrollVolunteersController,
                          child: ListView.builder(
                                      padding: const EdgeInsets.all(8),
                                      itemCount: widget.service.team != null ? widget.service.team.length: 0,
                                      shrinkWrap: true,
                                      itemBuilder: (BuildContext context, int index) {
                                        String role =  widget.service.team.keys.elementAt(index);
                                        return Column(
                                            children:[
                                              Card(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(4)
                                                ),
                                                child: Container(
                                                  height: MultiUtils.calculaHeightTile(widget.service.team[role].length),
                                                  padding: const EdgeInsets.all(8),
                                                  child: Row(
                                                    children: <Widget>[
                                                      const SizedBox(width: 16,),
                                                      Column(
                                                          children:<Widget>[
                                                            Expanded(
                                                              flex: 5,
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: <Widget>[
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Center(
                                                                        child: Column( children: [
                                                                          Text( role +':  ',
                                                                            overflow: TextOverflow.ellipsis,
                                                                            style: TextStyle(
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w800,
                                                                              color: Colors.lightBlue,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                        ),
                                                                      ),
                                                                      Column(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                          children: [
                                                                            Text( StringUtils.splitVolunteersToTile((widget.service.team[role])),
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: TextStyle(
                                                                                fontSize: 16,
                                                                                fontWeight: FontWeight.w800,
                                                                              ),
                                                                            ),
                                                                          ]
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ]
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ]
                                        );
                                      }
                                  ),
                        ),
                   ),

                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Músicas',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        Visibility(
                            visible: widget.service.data == null || widget.service.data.isAfter(DateTime.now()),
                            child:
                            GestureDetector(
                                      onTap: () {
                                                  if(widget.formKey.currentState.validate()) {
                                                       widget.formKey.currentState.save();
                                                  }
                                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => SongsServiceScreen.buildSongsServiceScreen(widget.service)));
                                      },
                              child: Icon(
                                (widget.service.lstSongs == null || widget.service.lstSongs.length == 0) ? Icons.add_circle_sharp : Icons.edit_outlined,
                                color: Colors.lightBlue,
                                size: 30,
                              ),
                            ),
                        )
                      ],
                    ),
                  ),

                  Expanded(
                    flex: 2,
                    child:
                        ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: widget.service.lstSongs == null ? 0 : widget.service.lstSongs.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return
                                Column(
                                    children: [
                                      Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(4)),
                                          child: Container(
                                              height: 40,
                                              padding: const EdgeInsets.all(8),
                                              child:
                                              Row(
                                                  children: <Widget>[
                                                    const SizedBox( width: 16,),
                                                          Expanded(
                                                              flex: 5,
                                                              child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: <Widget>[
                                                                    Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Flexible(child:
                                                                              Text(
                                                                                widget.service.lstSongs[index].nome,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: TextStyle(
                                                                                  fontSize: 16,
                                                                                  fontWeight:
                                                                                  FontWeight.w800,
                                                                                ),
                                                                              ),
                                                                          )
                                                                        ]
                                                                    )
                                                                  ]
                                                              )
                                                          ),
                                                          //  SizedBox(width: 5),
                                                          Expanded(
                                                              flex: 3, // 20%
                                                              child:
                                                                      Column(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        //crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Visibility(
                                                                                visible: StringUtils.isNotNUllNotEmpty(widget.service.lstSongs[index].cifra),
                                                                                child:
                                                                                Align(
                                                                                  alignment: Alignment.topRight,
                                                                                  child: GestureDetector(
                                                                                    onTap: () => _launchChordsURL(widget.service.lstSongs[index]),
                                                                                    child: Icon(
                                                                                      Icons.straighten_rounded,
                                                                                      color: Colors.blueGrey,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              SizedBox(width: 15),
                                                                              Text('Tom: ' + widget.service.lstSongs[index].tom,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: TextStyle(
                                                                                  color: Colors.blueGrey,
                                                                                  fontSize: 13,
                                                                                  fontWeight:
                                                                                  FontWeight.w800,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          )
                                                                        ],
                                                                    )
                                                          ),
                                                   //     ]
                                                 //   )
                                                  ]
                                              )
                                          )
                                      )
                                 ]
                              );
                          }),
                  ),

//----------------------------------------------bto salvar------------------
                  Consumer<Service>(
                    builder: (_, service, __) {
                      return Visibility(
                                visible: isSaveOptionEnabled(),
                                child:  RaisedButton(
                                        onPressed: () async {
                                          widget.service.data = _getHourByToggle(widget.service.data, toggleNight);
                                          if (widget.formKey.currentState.validate()) {
                                            widget.formKey.currentState.save();
                                            context.read<ServiceManager>().update(service);
                                            Navigator.of(context).pop();
                                            String predifiniedWhatsAppMessage = getPredifiniedWhatsAppMessage(widget.service);
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoadingScreen.whatsAppMessage(predifiniedWhatsAppMessage)));

                                          }
                                        },
                                        textColor: Colors.white,
                                        color: primaryColor,
                                        disabledColor: primaryColor.withAlpha(100),
                                        child: const Text(
                                          'Salvar',
                                          style: TextStyle(fontSize: 18.0),
                                        ),
                                      )
                      );
                    },
                  ),
//--------------------------------------------------------------------------
                ],
              ),
            )
        ),
      ),
    );
  }

  bool isSaveOptionEnabled(){

    if(widget.service.data ==  null){
      return false;
    }

    if(widget.service.data.isBefore(DateTime.now())){
      return false;
    }

    return isServicesHasChanges( widget.serviceWithoutChanges, widget.service);
  }

  bool isServicesHasChanges(Service serviceWithoutChanges, Service serviceWithChanges){

    if(serviceWithoutChanges.data != serviceWithChanges.data){
      return true;
    }

    if(serviceWithoutChanges.dirigente != serviceWithChanges.dirigente){
      return true;
    }

    int matches = 0;
    serviceWithoutChanges.lstSongs.forEach((song) {
      if(serviceWithChanges.lstSongs.contains(song)){
        matches++;
      }
    });

    if((serviceWithChanges.lstSongs.length != serviceWithoutChanges.lstSongs.length ) || (matches != serviceWithChanges.lstSongs.length)){
      return true;
    }

    return false;
  }

  void _launchChordsURL(Song song) async => await canLaunch(song.cifra)
      ? await launch(song.cifra)
      : throw 'Could not launch $song.cifra';

     DateTime _getHourByToggle(DateTime serviceDate, bool toggleNight){
     if(toggleNight){
       if(DateFormat('EEEE').format(serviceDate).toUpperCase() == 'SUNDAY'){
         return new DateTime(serviceDate.year, serviceDate.month, serviceDate.day, 19, 00);
       }else{
         return new DateTime(serviceDate.year, serviceDate.month, serviceDate.day, 20, 00);
       }
     }else{
       return new DateTime(serviceDate.year, serviceDate.month, serviceDate.day, 10, 00);
     }
  }

  void addTeamMap(String valueRoleDropDownSelected, String valueUserDropDownSelected) {
    if(!valueRoleDropDownSelected.isEmpty && !valueUserDropDownSelected.isEmpty){

      if(widget.service.team.containsKey(valueRoleDropDownSelected)){
        if(!widget.service.team[valueRoleDropDownSelected].contains(valueUserDropDownSelected)){
          setState(() {
            widget.service.team[valueRoleDropDownSelected].add(valueUserDropDownSelected);
          });
        }else{
          setState(() {
            widget.service.team.putIfAbsent(valueRoleDropDownSelected, () => [valueUserDropDownSelected]);
          });
        }
      } else {
        setState(() {
          widget.service.team.putIfAbsent(valueRoleDropDownSelected, () => [valueUserDropDownSelected]);
        });
      }
    }
  }

  String getPredifiniedWhatsAppMessage(Service service) {
    return 'Músicas culto ' + DateUtils.convertDatePtBr(service.data) + ', dirigente: ${service.dirigente},foram cadastradas.\nConsulte o App do Louvor para mais detalhes.' ;
  }

}
