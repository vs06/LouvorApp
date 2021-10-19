import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:louvor_app/models/user_app.dart';
import 'package:louvor_app/models/user_manager.dart';
import 'package:louvor_app/screens/songs/components/song_search_dto.dart';

import 'Song.dart';

class SongManager extends ChangeNotifier{

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  UserApp? user;

  List<Song> ?allSongs = [];
  List<Song>? allInactiveSongs = [];

  SongSearchDTO _searchDTO = new SongSearchDTO();

  SongSearchDTO get searchDTO => _searchDTO;

  SongManager(){
    // _loadAllSongs();
  }

  set searchDTO(SongSearchDTO value){
    _searchDTO = value;
    notifyListeners();
  }

  void notifyListenersCurrentState(){
    notifyListeners();
  }

  List<Song> get filteredSongs {
    final List<Song> filteredSongs = [];

    if(searchDTO.isfiltersEmpty()){
      filteredSongs.addAll(allSongs ?? []);
    } else {
      if(searchDTO.inactiveFilter){
        filteredSongs.addAll(
            allInactiveSongs!.where(
                    (song) => (searchDTO.hasMatchWithSong(song))
            )
        );
      }else{
        filteredSongs.addAll(
            allSongs!.where(
                    (song) => (searchDTO.hasMatchWithSong(song))
            )
        );
      }
    }

    return filteredSongs;
  }

  List<Song> get filteredInactiveSongs {
    final List<Song> filteredSongs = [];

    if(searchDTO.isfiltersEmpty()){
      filteredSongs.addAll(allSongs ?? []);
    } else {
      filteredSongs.addAll(
          allSongs!.where(
                  (song) => (searchDTO.hasMatchWithSong(song))
          )
      );
    }

    return filteredSongs;
  }

  Future<void> _loadAllSongs() async {
    final QuerySnapshot snapSongs =
    await firestore.collection('songs').get().then((QuerySnapshot querySnapshot) => querySnapshot);

    allSongs = snapSongs.docs.map(
            (d) => Song.fromDocument(d)).toList();

    notifyListeners();
  }

