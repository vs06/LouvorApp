import 'dart:math';

import 'package:flutter/material.dart';
import 'package:louvor_app/common/custom_drawer/drop_down_list_string.dart';
import 'package:louvor_app/models/Song.dart';
import 'package:louvor_app/models/Service.dart';
import 'package:louvor_app/models/user.dart';
import 'package:louvor_app/models/user_manager.dart';
import 'package:louvor_app/screens/songs/songs_service_screen.dart';
import 'package:provider/provider.dart';
import 'package:louvor_app/models/service_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:async';
//import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

import 'TeamServiceScreen.dart';

class ServiceScreen extends StatefulWidget {
  final Service service;

  ServiceScreen(Service s) : service = s != null ? s.clone() : Service();

  ServiceScreen.buildSongs(this.service);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    @override
  State<StatefulWidget> createState() {
    return ServiceScreenState();
  }
}

class ServiceScreenState extends State<ServiceScreen> {

  TextEditingController _dateController = TextEditingController();
  TextEditingController _dirigenteController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String dropdownValue = 'Dirigente';

  Future _selectDate() async {
    DateTime picked = await showDatePicker(context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2021),
        lastDate: DateTime(2050)
    );
    if (picked != null){
      setState(() => selectedDate = picked);
      setState(() => _dateController.text = "${picked.toLocal().day}/${picked.toLocal().month}/${picked.toLocal().year}");
      setState(() => widget.service.data = selectedDate);
    }

  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

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
                  Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () => _selectDate(),
                          child: AbsorbPointer(
                            child: TextFormField(
                              onSaved: (val) {
                                widget.service.data = selectedDate;
                              },
                              controller: _dateController,
                              decoration: InputDecoration(
                                labelText: widget.service.data == null ? "Data" : DateFormat('dd/MM/yyyy').format(widget.service.data).toString(),
                                icon: Icon(Icons.calendar_today),
                              ),
                              validator: (value) {
                                if (widget.service.data == null)
                                  return "Please enter a date for your serice";
                                return null;
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: TextFormField(
                            //controller: _dirigenteController,
                            initialValue: widget.service.dirigente,
                            onSaved: (dr) => widget.service.dirigente = dr,
                            //onEditingComplete: () => widget.service.dirigente = _dirigenteController.text,
                            decoration: const InputDecoration(
                              hintText: 'Dirigente',
                              border: InputBorder.none,
                              labelText: 'Dirigente',
                              labelStyle: TextStyle(fontSize: 15),
                              icon: Icon(Icons.person_pin_sharp),
                            ),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
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
                                      Visibility(visible: UserManager.isUserAdmin,
                                                  child: GestureDetector(
                                                              onTap: () {
                                                                if (widget.formKey.currentState.validate()) {
                                                                  widget.formKey.currentState.save();
                                                                  Navigator.of(context).pop();
                                                                }
                                                                //todo
                                                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => TeamServiceScreen.buildTeamServiceScreen(widget.service)));
                                                              },
                                                              child: Icon(
                                                                Icons.add_circle_sharp,
                                                                color: Colors.blueGrey,
                                                              ),
                                                  ),
                                      )
                                  ],
                    ),
                  ),

                  Expanded(
                    flex: 2,
                    child:
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child:ListView.builder(
                                padding: const EdgeInsets.all(8),
                                itemCount: widget.service.team != null ? widget.service.team.length: 0,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  String role =  widget.service.team.keys.elementAt(index);
                                  return Expanded(
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(4)
                                      ),
                                      child: Container(
                                        height: 40,
                                        padding: const EdgeInsets.all(8),
                                        child: Row(
                                          children: <Widget>[
                                            const SizedBox(width: 16,),
                                            Expanded(
                                              flex: 5,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [

                                                      Text( role +':',
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w800,
                                                          color: Colors.lightBlue,
                                                        ),
                                                      ),

                                                      Text( splitVolunteers(widget.service.team[role]),
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w800,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  // tentativa de listar os volunteers por role, para edicao em separado
                                                  // Column(
                                                  //   children: [
                                                  //                   Row(
                                                  //                             children: [
                                                  //                                       ListView.builder(
                                                  //                                       padding: const EdgeInsets.all(8),
                                                  //                                       itemCount: widget.service.team[role].length,
                                                  //                                       shrinkWrap: true,
                                                  //                                       itemBuilder: (BuildContext context, int index) {
                                                  //                                             String users =  widget.service.team[role].elementAt(index);
                                                  //                                             return Expanded(child: Card(shape:
                                                  //                                                             RoundedRectangleBorder(
                                                  //                                                             borderRadius: BorderRadius.circular(4)
                                                  //                                                             )
                                                  //                                                             )
                                                  //                                                     );}
                                                  //                                       )
                                                  //
                                                  //                             ],
                                                  //                   )
                                                  //   ],
                                                  // ),

                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
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
                        GestureDetector(
                          onTap: () {
                            if (widget.formKey.currentState.validate()) {
                              widget.formKey.currentState.save();
                              Navigator.of(context).pop();
                            }
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => SongsServiceScreen.buildSongsServiceScreen(widget.service)));
                          },
                          child: Icon(
                            Icons.add_circle_sharp,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                  ),


                  Expanded(
                    flex: 2,
                    child:
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: widget.service.lstSongs == null ? 0 : widget.service.lstSongs.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Expanded(
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)),
                                child: Container(
                                  height: 40,
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    children: <Widget>[
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    widget.service
                                                        .lstSongs[index].nome,
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                      FontWeight.w800,
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment: Alignment.topRight,
                                                  child: GestureDetector(
                                                    onTap: () =>
                                                        _launchChordsURL(widget
                                                            .service
                                                            .lstSongs[index]),
                                                    child: Icon(
                                                      Icons.straighten_rounded,
                                                      color: Colors.blueGrey,
                                                    ),
                                                    //child: IconData(0xe457, fontFamily: 'MaterialIcons'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),


                  ),
//----------------------------------------------bto salvar------------------
                  Consumer<Service>(
                    builder: (_, service, __) {
                      return RaisedButton(
                        onPressed: () async {
                          if (widget.formKey.currentState.validate()) {
                            widget.formKey.currentState.save();
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
//--------------------------------------------------------------------------
                ],
              ),
            )
        ),
      ),
    );
  }

  void _launchChordsURL(Song song) async => await canLaunch(song.cifra)
      ? await launch(song.cifra)
      : throw 'Could not launch $song.cifra';

  String splitVolunteers(List<String> lstVolunteers) {
    String volunteers = "";
    int counter = lstVolunteers.length;
    lstVolunteers.forEach((element) {
      volunteers += element;
      counter--;
      if(counter > 0)
        volunteers +=  ', ';
    }
    );
    return  volunteers;
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

}
