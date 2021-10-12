import 'package:flutter/material.dart';
import 'package:louvor_app/models/Song.dart';
import 'package:louvor_app/models/Tag.dart';
import 'package:louvor_app/models/tag_manager.dart';
import 'package:provider/provider.dart';
import 'package:louvor_app/models/song_manager.dart';
import 'package:louvor_app/models/user_manager.dart';
import 'package:louvor_app/screens/loading_screen.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:url_launcher/url_launcher.dart';


class SongScreen extends StatefulWidget {

  final Song song;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  SongScreen(Song s) : song = s != null ? s.clone() : Song();

  @override
  State<StatefulWidget> createState() {
    return SongScreenState();
  }

}
class SongScreenState extends State<SongScreen> {

  List<String> added = [];
  String currentText = "";
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();

  TextEditingController textEditingController;

  //Controle de andamento das musicas
  bool semPalmas = false;
  bool comPalmas = false;

  List<String> suggestions = TagManager.allTagsAsStrings();

  SimpleAutoCompleteTextField simpleAutoCompleteTags;
  bool showWhichErrorText = false;

  ScrollController _scrollTagsController = ScrollController();

  @override
  Widget build(BuildContext context) {
    if (added.length == 0) {
      added = widget.song != null ? tagsToListString(widget.song.tags) : [];
    }

    comPalmas = widget.song.palmas.contains('comPalmas');
    semPalmas = widget.song.palmas.contains('semPalmas');

    final primaryColor = Theme.of(context).primaryColor;

    _FirstPageState();

    return ChangeNotifierProvider.value(
      value: widget.song,
      child: Scaffold(
        appBar: AppBar(
          title: widget.song != null ? Text("Música") : Text(widget.song.nome),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: Form(
          key: widget.formKey,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[

                    Padding(
                        padding: const EdgeInsets.only(top: 1),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              child: Text('Nome: ',
                                  style: TextStyle(fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,)
                              ),
                            ),
                            Container(
                              width: 260,
                              child:
                              TextFormField(
                                initialValue: widget.song.nome,
                                onSaved: (titulo) => widget.song.nome = titulo,
                                decoration: const InputDecoration(
                                  // hintText: 'Nome',
                                  border: InputBorder.none,
                                  //labelText: 'Nome',
                                ),
                                style: TextStyle(fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey,),
                              ),
                            )
                          ],
                        )
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 1),
                        child: Row(children: [
                          Container(
                            width: 60,
                            child: Text('Artista: ',
                                style: TextStyle(fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,)
                            ),
                          ),
                          Container(
                            width: 260,
                            child:
                            TextFormField(
                              initialValue: widget.song.artista,
                              onSaved: (tb) => widget.song.artista = tb,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              style: TextStyle(fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey,),
                            ),
                          )
                        ],
                        )
                    ),
                    Row(
                      children: [

                        Container(
                          width: 70,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 0, bottom: 4, left: 2),
                            child: TextFormField(
                              initialValue: widget.song.tom,
                              onSaved: (tema) => widget.song.tom = tema,
                              decoration: const InputDecoration(
                                hintText: 'Tom',
                                border: InputBorder.none,
                                labelText: 'Tom',
                              ),
                              style: TextStyle(fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,),
                            ),
                          ),
                        ),
                        Container(
                          width: 240,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 0, bottom: 2),
                            child: TextFormField(
                              initialValue: widget.song.letra,
                              onSaved: (tags) => widget.song.letra = tags,
                              decoration: const InputDecoration(
                                hintText: 'Letra',
                                border: InputBorder.none,
                                labelText: 'Letra',
                              ),
                              style: TextStyle(fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,),
                            ),
                          ),
                        ),
                      ],
                    ),

                    Text('Tag\'s',
                      style: TextStyle(fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,),
                    ),
                    Row(
                      children: [
                        Container(
                            width: 320,
                            child:
                            Column(
                              children: [
                                Visibility(
                                  visible: UserManager.isUserAdmin,
                                  child: Container(
                                    height: 35,
                                    child: Center(
                                      child: simpleAutoCompleteTags,),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                        height: added.length > 0 ? 70 : 5,
                                        width: 320,
                                        child:
                                        Scrollbar(
                                          isAlwaysShown: true,
                                          controller: _scrollTagsController,
                                          child: GridView.builder(
                                            itemCount: added.length,
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
                                                    label: Text(added[index],
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    backgroundColor: primaryColor,
                                                    deleteIconColor: Colors.white,
                                                    onDeleted: () {
                                                      setState(() {
                                                        added.removeWhere((e) =>
                                                        e == added[index]);
                                                      });
                                                    },
                                                  )

                                              );
                                            },
                                          ),
                                        )
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
                        Center(child: Padding(
                          padding: EdgeInsets.only(top: 1),
                          child:
                          Text('Dinâmica',
                            style: TextStyle(fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,),
                          ),
                        ),
                        ),
                      ],
                    ),

                    Container(
                        width: 160,
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
                                              if (!widget.song.palmas.contains('semPalmas')) {
                                                widget.song.palmas += 'semPalmas';
                                              }
                                            } else {
                                              if (widget.song.palmas.contains('semPalmas')) {widget.song.palmas = widget.song.palmas.replaceAll('semPalmas', '');
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
                                                if (!widget.song.palmas.contains('comPalmas')) {
                                                  widget.song.palmas += 'comPalmas';
                                                }
                                              } else {
                                                if (widget.song.palmas.contains(
                                                    'comPalmas')) {
                                                  widget.song.palmas = widget.song.palmas.replaceAll('comPalmas', '');
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


//----------------------------------------------------------------------------------Aqui------------------------------------------------------------------------
                    // Row(
                    //
                    //   // decoration: BoxDecoration(
                    //   //   border: Border(
                    //   //     left: BorderSide(width: 2.0, color: Colors.blueGrey ),
                    //   //   ),
                    //   // ),
                    //   children: [
                    //     Container(
                    //       decoration: BoxDecoration(
                    //         border: Border(
                    //           top: BorderSide(width: 2.0, color: Colors.blueGrey ),
                    //         ),
                    //       ),
                    //       width: 160,
                    //       child:
                    //           Column(
                    //             children: [
                    //                   Padding(
                    //                       padding:  EdgeInsets.only(top: 1),
                    //                       child:
                    //                           Text('Dinâmica',
                    //                             style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: primaryColor,),
                    //                           ),
                    //                   ),
                    //                   SwitchListTile(
                    //                     title: const Text('Sem Palma'),
                    //                     value: semPalmas,
                    //                     onChanged: (bool value) {
                    //                       setState(() {
                    //                         semPalmas = value;
                    //                         if(semPalmas){
                    //                           if(!widget.song.palmas.contains('semPalmas')){
                    //                             widget.song.palmas += 'semPalmas';
                    //                           }
                    //                         }else{
                    //                           if(widget.song.palmas.contains('semPalmas')){
                    //                             widget.song.palmas = widget.song.palmas.replaceAll('semPalmas', '');
                    //                           }
                    //                         }
                    //
                    //                       });
                    //                     }
                    //                    //,secondary: const Icon(Icons.timelapse),
                    //                   ),
                    //                   SwitchListTile(
                    //                     title: const Text('Com Palmas'),
                    //                     value: comPalmas,
                    //                     onChanged: (bool value) {
                    //                       setState(() {
                    //                         comPalmas = value;
                    //                         if(comPalmas){
                    //                           if(!widget.song.palmas.contains('comPalmas')){
                    //                             widget.song.palmas += 'comPalmas';
                    //                           }
                    //                         }else{
                    //                           if(widget.song.palmas.contains('comPalmas')){
                    //                             widget.song.palmas = widget.song.palmas.replaceAll('comPalmas', '');
                    //                           }
                    //                         }
                    //                       });
                    //                     }
                    //                     //,secondary: const Icon(Icons.timelapse),
                    //                   ),
                    //             ],
                    //           )
                    //     ),
                    //     Container(
                    //       decoration: BoxDecoration(
                    //         border: Border(
                    //           top: BorderSide(width: 2.0, color: Colors.blueGrey ),
                    //         ),
                    //       ),
                    //       width: 160,
                    //       child:
                    //         Column(
                    //           children: [
                    //
                    //             Padding(padding:  EdgeInsets.only(bottom: 10),
                    //                     child: Text('Tag\'s',
                    //                               style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: primaryColor,),
                    //                             ),
                    //             ),
                    //
                    //             Container(
                    //               height: 25,
                    //               child: Center(child: simpleAutoCompleteTags,) ,
                    //             ),
                    //             Row(
                    //               children: [
                    //                       Padding(padding: const EdgeInsets.all(4),
                    //                       child:
                    //                             Container(
                    //                               height: 100,
                    //                               child:
                    //                               Visibility(
                    //                                 visible: UserManager.isUserAdmin,
                    //                                 child:
                    //                                 Text('${quebraListaKeyWords(added)}'
                    //                                     ,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: primaryColor,)
                    //                                 ),
                    //                               ),
                    //                             )
                    //                       )
                    //               ],
                    //             )
                    //           ],
                    //         )
                    //     ),
                    //   ],
                    // ),
//----------------------------------------------------------------------------------Aqui fim------------------------------------------------------------------------
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: TextFormField(
                        initialValue: widget.song.cifra,
                        onSaved: (texto) => widget.song.cifra = texto,
                        decoration: InputDecoration(
                          prefixIcon: GestureDetector( onTap: _launchChordsURL,
                                                       child:
                                                       Icon(Icons.straighten_rounded,
                                                         color: (widget.song.cifra != null && widget.song.cifra != '') ? primaryColor : Colors.blueGrey,
                                                       )
                                                     ) ,
                          border: const OutlineInputBorder(),
                          filled: true,
                          hintText: 'Link cifra',
                          labelText: 'Link cifra',
                        ),
                        onChanged: (value) {
                          widget.song.cifra = value;
                        },
                        maxLines: 2,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: TextFormField(
                        initialValue: widget.song.videoUrl,
                        onSaved: (texto) => widget.song.videoUrl = texto,
                        decoration: InputDecoration(
                          prefixIcon: GestureDetector( onTap:_launchVideoURL,
                                                        child:
                                                          Icon(Icons.ondemand_video,
                                                              color: (widget.song.videoUrl != null && widget.song.videoUrl != '') ?  primaryColor : Colors.blueGrey
                                                          ),
                                                     ) ,
                          border: const OutlineInputBorder(),
                          filled: true,
                          hintText: 'Link vídeo',
                          labelText: 'Link vídeo',
                        ),
                        onChanged: (value) {
                          widget.song.videoUrl = value;
                        },
                        maxLines: 2,
                      ),
                    ),

                    Consumer<Song>(
                      builder: (_, song, __) {
                        return Visibility(
                            visible: UserManager.isUserAdmin,
                            child: RaisedButton(
                              onPressed: () async {
                                if (isValidateDinamicaFill()) {
                                  applyTags(song);
                                  if (widget.formKey.currentState.validate()) {
                                    widget.formKey.currentState.save();
                                    await song.save();
                                    context.read<SongManager>().update(song);
                                    Navigator.of(context).pop();
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) =>
                                            LoadingScreen()));
                                  }
                                } else {
                                  _PalmasDialog();
                                }
                              },
                              textColor: Colors.white,
                              color: primaryColor,
                              disabledColor: primaryColor.withAlpha(100),
                              child: const Text(
                                'Salvar',
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ));
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

  String quebraListaKeyWords(List<String> lst) {
    String retKeyWords = '';
    if (lst == null) {
      return retKeyWords;
    }

    int count = 0;
    lst.forEach((element) {
      count++;
      retKeyWords += element + ';';

      if (count == 2) {
        retKeyWords += '\n';
        count = 0;
      }
    });
    return retKeyWords;
  }

  _FirstPageState() {
    simpleAutoCompleteTags = SimpleAutoCompleteTextField(
      key: key,
      //decoration: new InputDecoration( border: const OutlineInputBorder(), ),
      //controller: TextEditingController(text: "Palavras chave"),
      style: TextStyle(color: Colors.black, fontSize: 16.0),
      decoration: InputDecoration(
        hintText: "  adicione uma tag",
        hintStyle: TextStyle(color: Colors.black),
      ),
      suggestions: suggestions,
      textChanged: (text) => currentText = text,
      clearOnSubmit: true,
      textSubmitted: (text) =>
          setState(() {
            if (text != "") {
              print(text);
              added.add(text);
            }
          }),
    );
  }

  void applyTags(Song song) {
    //persiste novas tags
    added.forEach((addedItem) {
      if (!TagManager.allTagsAsStrings().contains(addedItem)) {
        context.read<TagManager>().update(Tag.newTag(addedItem));
      }
    });

    if (song.tags == null) {
      song.tags = '';
    }

    added.forEach((tag) {
      song.tags += tag + ';';
    });
  }

  List<String> tagsToListString(String tags) {
    List<String> tagList = [];

    int posicao = 0;

    while (tags.indexOf(';', posicao) != -1) {
      var index = tags.indexOf(';', posicao);
      var tag = tags.substring(posicao, index);
      tagList.add(tag);
      posicao = index + 1;
    }

    return tagList;
  }

  Future<void> _PalmasDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Campo obirgatório.'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('É necessário informar a dinâmica da música.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  bool isValidateDinamicaFill() {
    return !(!semPalmas && !comPalmas);
  }

  void _launchVideoURL() async =>
      await canLaunch(widget.song.videoUrl) ? await launch(widget.song.videoUrl) : throw 'Could not launch $widget.song.videoUrl';

  void _launchChordsURL() async =>
      await canLaunch(widget.song.cifra) ? await launch(widget.song.cifra) : throw 'Could not launch $widget.song.cifra';
}
