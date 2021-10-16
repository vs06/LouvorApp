import 'dart:core';
import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:louvor_app/common/custom_drawer/custom_drawer.dart';
import 'package:louvor_app/helpers/app_list_pool.dart';
import 'package:louvor_app/helpers/date_utils.dart';
import 'package:louvor_app/models/service_manager.dart';
import 'package:louvor_app/screens/services/services_screen.dart';
import 'package:louvor_app/models/Service.dart';
import 'package:provider/provider.dart';


class ServicesMonthCreatorScreen extends StatefulWidget {

  DateTime _dateTime;

  ServicesMonthCreatorScreen(DateTime dateTime){
    this._dateTime = dateTime;
  }

  @override
  State<StatefulWidget> createState() {
    return ServicesMonthCreatorScreenState();
  }
}

class ServicesMonthCreatorScreenState extends State<ServicesMonthCreatorScreen> {

  String valueDaysOfWeekDropDownSelected = AppListPool.daysOfWeek[0];

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  TextEditingController timeController = TextEditingController();

  List<ServiceDTO> lst= [];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text('Criação cultos mês: ${DateUtils.mounthBr(widget._dateTime)}'),
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
                MaterialPageRoute(builder: (context) => ServicesScreen.buildByMonth(widget._dateTime));
              },
            );
          },
        ),
      ),
      body:
      Column(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(8),
              child : Column(
                  children: [
                    Card( shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)
                    ),
                      child: Container(
                        height: 170,
                        padding: const EdgeInsets.all(10),
                        child:
                        Center(
                          child:
                          Column(
                            children: <Widget>[
                              const SizedBox(width: 16,),
                              Row(
                                children: [
                                  Expanded(
                                    // flex: 5,
                                    child:
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                            children: [
                                              Text('Dia da Semana',
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w800,
                                                    color: Theme.of(context).primaryColor
                                                ),
                                              ),
                                            ]
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                                width: 140.0,
                                                child:
                                                DropdownButton<String>(
                                                  value: valueDaysOfWeekDropDownSelected,
                                                  icon: const Icon(Icons.arrow_downward),
                                                  iconSize: 24,
                                                  elevation: 16,
                                                  style: const TextStyle(color: Colors.deepPurple),
                                                  underline: Container(
                                                    height: 2,
                                                    color: Colors.lightBlue,
                                                  ),
                                                  onChanged: (String newValue) {
                                                    setState(() {
                                                      valueDaysOfWeekDropDownSelected = newValue;
                                                    });
                                                  },
                                                  items: AppListPool.daysOfWeek.map<DropdownMenuItem<String>>((String value) {
                                                    return DropdownMenuItem<String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                                )
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  Container(
                                            width: 140,
                                              child:
                                              TextFormField(
                                                onTap: () {
                                                  _selectTime(context);
                                                },
                                                readOnly: true,
                                                controller: timeController,
                                                decoration: InputDecoration(
                                                  labelText: "Horário",
                                                  border: InputBorder.none,
                                                  icon: Icon(Icons.access_time_sharp),
                                                ),
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                    ),
                                ],
                              ),
                              Center(
                                child:
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 2, // 20%
                                      child:
                                      Padding(
                                          padding: const EdgeInsets.all(20),
                                          child:
                                          Column(
                                              children: [
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          addServiceDTOList(valueDaysOfWeekDropDownSelected , timeController.text, widget._dateTime );
                                                        },
                                                        child: Icon(
                                                          Icons.add_circle_sharp,
                                                          color: Colors.lightBlue,
                                                          size: 40,
                                                        ),
                                                      )
                                                    ]
                                                ),
                                              ]
                                          )
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]
              )

          ),

          Row(
            children: [
              const SizedBox(width: 100),
              Text('Selecionados',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).primaryColor
                ),
              ),

              Transform.rotate(
                angle: 60 * pi / 40,
                child: IconButton(
                  icon: Icon(Icons.subdirectory_arrow_left , color: Colors.blue, size: 30, ),
                  onPressed: null,
                ),
              ),
            ],

          ),

          Expanded(
              flex: 4, // 40%
              child:
                ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: lst != null ? lst.length : 0,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      String dayFoWeek = lst[index].dayOfWeek;
                      return
                        Column(
                            children: <Widget>[
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)
                                ),
                                child: Container(
                                  height: 40,
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    children: <Widget>[
                                      const SizedBox(width: 16,),
                                      Column( children: <Widget>[
                                        Expanded(
                                          flex: 5,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [

                                                  Text( dayFoWeek +':  ',
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w800,
                                                      color: Colors.lightBlue,
                                                    ),
                                                  ),

                                                  Text( '${lst[index].timeOfDay}',
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w800,
                                                    ),
                                                  ),

                                                  Align(
                                                    alignment: Alignment.center,
                                                    child:
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          lst.removeWhere((e) => e.dayOfWeek == lst[index].dayOfWeek);
                                                        });
                                                      },
                                                      child:Icon(Icons.delete , color: Colors.blueGrey,),
                                                    ),
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
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              ServiceDTO.convert(lst).forEach((service) {
                service.save();
              });
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ServicesScreen.buildByMonth(widget._dateTime))
              );
            },
            icon: Icon(Icons.add, size: 10),
            label: Text("Adicionar selecionados"),
          ),
        ],
      )

    );

  }

  void addServiceDTOList(String valueDayOfWeekDropDownSelected, String timeOfDay, DateTime dateTimeExtractYearMonth) {
    var year = dateTimeExtractYearMonth.year;
    var month = dateTimeExtractYearMonth.month;
    var dayOfWeekAsNumber = AppListPool.daysOfWeek.indexWhere((element) => element == valueDayOfWeekDropDownSelected) +1;

    setState(() {
     lst.add(new ServiceDTO(valueDayOfWeekDropDownSelected, timeOfDay, year, month, dayOfWeekAsNumber));
   });

  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null){
      selectedTime = picked;

      String minute = picked.minute < 10 ? '0' + picked.minute.toString() : picked.minute.toString();
      String hour = picked.hour < 10 ? '0' + picked.hour.toString() : picked.hour.toString();

      setState(() => timeController.text = "${hour}:${minute}");

    }

  }

}

