import 'dart:math';

import 'package:flutter/material.dart';
import 'package:louvor_app/common/custom_drawer/custom_drawer.dart';
import 'package:louvor_app/helpers/date_utils.dart';
import 'package:louvor_app/models/Rehearsal.dart';
import 'package:louvor_app/models/Service.dart';
import 'package:louvor_app/models/Song.dart';
import 'package:louvor_app/models/song_manager.dart';
import 'package:louvor_app/screens/rehearsals/rehearsal_screen.dart';
import 'package:louvor_app/screens/services/service_screen.dart';
import 'package:provider/provider.dart';

import 'components/search_dialog.dart';

class SongsServiceScreen extends StatefulWidget {

  List<Song> _lstSongSelecionadas = [];
  late Service service;
  late Service serviceWithoutChanges;

  //POG
  late String rehearsalType;

  SongsServiceScreen.buildSongsServiceScreen(Service s) {
     service = s;

     if(service.lstSongs != null){
      _lstSongSelecionadas.addAll(service.lstSongs ?? []);
     } else {
       service.lstSongs = [];
     }

     //Made a copy of original object
     //when back to previsly page, return it
     //which compare original and changes
     // to enable or not the save button
     serviceWithoutChanges = Service.specialClone(s);

  }

  SongsServiceScreen.buildSongsRehearsalScreen(Rehearsal? r) {
    service = r!;

    if(service.lstSongs != null){
      _lstSongSelecionadas.addAll(service.lstSongs ?? []);
    } else {
      service.lstSongs = [];
    }

    serviceWithoutChanges = Service.specialClone(r);
    rehearsalType = r.type!;

  }

  SongsServiceScreen(Service s) : service = s != null ? s.clone() : Service(data: null);

  @override
  State<StatefulWidget> createState() {
    return LstSongSelecionadasState();
  }

}