  Map mapX = {
    'A_boa_parte':'C',
    'A_começar_em_mim':'C',
    'A_grandeza_do_teu_amor':'S',
    'A_minha_vida_é_do_mestre':'S',
    'Abra_os_olhos_do_meu_coração':'S',
    'Abraça-me_Senhor':'C',
    'Abre_os_meus_ouvidos':'S',
    'Acima_de_tudo':'S',
    'Aclame_ao_Senhor':'S',
    'Ainda_que_a_figueira':'S',
    'Ao_erguermos_as_mãos':'S',
    'Ao_único_que_é_digno':'S',
    'Aqui_estou':'S',
    'Atos_2':'S',
    'Bênção_e_honra':'C',
    'Bendize_oh_minhalma_ao_Senhor':'S',
    'Brilha_em_mim':'S',
    'Caia_fogo':'S',
    'Canção_de_Jó':'S',
    'Canção_do_Apocalipse':'S',
    'Cantarei_a_canção_que_há_no_céu':'C',
    'Cante_ao_Senhor':'S',
    'Carpinteiro':'S',
    'Chegou_salvação':'C',
    'Com_meu_rosto_ao_chão_(Tua_glória)':'S',
    'Com_tudo_o_que_sou_(Deus_eterno)':'S',
    'Como_Incenso':'S',
    'Compromisso':'S',
    'Cordeiro_Santo':'C',
    'Corpo_e_família':'S',
    'Creio_que_és_a_cura':'S',
    'Cristo_vive_em_mim':'C',
    'Deus_de_promessas_(Sei_que_os_teu_olhos)':'S',
    'Deus_do_Impossível':'S',
    'Deus_é_Deus_/_Serás_sempre_Deus':'S',
    'Deus_é_o_meu_refúgio':'C',
    'Diante_da_Cruz':'S',
    'Diante_de_Ti':'C',
    'Digno_de_Glória':'S',
    'Dos_telhados':'S',
    'Ele_é_exaltado':'S',
    'Em_espirito_em_verdade':'S',
    'Em_meu_viver':'S',
    'Entrega':'S',
    'Escândalo_da_Graça':'S',
    'Espírito_enche_a_minha_vida_(As_minhas_mãos)':'S',
    'Estás_aqui':'S',
    'Essência_da_Adoração':'S',
    'Estou_sem_fôlego':'S',
    'Eterno_Amor':'S',
    'Eu_amo_a_Tua_casa':'C',
    'Eu_canto_Digno':'S',
    'Eu_entro_no_santo_do_santos':'S',
    'Eu_jamais_serei_o_mesmo':'S',
    'Eu_me_alegro_em_Ti_(Sempre_Bendirei)':'S',
    'Eu_me_rendo':'S',
    'Eu_não_preciso_ser_reconhecido':'S',
    'Eu_quero_mais_(Uma_fome_toma_conta)':'S',
    'Eu_te_busco':'C',
    'Eu_te_louvarei_(Única_esperança)':'C',
    'Eu_te_quero':'C',
    'Eu_vivo_só_pra_Ti':'C',
    'Fomos_ungidos':'S',
    'Fontes': 'S',
    'Gera_Santidade_(Fogo_alto)':'S',
    'Graça':'S',
    'Graças':'S',
    'Grande_é_o_Senhor_e_mui_digno':'S',
    'Grandes_coisas_(Tu_és_o_Deus_dessa_terra)':'S',
    'Há_um_lugar':'S',
    'Hosana_(O_noivo_vem)':'S',
    'Isaías_9':'S',
    'Jesus_amado_da_minhalma':'S',
    'Jesus_em_tua_presença':'C',
    'Jesus_estou_aqui':'S',
    'Jesus_filho_de_Deus':'S',
    'Lar_de_Milagres':'S',
    'Leva-me_além':'S',
    'Lindo_és':'S',
    'Mais_de_Ti_(Humildade)':'S',
    'Mais_perto_(Grande_é_o_Teu_amor)':'S',
    'Maranata':'S',
    'Maravilhosa_Graça':'C',
    'Me_derramar':'S',
    'Me_lembrarei':'S',
    'Me_leva_onde_eu_possa_ouvir_Tua_voz':'S',
    'Meu_abrigo':'S',
    'Meu_alvo_é_Cristo':'C',
    'Meu_libertador':'S',
    'Meu_respirar':'S',
    'Música_do_céu_(Eu_quero_ouvir_a_música_do_céu)':'S',
    'Na_cruz_amaste_a_mim':'S',
    'Nada_Pode_Calar_Um_Adorador':'S',
    'Não_há_outro':'C',
    'Não_se_turbe_o_vosso_coração_(Jesus_é_o_Caminho)':'S',
    'No_arraial_no_povo_de_Deus':'C',
    'No_caminho_do_milagre':'S',
    'Nome_sobre_todo_nome':'C',
    'Nosso_Deus':'C',
    'Nosso_Deus_é_Poderoso':'C',
    'Nunca_me_deixou':'S',
    'O_Credo':'S',
    'O_mar_se_abrirá':'S',
    'O_que_Jesus_tem_feito':'S',
    'O_que_tua_glória_fez_comigo':'S',
    'O_Senhor_é_bom':'C',
    'O_Som_da_Alegria':'C',
    'Obrigado_Jesus':'S',
    'Oceanos':'S',
    'Oh_quão_lindo_esse_nome_é':'S',
    'Oleiro':'S',
    'Os_que_confiam_no_Senhor':'C',
    'Ousado_amor':'S',
    'Pai_Nosso':'S',
    'Pai_sei_que_os_Teus_olhos_(Acha_em_mim_verdadeiro_adorador)':'S',
    'Pai_viemos':'S',
    'Perto_quero_estar':'S',
    'Poder_pra_salvar_(Todos_necessitam)':'S',
    'Por_que_dEle_e_por_Ele_(A_Ele_a_Glória)':'S',
    'Por_que_Ele_vive':'C',
    'Pra_sempre':'S',
    'Pra_sempre_reinará':'S',
    'Prisioneiro':'C',
    'Quando_o_mundo_cai_ao_meu_redor':'S',
    'Quão_Grande_é_o_meu_Deus':'S',
    'Que_amor_é_esse':'S',
    'Que_grande_amor':'S',
    'Quebrantado':'C',
    'Quero_conhecer_Jesus':'S',
    'Rei_da_glória':'S',
    'Reina_sobre_mim':'S',
    'Reinar_em_mim':'C',
    'Rendido_estou':'S',
    'Salmo_40':'S',
    'Santo_Deus_(Tu_és_Santo)':'S',
    'Santo_Espírito':'S',
    'Santo_Santo_Santo':'C',
    'Se_eu_apenas_te_tocar':'S',
    'Se_eu_me_humilhar':'S',
    'Seja_engrandecido':'S',
    'Semelhante_a_Ti':'S',
    'Simples_como_Jesus':'S',
    'Só_tu_és_Santo':'S',
    'Soberano':'S',
    'Sonda-me_Senhor':'S',
    'Tão_profundo':'C',
    'Te_agradeço':'S',
    'Teu_Sangue_(Eu_sou_livre)':'S',
    'Teu_santo_nome':'S',
    'Teu_Reino':'S',
    'Toca-me':'S',
    'Tu_és_bom':'S',
    'Tua_graça_me_basta':'S',
    'Uma_nova_Historia':'S',
    'Único_Caminho':'C',
    'Vem,_Esta_é_a_hora_da_adoração':'C',
    'Vim_para_adorar-te':'S',
    'Viste-me':'S',
    'Vitória_no_Deserto':'C',
    'Vou_crer':'C',
    'Vou_deixar_na_cruz':'S'
  };

