import 'package:intl/intl.dart'; // Pastikan paket intl sudah di-import

class Item {
  final double awal;
  final double akhir;
  final double konsum;
  final String date; // Add date field
  // final String xnama;
  final String? keterangan;
  final List<String>? nama; // Update nama to be a List<String>
  final String reference;
  // final String? tanggal;
  final DateTime? tanggal; // Update tanggal to DateTime
  final String? waktu;

  Item({
    required this.awal,
    required this.akhir,
    required this.konsum,
    required this.date,
    // required this.xnama,
    this.keterangan,
    this.nama,
    required this.reference,
    required this.tanggal,
    this.waktu,
  });

   factory Item.fromJson(Map<dynamic, dynamic> json, String date) {
    // Handle nama as List<String>
    List<String>? namaList;
    if (json['nama'] != null) {
      namaList = List<String>.from(json['nama']);
    }
    return Item(
      awal: json['awal']?.toDouble() ?? 0.0,
      akhir: json['akhir']?.toDouble() ?? 0.0,
      konsum: json['konsum']?.toDouble() ?? 0.0,
      date: date, // Pass date to the Item
      keterangan: json['keterangan'],
      nama: namaList,
      reference: json['reference'],
      // tanggal: json['tanggal'],
      tanggal: json['tanggal'] != null ? _parseTanggal(json['tanggal']) : null, // Parse tanggal
      
      waktu: json['waktu'],
    );
  }
  // Add this method to format tanggal for display
  String formattedTanggal() {
    if (tanggal != null) {
      return DateFormat('dd MMMM yyyy').format(tanggal!); // Format date only
    } else {
      return 'N/A'; // Or handle null case appropriately
    }
  }
}
  

DateTime _parseTanggal(String tanggal) {
  try {
    return DateFormat('dd MMMM yyyy').parse(tanggal); // Sesuaikan format
  } catch (e) {
    print('Error parsing date: $e');
    return DateTime.now();
  }
}

