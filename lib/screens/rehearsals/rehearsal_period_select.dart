import 'dart:core';

import 'package:flutter/material.dart';
import 'package:louvor_app/common/custom_drawer/custom_drawer.dart';
import 'package:louvor_app/helpers/app_list_pool.dart';
import 'package:louvor_app/helpers/date_utils.dart';
import 'package:louvor_app/screens/rehearsals/rehearsals_screen.dart';
import 'package:louvor_app/screens/services/services_screen.dart';
import 'package:intl/intl.dart';

class RehearsalsPeriodSelect extends StatefulWidget {

  final DateTime initialDate;

  const RehearsalsPeriodSelect({Key key, this.initialDate}) : super(key: key);

  @override
  RehearsalsPeriodSelectState createState() => RehearsalsPeriodSelectState();

}

class RehearsalsPeriodSelectState extends State<RehearsalsPeriodSelect>{

  DateTime selectedDate;

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
        itemCount: AppListPool.mounths.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: GestureDetector(
                      onTap: () => setMounth(index+1),
                      child: Text(AppListPool.mounths[index],
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
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            );
          },
        ),
      ),
      body: Center(
                child:
                    Container(
                      width: 350,
                        child:
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(90, 230, 50, 100),
                                    child: Column(
                                              children: [
                                                          GestureDetector(
                                                            onTap: () { selectYear(); },
                                                            child: Row(
                                                                      children: [
                                                                                Text('Ano: ',
                                                                                  style: Theme.of(context).textTheme.headline4,
                                                                                  textAlign: TextAlign.center,
                                                                                ),
                                                                                Text(selectedDate.year.toString(),
                                                                                  style: TextStyle(fontSize: 40, color: Colors.lightBlue, fontWeight: FontWeight.bold),
                                                                                  textAlign: TextAlign.center,
                                                                                ),
                                                                      ],
                                                                    )
                                                          ),
                                                          GestureDetector(
                                                            onTap: () { showDialog(
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
                                                                        },
                                                            child: Row(
                                                                        children: [
                                                                                      Text('Mês: ',
                                                                                        style: Theme.of(context).textTheme.headline4,
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                      Text( DateUtils.mounthBr(selectedDate),
                                                                                        style: TextStyle(fontSize: 40, color: Colors.lightBlue, fontWeight: FontWeight.bold),
                                                                                        textAlign: TextAlign.center,
                                                                                      ),

                                                                                    ],
                                                                      )
                                                          )
                                              ],
                                          ),
                                  ),
                    )
                ),
      floatingActionButton:
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    child: Icon(
                        Icons.search,
                        size: 30,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => RehearsalsScreen.buildByMonth(selectedDate)));
                    },
                  ),
                ],
              )

    );
  }
}