  Future<void> _loadAllSong(UserManager userManager) async {
    final QuerySnapshot snapSongs =
    await firestore.collection('songs').where('ativo', isEqualTo: 'TRUE')
                                       .get().then((QuerySnapshot querySnapshot) => querySnapshot);
    //await firestore.collection('songs').getDocuments();

    allSongs = snapSongs.docs.map(
            (d) => Song.fromDocument(d)).toList();

      // allSongs.forEach((song) {
      //   var value = mapX[song.id];

        // song.palmas = song.tags;
        // song.tags = '';

        //  song.palmas = value == null ? 'semPalmas'
        //                            : ( value == 'S' ? 'semPalmas' : 'comPalmas');
        //
        // song.save();
//      });

    notifyListeners();
  }

  Future<void> loadAllSongInactive() async {
    final QuerySnapshot snapSongs = await firestore.collection('songs')
                                                   .where('ativo', isEqualTo: 'FALSE')
                                                   .get().then((QuerySnapshot querySnapshot) => querySnapshot);

    allInactiveSongs = snapSongs.docs.map((d) => Song.fromDocument(d)).toList();

    notifyListeners();
  }

  void update(Song song){
    song.uid = user!.id;

    if(song.ativo?.toUpperCase() == 'FALSE'){
      allSongs!.removeWhere((s) => s.id == song.id);

      int indexToBeUpdated = allInactiveSongs!.indexWhere((s) => s.id == song.id);
      if( indexToBeUpdated != -1){
        allInactiveSongs!.add(song);
      }

    }else{
      int indexToBeUpdated = allSongs!.indexWhere((s) => s.id == song.id);
      if( indexToBeUpdated == -1){
        allSongs!.add(song);
      }else{
        allSongs![indexToBeUpdated] = song;
      }
    }

    song.save();
    notifyListeners();
  }

  updateUser(UserManager userManager) {
    user = userManager.userApp;

    if(user != null){
      _loadAllSong(userManager);
    }
  }

}