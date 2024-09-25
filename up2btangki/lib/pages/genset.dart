import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:up2btangki/pages/riwayatgenset.dart';
import 'package:up2btangki/models/item.dart';

class GensetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text(
          'Informasi Genset',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(40.0),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.asset(
                  'assets/images/genset.jpg',
                  fit: BoxFit.cover,
                  width: 330,
                  height: 330,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Genset UIT JBM & UP2B JAWA TIMUR',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  GensetInfoRow(label: 'Merk', value: 'Mitsubishi'),
                  GensetInfoRow(label: 'Type', value: 'GFC5316E-4'),
                  GensetInfoRow(label: 'Output', value: '250 kVA'),
                  GensetInfoRow(label: 'Volt', value: '380'),
                  GensetInfoRow(label: 'Ampere', value: '380'),
                  SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        List<Item> items = await fetchItemsFromRealtimeDatabase();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RiwayatGenset(items: items),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Text(
                        'Riwayat Perbaikan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Item>> fetchItemsFromRealtimeDatabase() async {
    List<Item> itemList = [];
    final database = FirebaseDatabase.instance.ref();

    try {
      final snapshot = await database.child('xmaintenance').get();
      
      if (snapshot.exists) {
        final itemsMap = snapshot.value as Map<dynamic, dynamic>;
        itemsMap.forEach((key, value) {
          final itemData = value as Map<dynamic, dynamic>;
          final item = Item.fromJson(itemData, key);
          itemList.add(item);
        });
      }
    } catch (e) {
      print('Error fetching items: $e');
    }

    return itemList;
  }
}

class GensetInfoRow extends StatelessWidget {
  final String label;
  final String value;

  GensetInfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$label :',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
