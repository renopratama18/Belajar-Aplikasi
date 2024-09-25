import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class AddRiwayatGenset extends StatefulWidget {
  @override
  _AddRiwayatGensetState createState() => _AddRiwayatGensetState();
}

class _AddRiwayatGensetState extends State<AddRiwayatGenset> {
  final _formKey = GlobalKey<FormState>();
  final _tanggalController = TextEditingController();
  final _waktuController = TextEditingController();
  final _keteranganController = TextEditingController();

  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('xmaintenance');

  List<TextEditingController> _namaControllers = [
    TextEditingController(),
  ];

  void _addNameField() {
    if (_namaControllers.length < 5) {
      setState(() {
        _namaControllers.add(TextEditingController());
      });
    }
  }

  void _saveData() async {
    if (_formKey.currentState!.validate()) {
      // Generate a unique reference key
      String uniqueReference = "REF-${DateTime.now().millisecondsSinceEpoch}";

      // Collect all names
      List<String> names = _namaControllers.map((controller) => controller.text).toList();

      // Create a Map with the data to save
      Map<String, dynamic> dataToSave = {
        'reference': uniqueReference,
        'nama': names,
        'tanggal': _tanggalController.text,
        'waktu': _waktuController.text,
        'keterangan': _keteranganController.text,
      };

      try {
        // Save data under the unique reference key
        await _databaseReference.child(uniqueReference).set(dataToSave);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data berhasil disimpan')),
        );
        Navigator.of(context).pop(dataToSave);
        // Navigator.of(context).pop();
      } catch (error) {
        print('Failed to save data: $error'); // Print the error for debugging
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan data: $error')),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _tanggalController.text = DateFormat('d MMMM yyyy').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _waktuController.text = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow, // Set AppBar background color to yellow
        title: Text(
          'Tambah Riwayat Perbaikan',
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nama',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  ..._namaControllers.map((controller) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: controller,
                          decoration: InputDecoration(
                            hintText: 'Masukkan Nama Pelaksana ${_namaControllers.indexOf(controller) + 1}',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Nama tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                      ),
                    );
                  }).toList(),
                  if (_namaControllers.length < 5)
                    IconButton(
                      icon: Icon(Icons.add_circle_outline),
                      onPressed: _addNameField,
                    ),
                ],
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tanggal',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: _tanggalController,
                          decoration: InputDecoration(
                            hintText: 'Masukkan Tanggal',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Tanggal tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Waktu',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  GestureDetector(
                    onTap: () => _selectTime(context),
                    child: AbsorbPointer(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: _waktuController,
                          decoration: InputDecoration(
                            hintText: 'Masukkan Waktu',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Waktu tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Keterangan',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: _keteranganController,
                      decoration: InputDecoration(
                        hintText: 'Uraian Kegiatan',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Keterangan tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow, // Background color
                ),
                child: Text(
                  'Simpan',
                  style: TextStyle(color: Colors.black), // Text color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
