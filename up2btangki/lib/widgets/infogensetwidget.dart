import 'package:flutter/material.dart';
import 'package:up2btangki/pages/genset.dart';

class InfoGensetWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  InfoGensetWidget({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],  // Background color
        borderRadius: BorderRadius.circular(8),  // Border radius
        boxShadow: [
          BoxShadow(
            color: Colors.black26,  // Shadow color
            blurRadius: 4,  // Shadow blur radius
            offset: Offset(0, 2),  // Shadow offset
          ),
        ],
      ),
      child: Card(
        color: Colors.transparent, // Set Card color to transparent
        elevation: 0, // Remove shadow from Card
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),  // Border radius for Card
        ),
        child: ListTile(
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: onTap,
        ),
      ),
    );
  }
}

class InfoGenset extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          InfoGensetWidget(
            title: 'Informasi Genset',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GensetPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
