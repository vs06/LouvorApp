import 'package:flutter/material.dart';
import 'package:louvor_app/helpers/string_utils.dart';
import 'package:louvor_app/models/Song.dart';
import 'package:louvor_app/models/song_manager.dart';
import 'package:louvor_app/models/user_manager.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SongListTile extends StatelessWidget {

  const SongListTile(this.song);

  final Song song;

  _showAlertDialog(BuildContext context, String conteudo, Song s) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmação'),
          content: Text(conteudo),
          actions: [
            FlatButton(
              child: Text('Não'),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: Text('Sim'),
              onPressed: () {
                //TODO fix this POG
                s.delete(s);
                context.read<SongManager>().update(s);
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/song', arguments: song);
      },
      child: Visibility(
        visible: true,
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
                            song.nome ?? '',
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
                          '${song.letra}',
                          overflow: TextOverflow.ellipsis ,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Text(
                        '${song.artista}',
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
                              Visibility(
                                visible: StringUtils.isNotNUllNotEmpty(song.videoUrl),
                                child:
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: GestureDetector(
                                        onTap: _launchVideoURL,
                                        child: Icon(Icons.ondemand_video, color: Colors.blueGrey,),
                                      ),
                                    ),
                              ),
                              Visibility(
                                visible: StringUtils.isNotNUllNotEmpty(song.cifra),
                                child:
                                Align(
                                  alignment: Alignment.topRight,
                                  child: GestureDetector(
                                    onTap: _launchChordsURL,
                                    child: Icon(Icons.straighten_rounded, color: Colors.blueGrey, size: 29,),
                                    //child: IconData(0xe457, fontFamily: 'MaterialIcons'),
                                  ),
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
                                  "Tom: " + '${song.tom}',
                                  overflow: TextOverflow.ellipsis ,
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              ),
                              Visibility(
                                child: GestureDetector(
                                  onTap: () {_showAlertDialog(context, 'Confirma a exclusão dessa música do repertório?', song);},
                                  child:Icon(Icons.delete , color: Colors.blueGrey,),
                                ),
                                //visible: UserManager.isUserAdmin,
                                visible: UserManager.isUserAdmin ?? false
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
      ),
    );
  }

  void _launchVideoURL() async =>
      await canLaunch(song.videoUrl ?? '') ? await launch(song.videoUrl ?? '') : throw 'Could not launch $song.videoUrl';

  void _launchChordsURL() async =>
      await canLaunch(song.cifra ?? '') ? await launch(song.cifra ?? '') : throw 'Could not launch $song.cifra';
}