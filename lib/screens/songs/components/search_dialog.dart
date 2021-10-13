import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:louvor_app/models/tag_manager.dart';
import 'package:louvor_app/screens/songs/components/song_search_dto.dart';

class SearchDialog extends StatefulWidget {

  const SearchDialog(this.songSearchDTO);

  final SongSearchDTO songSearchDTO;

  @override
  State<StatefulWidget> createState() {
    return SearchDialogState();
  }

}

class SearchDialogState extends State<SearchDialog>{

  var tagsFiltered = [];
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  String currentText = "";
  List<String> suggestions = TagManager.allTagsAsStrings();
  SimpleAutoCompleteTextField simpleAutoCompleteTags;

  //Controle inicial filters: Dinâmica
  bool semPalmas = false;
  bool comPalmas = false;

  @override
  Widget build(BuildContext context) {

    _FirstPageState();

    return Stack(
      children: <Widget>[
        Positioned(
          top: 2,
          left: 4,
          right: 4,
          child:
                  Card(
                    child: Column(
                      children: <Widget>[

                        Row(
                          children: [
                             IconButton(
                              icon: Icon(Icons.arrow_back),
                              color: Colors.grey[700],
                              onPressed: (){
                                Navigator.of(context).pop();
                              },
                            ),

                            Padding(
                              padding: EdgeInsets.only(top: 8, left: 35, bottom: 6),
                              child:
                                      Text('Musícas busca refinada',
                                        style: TextStyle(fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.lightBlue,),
                                      ),
                            ),

                            Padding(
                              padding: EdgeInsets.only(top: 8, left: 15, bottom: 6),
                              child: IconButton(
                                        icon: Icon(Icons.filter_alt),
                                        color: Colors.grey[700],
                                        onPressed: (){
                                          Navigator.of(context).pop();
                                        },
                                      ),
                            )
                          ],
                        ),

                        Padding(
                            padding: EdgeInsets.only(top: 5, left: 12, bottom: 6),
                            child:
                                    Row(
                                        children: [
                                              Container(
                                                  width: 60,
                                                  child:Text('Nome\n  ou\nLetra',
                                                    style: TextStyle(fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.lightBlue,),
                                                  ),
                                              ),
                                              Container(
                                                width: 240,
                                                child: TextFormField(
                                                          initialValue: widget.songSearchDTO.search,
                                                          textInputAction: TextInputAction.search,
                                                          autofocus: true,
                                                          decoration: InputDecoration(
                                                            //border: InputBorder.none,
                                                            border: const OutlineInputBorder(),
                                                            contentPadding: const EdgeInsets.symmetric(vertical: 15),
                                                            hintText: ' busca',
                                                            //labelText: 'digite',
                                                          ),
                                                          onFieldSubmitted: (text){
                                                            widget.songSearchDTO.search = text;
                                                            Navigator.of(context).pop(text);
                                                          },
                                                        ),
                                              )
                                          ]
                                        )
                        ),

                        Padding(
                            padding: EdgeInsets.only(top: 5, left: 12, bottom: 6),
                            child:
                            Row(
                                children: [
                                  Container(
                                    width: 60,
                                    child:Text('Tag\'s',
                                      style: TextStyle(fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.lightBlue,),
                                    ),
                                  ),
                                  Container(
                                    width: 240,
                                    child: simpleAutoCompleteTags
                                  )
                                ]
                            )
                        ),

                        Row(
                          children: [
                            Container(
                                height: tagsFiltered.length > 0 ? 70 : 5,
                                width: 320,
                                  child: GridView.builder(
                                    itemCount: tagsFiltered.length,
                                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      childAspectRatio: 2,
                                    ),
                                    itemBuilder: (BuildContext context,
                                        int index) {
                                      return Center(
                                          child:
                                          InputChip(
                                            padding: EdgeInsets.only(top: 1, left: 10),
                                            label: Text(tagsFiltered[index],
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            backgroundColor: Colors.lightBlue,
                                            deleteIconColor: Colors.white,
                                            onDeleted: () {
                                              setState(() {
                                                tagsFiltered.removeWhere((e) => e == tagsFiltered[index]);
                                              });
                                            },
                                          )

                                      );
                                    },
                                  ),
                            )
                          ],
                        ),

                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10, left: 10, bottom: 5),
                              child:
                              Text('Dinâmica',
                                style: TextStyle(fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.lightBlue,),
                              ),
                            ),
                          ],
                        ),

                        Padding(
                        padding: EdgeInsets.only(left: 10, bottom: 10),
                          child: Container(
                                      width: 320,
                                      child: Row(
                                        children: [
                                          Container(
                                              width: 160,
                                              child:
                                              Column(
                                                children: [
                                                  SwitchListTile(
                                                      title: const Text('Sem Palma',
                                                        style: TextStyle(fontSize: 15,),),
                                                      value: semPalmas,
                                                      onChanged: (bool value) {
                                                        setState(() {
                                                          semPalmas = value;
                                                          if (semPalmas) {
                                                            if (!widget.songSearchDTO.palmasFilter.contains('semPalmas')) {
                                                              widget.songSearchDTO.palmasFilter.add('semPalmas');
                                                            }
                                                          } else {
                                                            if (widget.songSearchDTO.palmasFilter.contains('semPalmas')) {
                                                              widget.songSearchDTO.palmasFilter.removeWhere((element) => element == 'semPalmas');
                                                            }
                                                          }
                                                        });
                                                      }
                                                    //,secondary: const Icon(Icons.timelapse),
                                                  ),
                                                ],
                                              )
                                          ),
                                          Container(
                                              width: 160,
                                              child:
                                              Column(
                                                  children: [
                                                    SwitchListTile(
                                                        title: const Text('Com Palmas',
                                                          style: TextStyle(fontSize: 15,),),
                                                        value: comPalmas,
                                                        onChanged: (bool value) {
                                                          setState(() {
                                                            comPalmas = value;
                                                            if (comPalmas) {
                                                              if (!widget.songSearchDTO.palmasFilter.contains('comPalmas')) {
                                                                widget.songSearchDTO.palmasFilter.add('comPalmas');
                                                              }
                                                            } else {
                                                              if (widget.songSearchDTO.palmasFilter.contains('comPalmas')) {
                                                                widget.songSearchDTO.palmasFilter.removeWhere((element) => element == 'comPalmas');
                                                              }
                                                            }

                                                          });
                                                        }
                                                      //,secondary: const Icon(Icons.timelapse),
                                                    ),
                                                  ]
                                              )
                                          ),
                                        ],
                                      )
                                  ),
                        )

                      ],
                    ),
                  ),
        )
      ],
    );
  }

  _FirstPageState() {
    simpleAutoCompleteTags = SimpleAutoCompleteTextField(
      key: key,
      style: TextStyle(color: Colors.blueGrey, fontSize: 16),
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        hintText: ' busca',
        //labelText: 'digite',
      ),
      suggestions: suggestions,
      textChanged: (text) => currentText = text,
      clearOnSubmit: true,
      textSubmitted: (text) =>
          setState(() {
            if (text != "") {
              print(text);
              tagsFiltered.add(text);
            }
          }),
    );
  }

}