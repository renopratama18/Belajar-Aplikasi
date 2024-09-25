import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart'; // Import Firebase dependencies
import 'package:up2btangki/models/item.dart'; // Import your Item model
import 'package:up2btangki/widgets/card_widgetsperbaikan.dart'; // Import the CardWidgetPerbaikan widget
import 'package:up2btangki/pages/addriwayatgenset.dart';

class RiwayatGenset extends StatefulWidget {
  List<Item> items; // List of items (now non-final to allow mutation)

  RiwayatGenset({required this.items}); // Constructor

  @override
  _RiwayatGensetState createState() => _RiwayatGensetState();
}

class _RiwayatGensetState extends State<RiwayatGenset> {
  bool _isNewestFirst = true; // Toggle to control sorting

  void _removeItem(Item item) {
    setState(() {
      widget.items.remove(item);
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text('Terlama'),
                onTap: () {
                  setState(() {
                    _isNewestFirst = false; // Show oldest first
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Terbaru'),
                onTap: () {
                  setState(() {
                    _isNewestFirst = true; // Show newest first
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _reloadItems() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('xmaintenance');
    DataSnapshot snapshot = await ref.get();

    if (snapshot.exists) {
      List<Item> items = [];
      Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

      data.forEach((key, value) {
        String date = key; // Use key if it's a date or use a timestamp field from value
        items.add(Item.fromJson(Map<String, dynamic>.from(value as Map<dynamic, dynamic>), date));
      });

      // Sort items by date (assuming ascending order)
      items.sort((a, b) => a.tanggal!.compareTo(b.tanggal!));

      setState(() {
        widget.items = items;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sort items based on the toggle
    List<Item> sortedItems = _isNewestFirst
        ? widget.items.reversed.toList() // Newest first
        : widget.items.toList(); // Oldest first

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow, // Set AppBar background color to yellow
        title: Text(
          'Perbaikan Genset',
          style: TextStyle(
            color: Colors.black, // Text color
            fontWeight: FontWeight.bold, // Make text bold
          ),
        ),
        centerTitle: true, // Center the title text
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black), // Icon color to match the text
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: Colors.black,
            ),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: sortedItems.isEmpty
          ? Center(
              child: Text(
                'No data available',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            )
          : ListView.builder(
              itemCount: sortedItems.length,
              itemBuilder: (context, index) {
                final item = sortedItems[index];
                return CardWidgetPerbaikan(
                  item: item,
                  // Use formattedTanggal() to show date only
                  dateText: item.formattedTanggal(),
                  onDelete: () => _removeItem(item), // Pass the delete callback
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddRiwayatGenset(),
            ),
          );

          await _reloadItems(); // Reload the items after returning from the AddRiwayatGenset screen
        },
        backgroundColor: Colors.yellow,
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}
