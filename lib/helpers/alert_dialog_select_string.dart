
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertDialogSelectString extends Future<Team> showDialog<T>({

  final List<String> listString;
  final String listTitle;

  String teste;

  AlertDialogSelectString(this.listString, this.listTitle);

  // static Future<String> Teste(List<String> listString, String listTitle) async {
  //   await AlertDialogSelectString._(listString, listTitle);
  //   return listString[_indexSelectedItem];
  // }

  @override
  State<StatefulWidget> createState() => AlertDialogSelectStringState();

}

class AlertDialogSelectStringState extends State<AlertDialogSelectString>{

    @override
    Widget build(BuildContext context) {
      createContainerAlertDialog();
    }

    Future<Widget> createContainerAlertDialog() {
    return  showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                          title: Text(
                                    widget.listTitle,
                                    style: Theme.of(context).textTheme.headline4,
                                    textAlign: TextAlign.center,
                                  ),
                  content: _generateContainer(),
                );
              },
            );
  }

  Container _generateContainer(){

   return Container(
          height: 300.0,
          width: 300.0,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.listString.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                  title: GestureDetector(onTap: () {
                                                      //AlertDialogSelectString._indexSelectedItem = index+1;
                                                      Navigator.pop(context);
                                                   } ,
                    child: Text(
                             widget.listString[index],
                             textAlign: TextAlign.center,
                           ),

                  )
              );
            },
          ),
        );

  }

}