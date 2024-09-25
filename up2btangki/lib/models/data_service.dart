import 'package:up2btangki/models/itemreal.dart';
import 'package:firebase_database/firebase_database.dart';

class DataService {
  static Future<List<ItemReal>> fetchMonthlyData() async {
    final databaseReference = FirebaseDatabase.instance.ref().child('fuelinformation/zhistory');

    // Fetch the data from Firebase
    DatabaseEvent event = await databaseReference.once();
    final data = event.snapshot.value as Map<dynamic, dynamic>?;

    List<ItemReal> items = [];
    if (data != null) {
      print('Fetched data: $data'); // Debugging line
      data.forEach((key, value) {
        // Assuming 'date' is in the format 'YYYY_MM_DD'
        String date = key;
        var itemData = value as Map<dynamic, dynamic>;

        items.add(ItemReal.fromJson(itemData, date));
      });
    } else {
      print('No data available at /fuelinformation/zhistory'); // Debugging line
    }

    return items;
  }
}
