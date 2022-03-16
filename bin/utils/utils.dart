import 'dart:developer';

import 'package:intl/intl.dart';

DateTime parseDate(Object input) {
  if (input is String) {
    return DateFormat('yyyy-MM-dd HH:mm:ss.mmmuuu').parseStrict(input);
  } else {
    return DateTime.now();
  }
}
