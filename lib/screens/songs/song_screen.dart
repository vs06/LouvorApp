import 'package:flutter/material.dart';
import 'package:louvor_app/models/Song.dart';
import 'package:provider/provider.dart';
import 'package:louvor_app/models/song_manager.dart';
import 'package:louvor_app/models/user_manager.dart';

class SongScreen extends StatelessWidget {
  SongScreen(Song s) : song = s != null ? s.clone() : Song();

  final Song song;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return ChangeNotifierProvider.value(
      value: song,
      child: Scaffold(
        appBar: AppBar(
          title: song != null ? Text("Música") : Text(song.nome),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(
                      initialValue: song.nome,
                      onSaved: (titulo) => song.nome = titulo,
                      decoration: const InputDecoration(
                        hintText: 'Nome',
                        border: InputBorder.none,
                        labelText: 'Nome',
                      ),
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: TextFormField(
                        initialValue: song.artista,
                        onSaved: (tb) => song.artista = tb,
                        decoration: const InputDecoration(
                          hintText: 'Artista',
                          border: InputBorder.none,
                          labelText: 'Artista',
                        ),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: TextFormField(
                        initialValue: song.letra,
                        onSaved: (tags) => song.letra = tags,
                        decoration: const InputDecoration(
                          hintText: 'Letra',
                          border: InputBorder.none,
                          labelText: 'Letra',
                        ),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 8),
                      child: TextFormField(
                        initialValue: song.tom,
                        onSaved: (tema) => song.tom = tema,
                        decoration: const InputDecoration(
                          hintText: 'Tom',
                          border: InputBorder.none,
                          labelText: 'Tom',
                        ),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 8),
                      child: TextFormField(
                        initialValue: song.cifra,
                        onSaved: (texto) => song.cifra = texto,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          filled: true,
                          hintText: 'Cifra',
                          labelText: 'Cifra',
                        ),
                        onChanged: (value) {
                          song.cifra = value;
                        },
                        maxLines: 5,
                      ),
                    ),
                    Consumer<Song>(
                      builder: (_, sermon, __) {
                        return Visibility(
                            visible: UserManager.isUserAdmin,
                            child: RaisedButton(
                              onPressed: () async {
                                if (formKey.currentState.validate()) {
                                  formKey.currentState.save();
                                  await sermon.save();
                                  context.read<SongManager>().update(sermon);
                                  Navigator.of(context).pop();
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
}
