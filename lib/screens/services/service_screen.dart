import 'package:flutter/material.dart';
import 'package:louvor_app/models/Song.dart';
import 'package:louvor_app/models/Service.dart';
import 'package:louvor_app/screens/songs/songs_service_screen.dart';
import 'package:provider/provider.dart';
import 'package:louvor_app/models/service_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:async';
//import 'package:syncfusion_flutter_calendar/calendar.dart';

class ServiceScreen extends StatefulWidget {
  final Service service;

  ServiceScreen(Service s) : service = s != null ? s.clone() : Service();

  ServiceScreen.buidSongs(this.service);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //CalendarController _controller = CalendarController();
  // @override
  // void initState() {
  //   super.initState();
  //   _controller = CalendarController();
  // }

  @override
  State<StatefulWidget> createState() {
    return ServiceScreenState();
  }
}

class ServiceScreenState extends State<ServiceScreen> {
  String _value = '';

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2021),
        lastDate: DateTime(2022));
    if (picked != null){
      //TODO  JOGAR A DATA NO CAMPO DO FOMULARIO
      setState(() => widget.service.data = picked.toString());
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
              : Text(widget.service.data),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: Form(
          key: widget.formKey,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    ElevatedButton.icon(
                      onPressed: _selectDate,
                      icon: Icon(Icons.calendar_today_outlined, size: 20),
                      label: Text("Data"),
                    ),
                    TextFormField(
                      initialValue: widget.service.data,
                      onSaved: (data) => widget.service.data = data,
                      decoration: const InputDecoration(
                        hintText: 'Data',
                        border: InputBorder.none,
                        labelText: 'Data',
                      ),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: primaryColor,
                      ),
                    ),
                    //SfCalendar(view: CalendarView.month,),
                    // TableCalendar(
                    //   initialCalendarFormat: CalendarFormat.month,
                    //   calendarStyle: CalendarStyle(
                    //       todayColor: Colors.blue,
                    //       selectedColor: Theme.of(context).primaryColor,
                    //       todayStyle: TextStyle(
                    //           fontWeight: FontWeight.bold,
                    //           fontSize: 22.0,
                    //           color: Colors.white)
                    //   ),
                    //   headerStyle: HeaderStyle(
                    //     centerHeaderTitle: true,
                    //     formatButtonDecoration: BoxDecoration(
                    //       color: Colors.brown,
                    //       borderRadius: BorderRadius.circular(22.0),
                    //     ),
                    //     formatButtonTextStyle: TextStyle(color: Colors.white),
                    //     formatButtonShowsNext: false,
                    //   ),
                    //   // startingDayOfWeek: StartingDayOfWeek.monday,
                    //   // onDaySelected: (date, events) {
                    //   //   print(date.toUtc());
                    //   // },
                    //   builders: CalendarBuilders(
                    //     selectedDayBuilder: (context, date, events) => Container(
                    //         margin: const EdgeInsets.all(5.0),
                    //         alignment: Alignment.center,
                    //         decoration: BoxDecoration(
                    //             color: Theme.of(context).primaryColor,
                    //             borderRadius: BorderRadius.circular(8.0)),
                    //         child: Text(
                    //           date.day.toString(),
                    //           style: TextStyle(color: Colors.white),
                    //         )),
                    //     todayDayBuilder: (context, date, events) => Container(
                    //         margin: const EdgeInsets.all(5.0),
                    //         alignment: Alignment.center,
                    //         decoration: BoxDecoration(
                    //             color: Colors.blue,
                    //             borderRadius: BorderRadius.circular(8.0)),
                    //         child: Text(
                    //           date.day.toString(),
                    //           style: TextStyle(color: Colors.white),
                    //         )),
                    //   ),
                    //   calendarController: _controller,
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: TextFormField(
                        initialValue: widget.service.dirigente,
                        onSaved: (dr) => widget.service.dirigente = dr,
                        decoration: const InputDecoration(
                          hintText: 'Dirigente',
                          border: InputBorder.none,
                          labelText: 'Dirigente',
                        ),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Insira as músicas aqui +',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (widget.formKey.currentState.validate()) {
                                widget.formKey.currentState.save();
                              }
                              Service s2 = widget.service;
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => SongsServiceScreen
                                      .buildSongsServiceScreen(
                                          widget.service)));
                            },
                            child: Icon(
                              Icons.add,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
//*******************************************************************************************************************
                    Padding(
                      padding: const EdgeInsets.only(top: 150),
                      child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: widget.service.lstSongs == null
                              ? 0
                              : widget.service.lstSongs.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Expanded(
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)),
                                child: Container(
                                  height: 60,
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
//*******************************************************************************************************************
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
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _launchChordsURL(Song song) async => await canLaunch(song.cifra)
      ? await launch(song.cifra)
      : throw 'Could not launch $song.cifra';
}
