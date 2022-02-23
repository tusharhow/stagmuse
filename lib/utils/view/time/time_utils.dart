import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

String handlingTimeUtils(String time) {
  // Here if it is more than a week it will show the Date - Month - Year.
  // If less time or samna with a week of eating displays (X days ago)

  // Convert to DateTime Data Type
  final DateTime _timeMessageCome = DateFormat("yyyy-MM-dd HH:mm").parse(time);
  final DateTime _timeNow = DateTime.now();
  // For a deadline of 1 week
  final DateTime _batasWaktu = DateTime(
      _timeMessageCome.year,
      _timeMessageCome.month,
      _timeMessageCome.day + 7,
      _timeMessageCome.hour,
      _timeMessageCome.minute);

  // If the result is more than 0 then show the 1st time condition if it does not show the 2nd time condition
  if (_batasWaktu.compareTo(_timeNow) >= 0) {
    return Jiffy(_timeMessageCome).fromNow();
  } else {
    return Jiffy(_timeMessageCome).yMMMMd;
  }
}

String handlingChatTimeUtils(String time) {
  // Here if it is more than a week it will show the Date - Month - Year.
  // If less time or samna with a week of eating displays (X days ago)

  // Convert to DateTime Data Type
  final DateTime _timeMessageCome = DateFormat("yyyy-MM-dd").parse(time);
  final DateTime _timeNow = DateFormat("yyyy-MM-dd").parse(
      "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}");

  if (_timeMessageCome.compareTo(_timeNow) == 0) {
    return "Today";
  }

  if (_timeNow.subtract(const Duration(days: 1)).compareTo(_timeMessageCome) ==
      0) {
    return "Yesterday";
  } else {
    return Jiffy(_timeMessageCome).yMMMMd;
  }
}

String handlingTimeMonthDayYearUtils(String time) {
  final DateTime _birhtdate = DateFormat("yyyy-MM-dd").parse(time);
  return Jiffy(_birhtdate).yMMMMd;
}

String handlingYearMonthDateUtils(String time) {
  final DateTime _timeMessageCome = DateFormat("yyyy-MM-dd").parse(time);

  return Jiffy(_timeMessageCome).yMMMMd;
}

String handlingChatTime(String time) {
  final dateTime = DateFormat('yyy-MM-dd HH:mm').parse(time);
  final format = DateFormat.jm().format(dateTime);
  return format;
}
