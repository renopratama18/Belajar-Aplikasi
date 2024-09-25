import 'package:intl/intl.dart';
import 'package:up2btangki/models/itemreal.dart';
import 'package:intl/intl.dart';

extension DateFormatting on ItemReal {
  String getMonthYear() {
    try {
      DateTime dateTime = DateFormat('yyyy_MM_dd').parse(date);
      return DateFormat('MMMM yyyy').format(dateTime);
    } catch (e) {
      print('Error parsing date: $e');
      return 'Tidak tersedia';
    }
  }
}
