import 'package:intl/intl.dart';

class Helperclass {
  // use this for Date format 25-04-2025
  static dateFormatNormal(String inputTime) {
    if (inputTime.isNotEmpty) {
      DateTime parsedstartdate = DateFormat("yyyy-MM-dd").parse(inputTime);
      return DateFormat("dd-MM-yyyy").format(parsedstartdate);
    } else {
      return inputTime;
    }
  }

  // use this for Date format  2025-04-23 for sending to server
  static dateFormatServer(String inputTime) {
    if (inputTime.isNotEmpty) {
      DateTime parsedstartdate = DateFormat("dd-MM-yyyy").parse(inputTime);
      return DateFormat("yyyy-MM-dd").format(parsedstartdate);
    } else {
      return inputTime;
    }
  }

  // use this for time format 07:43:03 for sending to server
  static timeFormatServer(String inputTime) {
    if (inputTime.isNotEmpty) {
      DateTime parsedstarttime = DateFormat("hh:mm a").parse(inputTime);
      return DateFormat("HH:mm:00").format(parsedstarttime);
    } else {
      return inputTime;
    }
  }

  static timeFormat(String inputTime) {
    if (inputTime.isNotEmpty) {
      DateTime parsedstarttime = DateFormat("HH:mm:ss").parse(inputTime);
      return DateFormat("hh:mm a").format(parsedstarttime);
    } else {
      return inputTime;
    }
  }
}
