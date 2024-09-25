import 'package:flutter/material.dart';
import 'package:up2btangki/models/itemreal.dart';

class CardWidget extends StatelessWidget {
  final ItemReal item;

  const CardWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        Navigator.pushNamed(context, '/item', arguments: item);
      },
      child: Card(
        color: Color.fromARGB(255, 245, 245, 245),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(8),
          title: Text(
            'Penggunaan Bahan Bakar Harian',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xff4a4a4a)),
          ),
          subtitle: Row(
            children: [
              Text(
                'Waktu ${item.date}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xff808080)),
              ),
            ],
          ),
          trailing: GestureDetector(
            onTap: () {
              _showDetailDialog(context);
            },
            child: Text(
              '${item.konsum} liter',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff4a4a4a)),
            ),
          ),
        ),
      ),
    );
  }

  void _showDetailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: 297,
            height: 220,
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: const Color.fromARGB(255, 243, 229, 33),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            'Detail',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8, top: 8),
                      child: Text('BBM Awal: ${item.awal} liter'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8, top: 8),
                      child: Text('BBM Akhir: ${item.akhir} liter'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8, top: 8),
                      child: Text('Total Pemakaian: ${item.konsum} liter'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
