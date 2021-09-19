import 'package:flutter/material.dart';
import 'package:louvor_app/models/Song.dart';
import 'package:louvor_app/models/Service.dart';
import 'package:louvor_app/screens/songs/songs_service_screen.dart';
import 'package:provider/provider.dart';
import 'package:louvor_app/models/service_manager.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:syncfusion_flutter_calendar/calendar.dart';

class ServiceScreen extends StatelessWidget {

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
                child:
                Column(
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
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: primaryColor,),
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
                        initialValue: service.dirigente,
                        onSaved: (dr) => service.dirigente = dr,
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
                              if (formKey.currentState.validate()) {
                                  formKey.currentState.save();
                              }
                              Service s2 = service;
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => SongsServiceScreen.buildSongsServiceScreen(service))
                              );
                            },
                            child: Icon(Icons.add, color: Colors.blueGrey,),
                          ),
                        ],
                      ),
                    ),
//*******************************************************************************************************************
                    Padding(
                      padding: const EdgeInsets.only(top: 150),
                      child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: service.lstSongs.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Expanded(
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)
                                ),
                                child: Container(
                                  height: 60,
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
                                                Flexible(
                                                  child: Text(
                                                    service.lstSongs[index].nome,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w800,
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment: Alignment.topRight,
                                                  child: GestureDetector(
                                                    onTap: () => _launchChordsURL(service.lstSongs[index]),
                                                    child: Icon(Icons.straighten_rounded, color: Colors.blueGrey,),
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
                          }
                      ),
                    ),
//*******************************************************************************************************************
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

  void _launchChordsURL(Song song) async =>
      await canLaunch(song.cifra) ? await launch(song.cifra) : throw 'Could not launch $song.cifra';

}