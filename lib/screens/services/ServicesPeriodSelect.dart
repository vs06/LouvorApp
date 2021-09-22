import 'dart:core';

import 'package:flutter/material.dart';
import 'package:louvor_app/common/custom_drawer/custom_drawer.dart';
import 'package:louvor_app/screens/services/services_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
//import 'package:month_picker_dialog/month_picker_dialog.dart';

class ServicesPeriodSelect extends StatefulWidget {

  final DateTime initialDate;

  const ServicesPeriodSelect({Key key, this.initialDate}) : super(key: key);

  @override
  ServicesPeriodSelectState createState() => ServicesPeriodSelectState();

}

class ServicesPeriodSelectState extends State<ServicesPeriodSelect>{

  DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  // (
  // context: context,
  // firstDate: DateTime(DateTime.now().year - 1, 5),
  // lastDate: DateTime(DateTime.now().year + 1, 9),
  // initialDate: selectedDate ?? widget.initialDate,
  // locale: Locale("es"),
  // ).then((date) {
  // if (date != null) {
  // setState(() {
  // selectedDate = date;
  // });
  // }
  // });
  //

  Future _showMonthPicker() async {
    DateTime picked = await showDatePicker(context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2021),
        lastDate: DateTime(2050)
    );
    if (picked != null){
      // setState(() => selectedDate = picked);
      // setState(() => _dateController.text = "${picked.toLocal().day}/${picked.toLocal().month}/${picked.toLocal().year}");
      // setState(() => widget.service.data = selectedDate);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text('Seleção Mês'),
        centerTitle: true,
      ),
      body: Center(
                child:
                    Column(
                       children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 150),
                                    child:
                                        FloatingActionButton(
                                          child: Icon(
                                              Icons.calendar_today
                                          ),
                                          onPressed: () {
                                            _showMonthPicker();
                                          },
                                        ),

                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child:
                                      Text(
                                        'Ano: ${selectedDate?.year}\nMês: ${DateFormat('MMM').format(selectedDate)}',
                                        style: Theme.of(context).textTheme.headline4,
                                        textAlign: TextAlign.center,
                                      ),
                                  )

                       ]
                    ),
                ),
      floatingActionButton:
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    child: Icon(
                        Icons.send
                    ),
                    onPressed: () {
                      _showMonthPicker();
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ServicesScreen.buildByMounth(selectedDate)));
                    },
                  ),
                ],
              )

    );
  }
}
