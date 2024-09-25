// lib/widgets/card_widgets_bulan.dart

import 'package:flutter/material.dart';
import 'package:up2btangki/models/itemreal.dart';

class CardWidgetBulan extends StatelessWidget {
  final String monthYear;
  final List<ItemReal> items;

  CardWidgetBulan({required this.monthYear, required this.items});

  @override
  Widget build(BuildContext context) {
    double totalConsumption = items.fold(0.0, (sum, item) => sum + item.konsum);

    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Konsumsi Bulanan: $monthYear',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Total Konsumsi: ${totalConsumption.toStringAsFixed(2)} liter',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
