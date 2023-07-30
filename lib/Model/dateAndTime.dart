import 'package:intl/intl.dart';

class DateAndTime{
  static getDisplayDateNotes(String apiResponseDate) {

    var displayFormatter = DateFormat('HH:mm');

    var previousDate = DateTime.parse(apiResponseDate).toLocal();
    return displayFormatter.format(previousDate);

  }
}