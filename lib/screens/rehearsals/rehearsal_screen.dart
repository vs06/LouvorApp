import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:louvor_app/helpers/app_list_pool.dart';
import 'package:louvor_app/helpers/date_utils.dart';
import 'package:louvor_app/helpers/loading_screen.dart';
import 'package:louvor_app/helpers/string_utils.dart';
import 'package:louvor_app/models/Rehearsal.dart';
import 'package:louvor_app/models/Song.dart';
import 'package:louvor_app/models/rehearsal_manager.dart';
import 'package:louvor_app/models/user_manager.dart';
import 'package:louvor_app/screens/songs/songs_service_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class RehearsalScreen extends StatefulWidget {

  late Rehearsal? rehearsal;
  late Rehearsal? rehearsalWithoutChanges;

  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();


  //RehearsalScreen();

  RehearsalScreen(Rehearsal? r){
    rehearsal = r != null ? r.clone() : Rehearsal();
    if(rehearsal?.data != null){
      dateController.text = DateUtilsCustomized.dataComplentaFormatada(r!.data ?? DateTime.now());
    }

    rehearsalWithoutChanges = rehearsal?.clone();

  }

  RehearsalScreen.modify(Rehearsal rehearsalWithChanges, Rehearsal rehearsalWithoutChanges){
    rehearsal = rehearsalWithChanges != null ? rehearsalWithChanges.clone() : Rehearsal();
    if(rehearsal?.data != null){
      dateController.text = DateUtilsCustomized.dataComplentaFormatada(rehearsalWithChanges.data!);
    }

    this.rehearsalWithoutChanges = rehearsalWithoutChanges != null ? rehearsalWithoutChanges : null;

  }

  RehearsalScreen.buildSongs(this.rehearsal);

  @override
  State<StatefulWidget> createState() {
    return RehearsalScreenState();
  }
}

class RehearsalScreenState extends State<RehearsalScreen> {

  String valueRehearsalTypeDropDownSelected = AppListPool.rehearsalTypes[0];

