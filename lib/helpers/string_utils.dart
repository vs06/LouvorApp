class StringUtils {

  static bool isNotNUllNotEmpty(String? string){
    return string != null && string.isNotEmpty && string != '';
  }

  static String splitVolunteersToTile(List<String>? lstVolunteers) {
    String volunteers = "";
    var lengthVolunteers = lstVolunteers!.length;

    lstVolunteers.forEach((element) {
      lengthVolunteers--;
      volunteers += element;

      if(lengthVolunteers > 0){
        volunteers += '\n';
      }

    });

    return volunteers;

  }

  static String removeAccents(String text){
    var withAccent = "ÄÅÁÂÀÃäáâàãÉÊËÈéêëèÍÎÏÌíîïìÖÓÔÒÕöóôòõÜÚÛüúûùÇç";
    var withinAccent = "AAAAAAaaaaaEEEEeeeeIIIIiiiiOOOOOoooooUUUuuuuCc";

    for (int i = 0; i < withAccent.length; i++){
      text = text.replaceAll(withAccent[i], withinAccent[i]);
    }
    return text.toUpperCase();
  }

}