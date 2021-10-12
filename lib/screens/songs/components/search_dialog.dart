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
                        TextFormField(
                          initialValue: widget.songSearchDTO.search,
                          textInputAction: TextInputAction.search,
                          autofocus: true,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 15),
                              prefixIcon: IconButton(
                                icon: Icon(Icons.arrow_back),
                                color: Colors.grey[700],
                                onPressed: (){
                                  Navigator.of(context).pop();
                                },
                              )
                          ),
                          onFieldSubmitted: (text){
                            widget.songSearchDTO.search = text;
                            Navigator.of(context).pop(text);
                          },
                        ),

                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 1, left: 10, bottom: 6),
                              child:
                              Text('Tag\'s',
                                style: TextStyle(fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.lightBlue,),
                              ),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Container(
                                width: 320,
                                child:
                                Column(
                                  children: [
                                      Container(
                                        height: 30,
                                        child: simpleAutoCompleteTags,
                                      ),
                                    Row(
                                      children: [
                                        Container(
                                            height: tagsFiltered.length > 0 ? 70 : 5,
                                            width: 320,
                                            // child:
                                            // Scrollbar(
                                            //   isAlwaysShown: true,
                                            //   controller: _scrollTagsController,
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
                                                        padding: EdgeInsets.all(
                                                            2.0),
                                                        label: Text(tagsFiltered[index],
                                                          style: TextStyle(
                                                              color: Colors.white),
                                                        ),
                                                        backgroundColor: Colors.lightBlue,
                                                        deleteIconColor: Colors.white,
                                                        onDeleted: () {
                                                          setState(() {
                                                            tagsFiltered.removeWhere((e) =>
                                                            e == tagsFiltered[index]);
                                                          });
                                                        },
                                                      )

                                                  );
                                                },
                                              ),
                                            //)
                                        )
                                      ],
                                    )
                                  ],
                                )
                            ),
                          ],
                        ),


                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 1, left: 10),
                              child:
                              Text('Dinâmica',
                                style: TextStyle(fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.lightBlue,),
                              ),
                            ),
                          ],
                        ),

                        Container(
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
      style: TextStyle(color: Colors.black, fontSize: 16.0),
      decoration: InputDecoration(
        hintText: "  filtro por tag",
        hintStyle: TextStyle(color: Colors.black),
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