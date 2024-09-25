import 'package:flutter/material.dart';  // Perbaikan impor
import 'package:up2btangki/pages/info.dart';

class AksesPage extends StatefulWidget {
  @override
  _AksesPageState createState() => _AksesPageState();
}

class _AksesPageState extends State<AksesPage> {
  void _showSortOptions() {
    // Logika untuk menampilkan opsi penyortiran
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.sort_by_alpha),
              title: Text('Sort by Name'),
              onTap: () {
                // Aksi untuk penyortiran berdasarkan nama
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.sort),
              title: Text('Sort by Date'),
              onTap: () {
                // Aksi untuk penyortiran berdasarkan tanggal
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
      body: Center(
        child: Text('About Page Content'),
      ),
    );
  }
}
