import 'package:flutter/material.dart';
import 'package:louvor_app/common/custom_drawer/custom_drawer.dart';
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
          title: Consumer<SongManager>(
            builder: (_, songManager, __) {
              if (songManager.search.isEmpty) {
                return const Text('Músicas');
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
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Align(
                                                        alignment: Alignment.topRight,
                                                        child:
                                                        ElevatedButton.icon(
                                                          onPressed: () {
                                                            //widget._lstSongSelecionadas.add(filteredSongs[index]);
                                                            setState(() {
                                                              widget._lstSongSelecionadas.add(filteredSongs[index]);
                                                              //widget.service.songs.add(filteredSongs[index].id);
                                                            });
                                                            // Respond to button press
                                                          },
                                                          icon: Icon(Icons.add, size: 10),
                                                          label: Text("Add"),
                                                        )
                                                    ),
                                                  ]
                                              ),
                                              Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Flexible(
                                                      child: Align(
                                                        alignment: Alignment.topRight,
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
            Text('Musicas Selecionadas',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).primaryColor
              ),
            ),
            Expanded(
              flex: 4, // 40%
              child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: widget._lstSongSelecionadas.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return Expanded(
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)
                              ),
                              child: Container(
                                height: 40,
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
                                                  widget._lstSongSelecionadas[index].nome,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                              ),
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
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                print('${widget._lstSongSelecionadas} ${widget.service.data} ${widget.service.dirigente}');
                widget.service.lstSongs.clear();
                widget.service.lstSongs.addAll(widget._lstSongSelecionadas);
                //fillSongsNameIntoService(widget.service);
                Navigator.of(context).pop();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ServiceScreen.buildSongs(widget.service))
                );
              },
              icon: Icon(Icons.add, size: 10),
              label: Text("Adicionar selecionadas"),
            ),
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //     onPressed: () {
        //   // Add your onPressed code here!
        //   },
        //   child: const Icon(Icons.check),
        //   backgroundColor: Colors.blueGrey,
        // ),
    );
  }

  /*Criado para na volta para a tela de services,
   * o objeto services conter alem da List<Song>
   *ter também a List<String> com as chaves das songs a serem persistidas
   */
  // void fillSongsNameIntoService(Service serv){
  //   if(serv.lstSongs.isNotEmpty && serv.lstSongs.length > 0){
  //     List<String> lstSongsName = [];
  //     serv.lstSongs.forEach((element) => lstSongsName.add(element.id));
  //     serv.songs = lstSongsName;
  //   }
  // }

}