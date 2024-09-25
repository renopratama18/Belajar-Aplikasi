import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:up2btangki/models/itemreal.dart';
import 'package:up2btangki/widgets/card_widgets.dart';
import 'package:intl/intl.dart'; // To format and parse dates

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  List<ItemReal> _items = [];
  bool _isSortedDescending = true;
  int _currentPage = 0;
  static const int _itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    final DateTime now = DateTime.now();
    final String currentMonth = DateFormat('MM').format(now);
    final String currentYear = DateFormat('yyyy').format(now);

    _databaseReference.child('fuelinformation/zhistory').onValue.listen((event) {
      final dynamic value = event.snapshot.value;
      if (value != null) {
        final Map<dynamic, dynamic> data = value as Map<dynamic, dynamic>;
        List<ItemReal> items = [];
        data.forEach((key, value) {
          final item = ItemReal.fromJson(value as Map<dynamic, dynamic>, key as String);

          // Adjusted to match the `yyyy_MM_dd` format in your data
          try {
            final DateTime itemDate = DateFormat('yyyy_MM_dd').parse(item.date);
            final String itemMonth = DateFormat('MM').format(itemDate);
            final String itemYear = DateFormat('yyyy').format(itemDate);

            if (itemMonth == currentMonth && itemYear == currentYear) {
              items.add(item);
            }
          } catch (e) {
            print('Error parsing date or adding item: $e');
          }
        });
        setState(() {
          _items = items;
          if (_isSortedDescending) {
            _items.sort((a, b) => b.date.compareTo(a.date));
          } else {
            _items.sort((a, b) => a.date.compareTo(b.date));
          }
        });
      }
    });
  }

  void _showSortOptions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sort by'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Latest'),
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _isSortedDescending = true;
                    _items.sort((a, b) => b.date.compareTo(a.date));
                  });
                },
              ),
              ListTile(
                title: Text('Oldest'),
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _isSortedDescending = false;
                    _items.sort((a, b) => a.date.compareTo(b.date));
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _nextPage() {
    setState(() {
      if ((_currentPage + 1) * _itemsPerPage < _items.length) {
        _currentPage++;
      }
    });
  }

  void _previousPage() {
    setState(() {
      if (_currentPage > 0) {
        _currentPage--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final int startIndex = _currentPage * _itemsPerPage;
    final int endIndex = startIndex + _itemsPerPage;
    final List<ItemReal> currentItems = _items.sublist(
      startIndex,
      endIndex > _items.length ? _items.length : endIndex,
    );
    final int totalPages = (_items.length / _itemsPerPage).ceil(); // Calculate total pages

    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        backgroundColor: Colors.yellow,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showSortOptions,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: currentItems.isEmpty
                ? Center(
                    child: Text(
                      'No data available',
                      style: TextStyle(fontSize: 24),
                    ),
                  )
                : ListView.builder(
                    itemCount: currentItems.length,
                    itemBuilder: (context, index) {
                      final item = currentItems[index];
                      return CardWidget(item: item);
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left),
                  onPressed: _previousPage,
                  tooltip: 'Previous Page',
                ),
                Text('${_currentPage + 1} of $totalPages'), // Show current page and total pages
                IconButton(
                  icon: Icon(Icons.chevron_right),
                  onPressed: _nextPage,
                  tooltip: 'Next Page',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
