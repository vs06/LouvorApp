import 'dart:core';

import 'package:intl/intl.dart';

class DateUtilsCustomized {

  ///Retorna day Of Week name, Day and Mounth (As number) and HourMinute 24hs
  static String convertDatePtBr(DateTime? datetime){

    var dayOfWeekPtbr = "";
    switch (DateFormat('EEEE').format(datetime ?? DateTime.now()).toUpperCase()) {
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

    var dayMounth =  DateFormat('dd/MM').format(datetime ?? DateTime.now());
    var hourMinute24 = DateFormat('HH:mm').format(datetime ?? DateTime.now());
    return datetime == null ? "" : dayOfWeekPtbr + " - " + dayMounth + " - "+ hourMinute24;

  }

  static int figureOutDayOfWeekAsNumber(DateTime datetime){

    var dayOfWeekAsNumber = 0;
    switch (DateFormat('EEEE').format(datetime).toUpperCase()) {
      case "SUNDAY":
        dayOfWeekAsNumber = 7;
        break;
      case "MONDAY":
        dayOfWeekAsNumber = 1;
        break;
      case "TUESDAY":
        dayOfWeekAsNumber = 2;
        break;
      case "WEDNESDAY":
        dayOfWeekAsNumber = 3;
        break;
      case "THURSDAY":
        dayOfWeekAsNumber = 4;
        break;
      case "FRIDAY":
        dayOfWeekAsNumber = 5;
        break;
      case "SATURDAY":
        dayOfWeekAsNumber = 6;
        break;
    }

    return dayOfWeekAsNumber;

  }

  static String monthBr(DateTime? datetime){

    var monthShort = "";
    switch (DateFormat('MMMM').format(datetime!).toUpperCase()) {
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

  ///Retorna data no formato dd/mm/yy hh:mm
  static dataComplentaFormatada(DateTime dateTime){
    String minute = dateTime.minute < 10 ? '0' + dateTime.minute.toString() : dateTime.minute.toString();
    String hour = dateTime.hour < 10 ? '0' + dateTime.hour.toString() : dateTime.hour.toString();

    return DateFormat('dd/MM/yy').format(dateTime).toString() + " - ${hour}:${minute}";

  }

}