class ServiceDTO{

  String dayOfWeek;
  String timeOfDay;
  int year;
  int month;
  int dayOfWeekAsNumber;

  ServiceDTO(String dayOfWeek, String timeOfDay, year, month, dayOfWeekAsNumber){
    this.dayOfWeek = dayOfWeek;
    this.timeOfDay = timeOfDay;
    this.year = year;
    this.month = month;
    this.dayOfWeekAsNumber = dayOfWeekAsNumber;
  }

  static List<Service> convert(List<ServiceDTO> lstServiceDTO){
    List<Service> listService = [];

    if(lstServiceDTO.length == 0){
      return listService;
    }

    //Set que armazena os dias da semana (Como número 1 a 7) escolhidos
    Set<int> daysOfWeek = new Set();

    lstServiceDTO.forEach((serviceDTO) {
      if(!daysOfWeek.contains(serviceDTO.dayOfWeekAsNumber)){
        daysOfWeek.add(serviceDTO.dayOfWeekAsNumber);
      }
    });

    //Lista com dias a serem cadastrados
    List<DateTime> lstDayServices = new List();

    // Com base no ano e mês. Itero todos os dias do mês.
    int  daysCounter = 31;
    int month = lstServiceDTO[0].month;
    int year = lstServiceDTO[0].year;

    while(daysCounter>0){

      try {
        DateTime day = DateTime(year, month, daysCounter);
        var dayOfWeekAsNumber = DateUtils.figureOutDayOfWeekAsNumber(day);
        if(daysOfWeek.contains(dayOfWeekAsNumber)){
          lstDayServices.add(day);
        }

      } catch (e) {
        //Tratamento para mês com menos de 31 dias
        daysCounter = 0;
        break;
      }

      daysCounter--;
    }

    lstDayServices.forEach((day) {
      lstServiceDTO.forEach((serviceDTO) {
        if(serviceDTO.dayOfWeekAsNumber == DateUtils.figureOutDayOfWeekAsNumber(day)){
                    Service service = new Service();

                    int hour =  int. parse(serviceDTO.timeOfDay.substring(0,2)) ;
                    int minute = int. parse(serviceDTO.timeOfDay.substring(3,5));

                    service.data = new DateTime(day.year, day.month, day.day, hour, minute);
                    service.ativo = 'True';
                    service.lstSongs = new List();

                    listService.add(service);
        }
      });
    });

    //Se true, deu alguma coisa errada
    if(listService.length > 62){
      return [];
    }

    return listService;
  }

}
