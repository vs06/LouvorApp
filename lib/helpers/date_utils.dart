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

  static String mounthBr(DateTime datetime){

    var monthShort = "";
    switch (DateFormat('MMMM').format(datetime).toUpperCase()) {
      case "JANUARY":
        monthShort = "Jan";
        break;
      case "FEBRUARY":
        monthShort = "Fev";
        break;
      case "MARCH":
        monthShort = "Mar";
        break;
      case "APRIL":
        monthShort = "Abr";
        break;
      case "MAY":
        monthShort = "Mai";
        break;
      case "JUNE":
        monthShort = "Jun";
        break;
      case "JULY":
        monthShort = "Jul";
        break;
      case "AUGUST":
        monthShort = "Aug";
        break;
      case "SEPTEMBER":
        monthShort = "Set";
        break;
      case "OCTOBER":
        monthShort = "Out";
        break;
      case "NOVEMBER":
        monthShort = "Nov";
        break;
      case "DECEMBER":
        monthShort = "Dez";
        break;

    }

    return monthShort;
  }

}