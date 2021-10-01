class StringUtils {

  static bool isNotNUllNotEmpty(String string){
    return string != null && string.isNotEmpty && string != '';
  }

  static String splitVolunteersToTile(List<String> lstVolunteers) {
    String volunteers = "";
    int pairCounter = 0;

    lstVolunteers.forEach((element) {

      if(pairCounter == 2){
        volunteers += '\n' + element + ', ';
        pairCounter = 1;
      }else{
        volunteers += element + ', ';
        pairCounter++;
      }
    });

    return volunteers.substring(0, volunteers.length-2);

  }

}