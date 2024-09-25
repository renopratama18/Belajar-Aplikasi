import 'package:intl/intl.dart';

class ItemReal {
  final double awal;
  final double akhir;
  final double konsum;
  final String date; // Add date field
  // final String xnama;
  


  ItemReal({
    required this.awal,
    required this.akhir,
    required this.konsum,
    required this.date,

  });
  

   factory ItemReal.fromJson(Map<dynamic, dynamic> json, String date) {
    return ItemReal(
      awal: json['awal']?.toDouble() ?? 0.0,
      akhir: json['akhir']?.toDouble() ?? 0.0,
      konsum: json['konsum']?.toDouble() ?? 0.0,
      date: date, // Pass date to the Item

    );
  }
}
extension DateFormatting on ItemReal {
  String getMonthYear() {
    try {
      DateTime dateTime = DateFormat('yyyy_MM_dd').parse(date);
      return DateFormat('MMMM yyyy').format(dateTime);
    } catch (e) {
      print('Date parsing error: $e');
      return 'Tidak tersedia'; // Return a default value if parsing fails
    }
  }
}