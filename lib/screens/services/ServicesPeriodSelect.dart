import 'dart:core';

import 'package:flutter/material.dart';
import 'package:louvor_app/common/custom_drawer/custom_drawer.dart';
import 'package:louvor_app/screens/services/services_screen.dart';
import 'package:intl/intl.dart';

class ServicesPeriodSelect extends StatefulWidget {

  final DateTime initialDate;

  const ServicesPeriodSelect({Key key, this.initialDate}) : super(key: key);

  @override
  ServicesPeriodSelectState createState() => ServicesPeriodSelectState();

}

class ServicesPeriodSelectState extends State<ServicesPeriodSelect>{

  DateTime selectedDate;

  final List<String> listMounths = ['Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho', 'Julho','Agosto','Setembro','Outubro','Novembro','Dezembro'];

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

   setMounth(int index){
        DateTime dateMounth = new DateTime(selectedDate.year, index);
        setState(() {
          selectedDate = dateMounth;
        });
        Navigator.pop(context);
  }

  selectYear(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Ano", textAlign: TextAlign.center,),
          content: Container( // Need to use container to add size constraint.
            width: 300,
            height: 300,
            child: YearPicker(
              firstDate: DateTime(DateTime.now().year, 1),
              lastDate: DateTime(DateTime.now().year + 100, 1),
              selectedDate: selectedDate,
              onChanged: (DateTime dateTime) {
                setState(() {  selectedDate = dateTime; });
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
  }

  Widget setupAlertDialoadContainer() {
    return Container(
      height: 300.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: listMounths.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: GestureDetector(
                      onTap: () => setMounth(index+1),
                      child: Text(listMounths[index],
                        textAlign: TextAlign.center,
                      ),
                  )
          );
        },
      ),
    );
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
                                    padding: const EdgeInsets.all(100),
                                    child: Column(
                                              children: [
                                                          GestureDetector(
                                                            onTap: () { selectYear(); },
                                                            child: Text('Ano: ${selectedDate.year}',
                                                              style: Theme.of(context).textTheme.headline4,
                                                              textAlign: TextAlign.center,
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {showDialog(
                                                                                  context: context,
                                                                                  builder: (BuildContext context) {
                                                                                                            return AlertDialog(
                                                                                                              title: Text('Mês',
                                                                                                                           style: Theme.of(context).textTheme.headline4,
                                                                                                                           textAlign: TextAlign.center,
                                                                                                                          ),
                                                                                                              content: setupAlertDialoadContainer(),
                                                                                                            );
                                                                                  });
                                                                      ;
                                                                      },
                                                            child: Text('Mês: ${DateFormat('MMM').format(selectedDate)}',
                                                              style: Theme.of(context).textTheme.headline4,
                                                              textAlign: TextAlign.center,
                                                            ),
                                                          )

                                                //setMounth(),

                                              ],
                                          ),

                                  ),

                                 ]
                    )
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
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ServicesScreen.buildByMounth(selectedDate)));
                    },
                  ),
                ],
              )

    );
  }
}