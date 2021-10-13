import 'package:louvor_app/models/Song.dart';

class SongSearchDTO{

  String search = '';
  List<String> tagsFilter = [];
  List<String> palmasFilter = [];

  bool isfiltersEmpty(){
    return search == '' && tagsFilter.length == 0 && palmasFilter.length == 0;
  }

  bool hasMatchWithSong(Song song){

      bool isFilterNomeAndLetra = search != '';
      bool isFilterTags = tagsFilter.length != 0;
      bool isFilterClaps = palmasFilter.length != 0;

      int qtdFilters = 0;
      int qtdMathFilters = 0;

      if(isFilterNomeAndLetra){
        qtdFilters++;
        if(song.nome.toLowerCase().contains(this.search.toLowerCase()) || (song.letra != null && song.letra.toLowerCase().contains(this.search.toLowerCase()))){
          qtdMathFilters++;
        }
      }

      if(isFilterTags){
        qtdFilters++;
        this.tagsFilter.forEach((tagFilter) {
          if(song.tags.toLowerCase().contains(tagFilter.toLowerCase())){
            qtdMathFilters++;
          }
        });
      }

      if(isFilterClaps){
        qtdFilters++;
        this.palmasFilter.forEach((filter) {
          if(song.palmas.toLowerCase().contains(filter.toLowerCase())){
            qtdMathFilters++;
          }
        });
      }
      return qtdMathFilters >= qtdFilters;

  }

  String filterResume(){
    String resumeFilters = '';

    resumeFilters += this.search;

    if(this.tagsFilter.length > 0){
      resumeFilters += '\nTags: ';
      this.tagsFilter.forEach((element) {
        resumeFilters += element +',';
      });
      resumeFilters = resumeFilters.substring(0, resumeFilters.length-1);
    }

    if(this.palmasFilter.length > 0){
      resumeFilters += '\nDinâmica';
      this.palmasFilter.forEach((element) {
        var str = element == 'semPalma' ? 'Sem Palmas' : 'Com Palmas';
        resumeFilters += str + ',';
      });
      resumeFilters = resumeFilters.substring(0, resumeFilters.length-1);
    }

    return resumeFilters;
  }

  void cleanfiltersSongSearchDTO(){
      this.search = '';
      this.tagsFilter = [];
      this.palmasFilter = [];
  }

}