import 'package:flutter/material.dart';

class DropDownListString extends StatefulWidget {

  final List<String>? listOptions;
  String? ref;

  DropDownListString(this.listOptions);

  @override
  State<DropDownListString> createState() => _DropDownListStringState();


}

class _DropDownListStringState extends State<DropDownListString> {

  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.lightBlue,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: widget.listOptions!.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
