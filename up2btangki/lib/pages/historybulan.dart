import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:up2btangki/models/itemreal.dart';
import 'package:up2btangki/models/data_service.dart';

class HistoryBulanPage extends StatefulWidget {
  @override
  _HistoryBulanPageState createState() => _HistoryBulanPageState();
}

class _HistoryBulanPageState extends State<HistoryBulanPage> {
  bool _isLoading = false;
  double _totalConsumption = 0.0;
  String _errorMessage = '';
  String _selectedMonth = '01';
  String _selectedYear = '2024';
  List<ItemReal> _fetchedItems = [];

  final List<String> _months = [
    '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'
  ];

  final List<String> _years = [
    '2023', '2024', '2025', '2026', '2027'
  ];

  void _fetchData(String month, String year) async {
    setState(() {
      _isLoading = true;
      _totalConsumption = 0.0;
      _errorMessage = '';
      _fetchedItems = [];
    });

    try {
      List<ItemReal> items = await DataService.fetchMonthlyData();
      if (items.isEmpty) {
        setState(() {
          _errorMessage = 'No data available for the given month and year.';
          _isLoading = false;
        });
        return;
      }

      String formattedMonth = month.padLeft(2, '0');
      String monthYearKey = '$year\_$formattedMonth';

      List<ItemReal> filteredItems = items.where((item) => item.date.startsWith(monthYearKey)).toList();
      double totalConsumption = filteredItems.fold(0.0, (sum, item) => sum + (item.konsum ?? 0.0));

      setState(() {
        _totalConsumption = totalConsumption;
        _fetchedItems = filteredItems;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching data. Please try again.';
        _isLoading = false;
      });
    }
  }

  Future<void> _generateCSV() async {
    List<List<dynamic>> rows = [];

    // Add headers
    rows.add(['Tanggal', 'Awal', 'Akhir', 'Konsumsi']);

    // Add data
    for (var item in _fetchedItems) {
      rows.add([item.date, item.awal, item.akhir, item.konsum]);
    }

    String csv = const ListToCsvConverter().convert(rows);

    try {
      Directory? downloadsDirectory;
      if (Platform.isAndroid) {
        downloadsDirectory = Directory('/storage/emulated/0/Download');
      } else {
        downloadsDirectory = await getExternalStorageDirectory();
      }

      if (downloadsDirectory == null) {
        throw Exception('Unable to access the Downloads directory');
      }

      String outputFile = "${downloadsDirectory.path}/history_bulan_${_selectedMonth}_${_selectedYear}.csv";

      File file = File(outputFile);
      await file.writeAsString(csv);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('CSV file saved: $outputFile')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save CSV file: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Bulanan'),
        backgroundColor: Colors.yellow,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Bulan'),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedMonth,
                  icon: Icon(Icons.arrow_drop_down),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedMonth = newValue!;
                    });
                  },
                  items: _months.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 30),
              Text('Tahun'),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedYear,
                  icon: Icon(Icons.arrow_drop_down),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedYear = newValue!;
                    });
                  },
                  items: _years.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  _fetchData(_selectedMonth, _selectedYear);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: Text(
                  'Cari',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(height: 30),
              if (_isLoading)
                Center(child: CircularProgressIndicator())
              else if (_errorMessage.isNotEmpty)
                Text(_errorMessage, style: TextStyle(color: Colors.red))
              else if (_fetchedItems.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total pemakaian bulan ini: $_totalConsumption Liter', style: TextStyle(fontSize: 18)),
                    SizedBox(height: 20),
                    _buildDataTable(_fetchedItems),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _generateCSV,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: Text(
                        'Download CSV',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataTable(List<ItemReal> items) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text('Tanggal')),
          DataColumn(label: Text('Awal')),
          DataColumn(label: Text('Akhir')),
          DataColumn(label: Text('Konsumsi')),
        ],
        rows: items.map((item) {
          return DataRow(
            cells: [
              DataCell(Text(item.date)),
              DataCell(Text(item.awal.toString())),
              DataCell(Text(item.akhir.toString())),
              DataCell(Text(item.konsum.toString())),
            ],
          );
        }).toList(),
      ),
    );
  }
}
