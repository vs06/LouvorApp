import 'package:intl/intl.dart';

class DateUtils {

  ///Retorna day Of Week name, Day and Mounth (As number) and HourMinute 24hs
  static String convertDatePtBr(DateTime datetime){

    var dayOfWeekPtbr = "";
    switch (DateFormat('EEEE').format(datetime).toUpperCase()) {
      case "SUNDAY":
        dayOfWeekPtbr = "Domingo";
        break;
      case "MONDAY":
        dayOfWeekPtbr = "Segunda";
        break;
      case "TUESDAY":
        dayOfWeekPtbr = "Terça";
        break;
      case "WEDNESDAY":
        dayOfWeekPtbr = "Quarta";
        break;
      case "THURSDAY":
        dayOfWeekPtbr = "Quinta";
        break;
      case "FRIDAY":
        dayOfWeekPtbr = "Sexta";
        break;
      case "SATURDAY":
        dayOfWeekPtbr = "Sábado";
        break;
    }

    var dayMounth =  DateFormat('dd/MM').format(datetime);
    var hourMinute24 = DateFormat('HH:mm').format(datetime);
    return datetime == null ? "" : dayOfWeekPtbr + " - " + dayMounth + " - "+ hourMinute24;
  }

}