import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:up2btangki/pages/history.dart';
// import 'package:up2btangki/pages/info.dart';
import 'dart:io'; // Add this import
import 'package:up2btangki/pages/historybulan.dart';
import 'package:up2btangki/widgets/infogensetwidget.dart';
import 'package:up2btangki/widgets/grafikwidget.dart';
import 'package:up2btangki/pages/about.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  double _fuelLevel = 0.0;
  double _temperature = 0.0;
  String _statusText = 'Off'; // Initialize with 'Off'
 
  @override
  void initState() {
    super.initState();

    _databaseReference.child('fuelinformation/tankVolume').onValue.listen(
      (event) {
        final dynamic value = event.snapshot.value;
        setState(() {
          _fuelLevel = (value != null) ? double.tryParse(value.toString()) ?? 0.0 : 0.0;
        });
      },
      onError: (error) {
        print('Error: $error');
      },
    );

    _databaseReference.child('fuelinformation/temperature').onValue.listen(
      (event) {
        final dynamic value = event.snapshot.value;
        setState(() {
          _temperature = (value != null) ? double.tryParse(value.toString()) ?? 0.0 : 0.0;
        });
      },
      onError: (error) {
        print('Error: $error');
      },
    );

    _databaseReference.child('fuelinformation/status').onValue.listen(
      (event) {
        final int status = event.snapshot.value as int? ?? 0; // Handle int status from JSON
        setState(() {
          if (status == 1) {
            _statusText = 'On';
          } else {
            _statusText = 'Off';
          }
        });
      },
      onError: (error) {
        print('Error: $error');
      },
    );
  }
  @override
  Widget build(BuildContext context) {
  return WillPopScope(
    onWillPop: () async {
      // exit(0); // Exits the application
      return true;
    },
    child: Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView( // Wrap the entire body in SingleChildScrollView
        child: Stack(
          children: [
            // Yellow background
            // Container(
            //   height: MediaQuery.of(context).size.height * 0.30,
            //   color: Colors.yellow,
            // ),
            Container(
              height: MediaQuery.of(context).size.height * 0.30,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/banner2.png'), // Path to the uploaded image
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.15 - 80,
              left: 10,
              child: Image.asset('assets/images/logoatas.png', width: 150, height: 150),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.20),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.local_gas_station, size: 30, color: Colors.black),
                        ),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bahan Bakar dalam Tangki',
                              style: TextStyle(fontSize: 20, color: Colors.black),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '${_fuelLevel.toInt()} Liter',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 95,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 3,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.yellow,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.thermostat, size: 30, color: Colors.black),
                            ),
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Suhu',
                                  style: TextStyle(fontSize: 16, color: Colors.black),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '$_temperature °C',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 95,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 3,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.yellow,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.add_task_rounded, size: 30, color: Colors.black),
                            ),
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Status',
                                  style: TextStyle(fontSize: 14, color: Colors.black),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  _statusText,
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  InfoGenset(),
                  GrafikWidget(), // Add the GrafikWidget here
                  SizedBox(height: 20), // Add space between GrafikWidget and buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 95,
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 3,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => HistoryPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            padding: EdgeInsets.all(0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Data Perhari',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 95,
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 3,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => HistoryBulanPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            padding: EdgeInsets.all(0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Data Perbulan',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'Info',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AboutPage()),
            );
          }
        },
      ),
    ),
  );
}
}