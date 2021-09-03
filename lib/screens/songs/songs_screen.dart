import 'package:flutter/material.dart';
import 'package:louvor_app/common/custom_drawer/custom_drawer.dart';
import 'package:louvor_app/models/song_manager.dart';
import 'package:louvor_app/screens/songs/components/song_list_tile.dart';
import 'package:provider/provider.dart';

import 'components/search_dialog.dart';
import 'components/song_list_tile.dart';

class SongsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Consumer<SongManager>(
          builder: (_, songManager, __){
            if(songManager.search.isEmpty){
              return const Text('Músicas');
            } else {
              return LayoutBuilder(
                builder: (_, constraints){
                  return GestureDetector(
                    onTap: () async {
                      final search = await showDialog<String>(context: context,
                          builder: (_) => SearchDialog(songManager.search));
                      if(search != null){
                        songManager.search = search;
                      }
                    },
                    child: Container(
                        width: constraints.biggest.width,
                        child: Text(
                          'Músicas: ${songManager.search}',
                          textAlign: TextAlign.center,
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
            builder: (_, songManager, __){
              if(songManager.search.isEmpty){
                return IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    final search = await showDialog<String>(context: context,
                        builder: (_) => SearchDialog(songManager.search));
                    if(search != null){
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
          IconButton(icon: Icon(Icons.add),
    onPressed: (){
    Navigator.of(context).pushNamed(
    '/song',
    ); },
    )
    ],
      ),
      body: Consumer<SongManager>(
        builder: (_, songManager, __){
          final filteredSongs = songManager.filteredSongs;
          return ListView.builder(
              padding: const EdgeInsets.all(4),
              itemCount: filteredSongs.length,
              itemBuilder: (_, index){
                return SongListTile(filteredSongs[index]);
              }
          );
        },
      ),
    );
  }
}