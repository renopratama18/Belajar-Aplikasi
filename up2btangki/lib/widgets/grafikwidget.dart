import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class GrafikWidget extends StatefulWidget {
  @override
  _GrafikWidgetState createState() => _GrafikWidgetState();
}

class _GrafikWidgetState extends State<GrafikWidget> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref().child('fuelinformation/zhistory');
  List<FlSpot> _spots = [];
  List<String> _dates = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    DataSnapshot snapshot = await _databaseReference.get();
    if (snapshot.exists) {
      Map<dynamic, dynamic>? zhistoryData = snapshot.value as Map<dynamic, dynamic>?;
      if (zhistoryData != null) {
        List<FlSpot> tempSpots = [];
        List<String> tempDates = [];
        List<String> sortedKeys = zhistoryData.keys.cast<String>().toList()
          ..sort(); // Sort the dates

        DateTime now = DateTime.now();
        DateTime startOfMonth = DateTime(now.year, now.month, 1);

        int index = 0;
        for (String key in sortedKeys.reversed) { // Iterate through dates
          DateTime date = DateFormat('yyyy_MM_dd').parse(key);
          if (date.isAfter(startOfMonth.subtract(Duration(days: 1))) && date.isBefore(DateTime(now.year, now.month + 1, 1))) {
            var value = zhistoryData[key];
            if (value['konsum'] != null) {
              tempSpots.add(FlSpot(index.toDouble(), double.tryParse(value['konsum'].toString()) ?? 0));
              tempDates.add(DateFormat('dd').format(date)); // Store the day of the month
              index++;
            }
          }
        }

        setState(() {
          _spots = tempSpots; // No need to reverse here
          _dates = tempDates;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0), // Match padding to InfoGensetWidget
      child: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255), // Background color for the box
          borderRadius: BorderRadius.circular(10.0), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // Changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            // Add the "Grafik Bulanan" text
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Grafik Bulanan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 10), // Add some space between the text and the chart
            _spots.isNotEmpty
                ? SizedBox(
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: true),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40, // Reserve space for the bottom titles
                              getTitlesWidget: (value, meta) {
                                final index = value.toInt();
                                if (index >= 0 && index < _dates.length) {
                                  return Text(
                                    _dates[index], // Display the date at the corresponding index
                                    style: TextStyle(fontSize: 10),
                                  );
                                } else {
                                  return Text('');
                                }
                              },
                              interval: 1,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40, // Reserve space for the labels
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  value.toInt().toString(),
                                  style: TextStyle(fontSize: 10),
                                );
                              },
                              interval: 100, // Show labels at every 100 units
                            ),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false, // Hide top titles
                            ),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(show: true),
                        minX: 0,
                        maxX: _spots.length - 1.toDouble(), // Adjust maxX based on _spots length
                        minY: 0, // Set minimum Y value
                        maxY: 1000, // Set maximum Y value
                        lineBarsData: [
                          LineChartBarData(
                            spots: _spots,
                            isCurved: true,
                            color: Colors.yellow, // Use a single color instead of a list 
                            barWidth: 2,
                            isStrokeCapRound: true,
                            dotData: FlDotData(show: true),
                            belowBarData: BarAreaData(show: false),
                          ),
                        ],
                      ),
                    ),
                  )
                : Center(child: Text(
                  'Belum Ada Data Bulan Ini ❗',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                )),
          ],
        ),
      ),
    );
  }
}
