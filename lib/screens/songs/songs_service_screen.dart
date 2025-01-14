import 'package:flutter/material.dart';
import 'package:louvor_app/common/custom_drawer/custom_drawer.dart';
import 'package:louvor_app/helpers/date_utils.dart';
import 'package:louvor_app/models/Song.dart';
import 'package:louvor_app/models/song_manager.dart';
import 'package:louvor_app/screens/services/service_screen.dart';
import 'package:provider/provider.dart';
import 'package:louvor_app/models/Service.dart';

import 'components/search_dialog.dart';

class SongsServiceScreen extends StatefulWidget {

  List<Song> _lstSongSelecionadas = new List<Song>();
  Service service;

  SongsServiceScreen.buildSongsServiceScreen(Service s) {
     service = s;

     if(service.lstSongs != null){
      _lstSongSelecionadas.addAll(service.lstSongs);
     } else {
       service.lstSongs = new List();
     }
  }

  SongsServiceScreen(Service s) : service = s != null ? s.clone() : Service();

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
              if (songManager.search.isEmpty) {
                return Text('Músicas:  ${widget.service.data != null ? DateUtils.convertDatePtBr(widget.service.data) : ''} ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                          )
                      );
              } else {
                return LayoutBuilder(
                  builder: (_, constraints) {
                    return GestureDetector(
                      onTap: () async {
                        final search = await showDialog<String>(
                            context: context,
                            builder: (_) => SearchDialog(songManager.search));
                        if (search != null) {
                          songManager.search = search;
                        }
                      },
                      child: Container(
                          width: constraints.biggest.width,
                          child: Text(
                            'Músicas: ${songManager.search}',
                            textAlign: TextAlign.center,
                          )),
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
                if (songManager.search.isEmpty) {
                  return IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () async {
                      final search = await showDialog<String>(
                          context: context,
                          builder: (_) => SearchDialog(songManager.search));
                      if (search != null) {
                        songManager.search = search;
                      }
                    },
                  );
                } else {
                  return IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () async {
                      songManager.search = '';
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
                                      flex: 5,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  filteredSongs[index].nome,
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
                                            //crossAxisAlignment: CrossAxisAlignment.start,
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
                                                        size: 30,
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
            Text('Músicas Selecionadas',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).primaryColor
              ),
            ),
            // Column(
            //     children:<Widget>[
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
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                          //  Flexible( child:
                                                              Text(
                                                                widget._lstSongSelecionadas[index].nome,
                                                                overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight: FontWeight.w800,
                                                                ),
                                                              ),
                                                          //  ),
                                                            Align(
                                                                alignment: Alignment.center,
                                                                child:
                                                                  GestureDetector(
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
             //     ]
             // ),
            ElevatedButton.icon(
              onPressed: () {
                widget.service.lstSongs.clear();
                widget.service.lstSongs.addAll(widget._lstSongSelecionadas);
                //fillSongsNameIntoService(widget.service);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ServiceScreen(widget.service))
                );
              },
              icon: Icon(Icons.add, size: 10),
              label: Text("Adicionar selecionadas"),
            ),
          ],
        ),
    );
  }

}