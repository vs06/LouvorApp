import 'package:flutter/material.dart';
import 'package:louvor_app/helpers/dialog_utils.dart';
import 'package:louvor_app/models/Song.dart';
import 'package:louvor_app/models/Tag.dart';
import 'package:louvor_app/models/tag_manager.dart';
import 'package:provider/provider.dart';
import 'package:louvor_app/models/song_manager.dart';
import 'package:louvor_app/models/user_manager.dart';
import 'package:louvor_app/helpers/loading_screen.dart';
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

    bool toggleActive = widget.song.ativo.toUpperCase() == 'TRUE';

    if(widget.song.palmas == null){
      widget.song.palmas = '';
    }

    if(widget.song.tags == null){
      widget.song.tags = '';
    }

    comPalmas = widget.song.palmas.contains('comPalmas');
    semPalmas = widget.song.palmas.contains('semPalmas');

    final primaryColor = Theme.of(context).primaryColor;

    List<String> tagsLst = tagsToListString(widget.song.tags);

    _firstPageState();

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
                              width: 220,
                              child:
                              TextFormField(
                                enabled: UserManager.isUserAdmin,
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
                            ),
                            Container(
                              width: 40,
                              child:
                              IconButton(
                                  icon: toggleActive
                                      ? Icon(Icons.check_circle, size: 25
                                      , color: Colors.blueAccent )
                                      : Icon(Icons.check_circle, size: 25, color:  Colors.blueGrey,),
                                  color: Colors.blueGrey,
                                  onPressed: () {
                                    if(UserManager.isUserAdmin){
                                      setState(() {
                                        toggleActive = !toggleActive;
                                      });
                                      widget.song.ativo = toggleActive ? 'TRUE' : 'FALSE';
                                    }
                                  }),
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
                              enabled: UserManager.isUserAdmin,
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
                              enabled: UserManager.isUserAdmin,
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
                              enabled: UserManager.isUserAdmin,
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

                  Padding(
                    padding: EdgeInsets.only(bottom: 25),
                    child: Row(
                              children: [
                                Text('Tag\'s:',
                                  style: TextStyle(fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,),
                                ),

                                Padding(padding: EdgeInsets.only(top: 5),
                                    child:  UserManager.isUserAdmin ?
                                    Container(
                                      height: 35,
                                      width: 200,
                                      child: Center(
                                        child: simpleAutoCompleteTags,),
                                    )
                                        :
                                    Visibility(
                                        child: Text(' Sem tag cadastrada',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.blueGrey,),
                                        )
                                    )
                                )
                              ],
                            ),
                  ),


                    Row(
                      children: [
                        tagsLst.length > 0 ?
                                Container(
                                    height: tagsLst.length > 0 ? 70 : 5,
                                    width: 320,
                                    child:
                                    Scrollbar(
                                      isAlwaysShown: true,
                                      controller: _scrollTagsController,
                                      child: GridView.builder(
                                        itemCount: tagsToListString(widget.song.tags).length,
                                        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: 4,
                                        ),
                                        itemBuilder: (BuildContext context, int index) {
                                          return Center(
                                              child:
                                              InputChip(
                                                isEnabled: UserManager.isUserAdmin,
                                                padding: EdgeInsets.all(2.0),
                                                label: Text(tagsLst[index],
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                backgroundColor: primaryColor,
                                                deleteIconColor: Colors.white,
                                                onDeleted: () {
                                                  setState(() {
                                                    widget.song.tags = widget.song.tags.replaceAll(tagsLst[index]+';', '');
                                                  });
                                                },
                                              )

                                          );
                                        },
                                      ),
                                    )
                                )
                           : Visibility(
                              visible: UserManager.isUserAdmin,
                              child:
                              Padding(
                                padding: EdgeInsets.only(left:70, bottom: 1),
                                child: InputChip(
                                        label: Text('Sem tags cadastradas.',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        disabledColor: Colors.white,
                                        selected: true,
                                        selectedColor: primaryColor,
                                        showCheckmark: false,

                                      )
                              )
                            )
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
                                        title: const Text('Sem Palmas',
                                                          style: TextStyle(fontSize: 15, color: Colors.blueGrey),
                                                         ),
                                        value: semPalmas,
                                        onChanged: (bool value) {
                                          if(UserManager.isUserAdmin){
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
                                        }
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
                                            style: TextStyle(fontSize: 15,color: Colors.blueGrey),),
                                          value: comPalmas,
                                          onChanged: (bool value) {
                                            if(UserManager.isUserAdmin){
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
                                          }
                                        //,secondary: const Icon(Icons.timelapse),
                                      ),
                                    ]
                                )
                            ),
                          ],
                        )
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: TextFormField(
                        initialValue: widget.song.cifra,
                        onSaved: (texto) => widget.song.cifra = texto,
                        readOnly: true,
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
                        readOnly: true,
                        decoration: InputDecoration(
                          prefixIcon: GestureDetector( onTap: _launchVideoURL,
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
                                  saveNewTags(song);
                                  if (widget.formKey.currentState.validate()) {
                                    widget.formKey.currentState.save();
                                    context.read<SongManager>().update(song);
                                    Navigator.of(context).pop();
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) =>LoadingScreen()));
                                  }
                                } else {
                                  DialogUtils.alert(context, 'Campo obrigatório.', 'É necessário informar a dinâmica da música.', 'Ok');
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

  _firstPageState() {
    simpleAutoCompleteTags = SimpleAutoCompleteTextField(
      key: key,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.blueGrey,),
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        hintText: " Adicione uma tag",
        hintStyle: TextStyle(color: Colors.blueGrey),
      ),
      suggestions: suggestions,
      textChanged: (text) => currentText = text,
      clearOnSubmit: true,
      textSubmitted: (text) =>
          setState(() {
            if (text != "") {
              if(!widget.song.tags.contains(text)){
                widget.song.tags += text + ';';
              }
            }
          }),
    );
  }

  void saveNewTags(Song song) {
    if(song.tags.isNotEmpty && song.tags.length > 0){
      tagsToListString(song.tags).forEach((tagAdded) {
        if (!TagManager.allTagsAsStrings().contains(tagAdded)) {
          context.read<TagManager>().update(Tag.newTag(tagAdded));
        }
      });
    }
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

  bool isValidateDinamicaFill() {
    return !(!semPalmas && !comPalmas);
  }

  void _launchVideoURL() async =>
      await canLaunch(widget.song.videoUrl) ? await launch(widget.song.videoUrl) : throw 'Could not launch $widget.song.videoUrl';

  void _launchChordsURL() async =>
      await canLaunch(widget.song.cifra) ? await launch(widget.song.cifra) : throw 'Could not launch $widget.song.cifra';
}
