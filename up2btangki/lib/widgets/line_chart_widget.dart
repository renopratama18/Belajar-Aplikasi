import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class FuelConsumptionChart extends StatefulWidget {
  const FuelConsumptionChart({super.key});

  @override
  State<FuelConsumptionChart> createState() => _FuelConsumptionChartState();
}

class _FuelConsumptionChartState extends State<FuelConsumptionChart> {
  List<FlSpot> spots = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    // Fetch and prepare data
    final data = {
      '2024-07-30': -0.74672,
      '2024-07-31': -37.35846,
      '2024-08-06': 1.47742,
    };

    final List<FlSpot> tempSpots = [];
    final now = DateTime.now();
    for (int i = 0; i < 30; i++) {
      final date = now.subtract(Duration(days: i));
      final key = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final value = data[key] ?? 0.0;
      tempSpots.add(FlSpot(i.toDouble(), value));
    }

    setState(() {
      spots = tempSpots;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.70,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child : spots.isEmpty
          ? Center(
            child: Text(
              "Belum Ada Data Bulan Ini",
              style: TextStyle(fontSize: 16, color: Colors.black),
            )
          )
        
        
        : LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              horizontalInterval: 1,
              verticalInterval: 1,
              getDrawingHorizontalLine: (value) {
                return const FlLine(
                  color: Colors.grey,
                  strokeWidth: 1,
                );
              },
              getDrawingVerticalLine: (value) {
                return const FlLine(
                  color: Colors.grey,
                  strokeWidth: 1,
                );
              },
            ),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    final DateTime date = DateTime.now().subtract(Duration(days: value.toInt()));
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(
                        '${date.day}/${date.month}',
                        style: const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(
                        '${value.toInt()}',
                        style: const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    );
                  },
                  reservedSize: 42,
                ),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: const Color(0xff37434d)),
            ),
            minX: 0,
            maxX: 29,
            minY: -50,
            maxY: 10,
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                // colors: [Colors.blue], // Correctly set color here
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
