import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateUtil {
  static Future<DateTime> pickDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    return selectedDate!;
  }

  static String getDateString(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }

  static String getTimeString(DateTime date) {
    return DateFormat.jm().format(date);
  }

   static Future<String> getTimeStringFromTime(BuildContext context, ) async{
     TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    return  pickedTime!.format(context);
  }

  static DateTime? getDateFromString(String date) {

  date = date.replaceAll(RegExp(r'[\u200B-\u200D\uFEFF]'), '').trim();
  DateFormat format = DateFormat("yyyy-MM-dd h:mm a");
  try {
    DateTime dateTime = format.parse(date);
    return dateTime;
  } catch (e) {
    print(e.toString());
    return null;
  }
  }

}