class LstSongSelecionadasState extends State<SongsServiceScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: CustomDrawer(),
        appBar: AppBar(
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
          title: Consumer<SongManager>(
            builder: (_, songManager, __) {
              if (songManager.searchDTO.isfiltersEmpty()) {
                return Text('Músicas:  ${widget.service.data != null ? DateUtilsCustomized.convertDatePtBr(widget.service.data) : ''} ',
                          style: TextStyle(
                            fontSize: 15,
                          )
                      );
              } else {
                return LayoutBuilder(
                  builder: (_, constraints) {
                    return GestureDetector(
                      onTap: () async {
                        await showDialog<String>(
                            context: context,
                            builder: (_) => SearchDialog(songManager.searchDTO, SongsServiceScreen)
                        );
                        if (!songManager.searchDTO.isfiltersEmpty()) {
                          songManager.notifyListenersCurrentState();
                        }
                      },
                      child: Container(
                          width: constraints.biggest.width,
                          child: Text(
                            'Musícas busca: ${songManager.searchDTO.filterResume()}',
                            style: TextStyle(fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            //textAlign: TextAlign.center,
                          )
                      ),
                    );
                  },
                );
              }
            },
          ),
          centerTitle: true,
          actions: <Widget>[
            Consumer<SongManager>(
              builder: (_, songManager, __) {
                if (songManager.searchDTO.isfiltersEmpty()) {
                  return IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () async {
                      await showDialog<String>(
                          context: context,
                          builder: (_) => SearchDialog(songManager.searchDTO, SongsServiceScreen));
                      if (!songManager.searchDTO.isfiltersEmpty()) {
                        songManager.notifyListenersCurrentState();
                      }
                    },
                  );
                } else {
                  return IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () async {
                      songManager.searchDTO.cleanfiltersSongSearchDTO();
                      songManager.notifyListenersCurrentState();
                    },
                  );
                }
              },
            ),
          ],
        ),
        body:
        Column(
          //filteredSongs = songManager.filteredSongs;
          children: <Widget>[
            Expanded(
              flex: 6,
              child:
              Consumer<SongManager>(
                  builder: (_, songManager, __) {
                    final filteredSongs = songManager.filteredSongs;
                    return ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: filteredSongs.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed('/song', arguments: filteredSongs[index]);
                            },
//**********************************************************************
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)
                              ),
                              child: Container(
                                height: 100,
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  children: <Widget>[
                                    const SizedBox(width: 16,),
                                    Expanded(
                                      flex: 8,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  filteredSongs[index].nome ?? '',
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 4),
                                            child: Text(
                                              '${filteredSongs[index].letra}',
                                              overflow: TextOverflow.ellipsis ,
                                              style: TextStyle(
                                                color: Colors.grey[400],
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '${filteredSongs[index].artista}',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w800,
                                                color: Theme.of(context).primaryColor
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        flex: 2, // 20%
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        if(!widget._lstSongSelecionadas.any((song) => song.id == filteredSongs[index].id)){
                                                          setState(() {
                                                            widget._lstSongSelecionadas.add(filteredSongs[index]);
                                                          });
                                                        }
                                                      },
                                                      child: Icon(
                                                        Icons.add_circle_sharp,
                                                        color: Colors.lightBlue,
                                                        size: 35,
                                                      ),
                                                    ),
                                                  ]
                                              ),
                                              Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Flexible(
                                                      child: Align(
                                                        alignment: Alignment.topLeft,
                                                        child: Text(
                                                          "Tom: " + '${filteredSongs[index].tom}',
                                                          overflow: TextOverflow.ellipsis ,
                                                          style: TextStyle(
                                                            color: Colors.blueGrey,
                                                            fontSize: 15,
                                                            fontWeight: FontWeight.w800,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ]
                                              ),
                                            ]
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            ),
//************************************************************************
                          );
                        }
                    );
                  }),
            ),

            Row(
              children: [
                  const SizedBox(width: 75),
                  Text('Músicas Selecionadas',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).primaryColor
                    ),
                  ),

                Transform.rotate(
                  angle: 60 * pi / 40,
                  child: IconButton(
                    icon: Icon(Icons.subdirectory_arrow_left , color: Colors.blue, size: 30, ),
                    onPressed: null,
                  ),
                ),
              ],

            ),

            Expanded(
              flex: 4, // 40%
              child:
                    ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: widget._lstSongSelecionadas.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                          return Card(
                                      shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4)
                                ),
                              child: Container(
                                height: 40,
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  children: <Widget>[
                                    const SizedBox(width: 16,),
                                    Column(
                                        children: [
                                          Expanded(
                                            flex: 5,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: 260,
                                                      child:  Text(
                                                                widget._lstSongSelecionadas[index].nome ?? '',
                                                                overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight: FontWeight.w800,
                                                                ),
                                                              ),
                                                    ),
                                                    Container(
                                                        child: GestureDetector(
                                                                  onTap: () {
                                                                    setState(() {
                                                                      widget._lstSongSelecionadas.removeWhere((element) => element.nome == widget._lstSongSelecionadas[index].nome);
                                                                    });
                                                                  },
                                                                  child:Icon(Icons.delete , color: Colors.blueGrey,),
                                                                ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ]
                                      )
                                  ],
                                ),
                              ),
                            );
                       }
             ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                widget.service.lstSongs!.clear();
                widget.service.lstSongs!.addAll(widget._lstSongSelecionadas);
                //fillSongsNameIntoService(widget.service);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                if(widget.service is Rehearsal){
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => RehearsalScreen.modify(Rehearsal.serviceCastToRehearsal(widget.service, widget.rehearsalType),
                            Rehearsal.serviceCastToRehearsal(widget.serviceWithoutChanges, widget.rehearsalType)
                        )
                        )
                    );
                }else{
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ServiceScreen.modify(widget.service, widget.serviceWithoutChanges))
                  );
                }
              },
              icon: Icon(Icons.add, size: 10),
              label: Text("Confirmar"),
            ),
          ],
        ),
    );
  }

}