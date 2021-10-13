import 'package:flutter/material.dart';

class DialogUtils{

 static Future<void> alert(context, String alertTitle, String alertMessage, String messageConfirm) async {


    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(alertTitle),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                //Text('É necessário informar a dinâmica da música.'),
                Text(alertMessage),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(messageConfirm),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}