  Future _selectDate() async {
    DateTime? picked = await showDatePicker(context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2021),
        lastDate: DateTime(2050)
    );
    if (picked != null){
      setState(() => widget.dateController.text = "${picked.toLocal().day}/${picked.toLocal().month}/${picked.toLocal().year.toString().substring(2,4)}");
      setState(() => widget.rehearsal!.data = picked);
      _selectTime(context);
    }
  }
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null){
        selectedTime = picked;

        String minute = picked.minute < 10 ? '0' + picked.minute.toString() : picked.minute.toString();
        String hour = picked.hour < 10 ? '0' + picked.hour.toString() : picked.hour.toString();

        setState(() => widget.dateController.text += " - ${hour}:${minute}");
        setState(() => widget.rehearsal!.data = new DateTime(widget.rehearsal!.data!.year, widget.rehearsal!.data!.month, widget.rehearsal!.data!.day, selectedTime.hour , selectedTime.minute));

      }

  }

  @override
  Widget build(BuildContext context) {

    final primaryColor = Theme.of(context).primaryColor;

    return ChangeNotifierProvider.value(
      value: widget.rehearsal,
      child: Scaffold(
        appBar: AppBar(
          title: widget.rehearsal != null
              ? Text("Ensaio")
              : Text(DateFormat('dd/MM/yyyy').format(widget.rehearsal!.data ?? DateTime.now())),
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
                        Padding(
                          padding: const EdgeInsets.all(6),
                          child:
                            Container(
                              width: 130,
                              child:
                                   DropdownButton<String>(
                                           value: widget.rehearsal!.type == null ? valueRehearsalTypeDropDownSelected : widget.rehearsal?.type,
                                           hint: Text('Tipo ensaio'),
                                           icon: const Icon(Icons.arrow_downward),
                                           iconSize: 24,
                                           elevation: 16,
                                           style: const TextStyle(color: Colors.lightBlue, fontSize: 17, fontWeight: FontWeight.bold,),
                                            underline: Container(
                                              height: 3,
                                              width: 1,
                                              color: Colors.lightBlue,
                                            ),
                                           onChanged: (String? newValue) {
                                             setState(() {
                                               valueRehearsalTypeDropDownSelected = newValue!;
                                               widget.rehearsal!.type = valueRehearsalTypeDropDownSelected;
                                             });
                                           },
                                           items: UserManager.isUserAdmin == true ? AppListPool.rehearsalTypes.map<DropdownMenuItem<String>>((String value) {
                                             return DropdownMenuItem<String>(
                                               value: value,
                                               child: Text(value),
                                             );
                                           }).toList() :

                                           [widget.rehearsal!.type].map<DropdownMenuItem<String>>((String? value) {
                                             return DropdownMenuItem<String>(
                                               value: value,
                                               child: Text(value!),
                                             );
                                           }).toList(),

                                         )
                              ),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(6),
                            child: Container(
                                      width: 170,
                                      child:
                                      GestureDetector(
                                        onTap: () {
                                          if(UserManager.isUserAdmin == true){
                                            _selectDate();
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
                                              if (widget.rehearsal!.data == null)
                                                return "Insira uma data para o ensaio";
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                    )
                        ),
                      ]
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
                            visible: widget.rehearsal?.data == null || widget.rehearsal!.data!.isAfter(DateTime.now()),
                            child:
                            GestureDetector(
                                      onTap: () {
                                                  if(widget.formKey.currentState!.validate()) {
                                                       widget.formKey.currentState!.save();
                                                  }
                                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => SongsServiceScreen.buildSongsRehearsalScreen(widget.rehearsal)));
                                      },
                              child: Icon(
                                (widget.rehearsal?.lstSongs == null || widget.rehearsal?.lstSongs!.length == 0) ? Icons.add_circle_sharp : Icons.edit_outlined,
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
                          itemCount: widget.rehearsal!.lstSongs == null ? 0 : widget.rehearsal!.lstSongs!.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return
                                Column(
                                    children: [
                                              Card(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(4)),
                                                    child: Container(
                                                        height: 55,
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
                                                                                widget.rehearsal!.lstSongs![index].nome ?? '',
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
                                                                      //todo retornar non safety
                                                                      Row(
                                                                        children: [
                                                                          Visibility(
                                                                            visible: StringUtils.isNotNUllNotEmpty(widget.rehearsal!.lstSongs![index].cifra ?? ''),
                                                                            child:
                                                                            Align(
                                                                              alignment: Alignment.topRight,
                                                                              child: GestureDetector(
                                                                                onTap: () => _launchChordsURL(widget.rehearsal!.lstSongs![index]),
                                                                                child: new Icon(Icons.piano, size: 29,)
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(width: 15),
                                                                          Text('Tom: ' + widget.rehearsal!.lstSongs![index].tom!,
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
                  Consumer<Rehearsal>(
                    builder: (_, rehearsal, __) {
                      return Visibility(
                                visible: UserManager.isUserAdmin ?? false,
                                //visible: rehearsal.data ?? .isAfter(DateTime.now()),
                                child:  RaisedButton(
                                        onPressed: () async {
                                          if (widget.formKey.currentState!.validate()) {
                                            context.read<RehearsalManager>().update(rehearsal);
                                            Navigator.of(context).pop();
                                            String predifiniedWhatsAppMessage = getPredifiniedWhatsAppMessage(widget.rehearsal);
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

  void _launchChordsURL(Song? song) async => await canLaunch(song?.cifra ?? '')
      ? await launch(song?.cifra ?? '')
      : throw 'Could not launch $song.cifra';

  String getPredifiniedWhatsAppMessage(Rehearsal? rehearsal) {
    return 'Ensaio em: ' + DateUtilsCustomized.convertDatePtBr(rehearsal?.data ?? DateTime.now()) + ', Tipo ensaio: ${rehearsal?.type ?? ''}.\nConsulte o App do Louvor para mais detalhes.' ;
  }

}
