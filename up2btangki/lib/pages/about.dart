import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:up2btangki/pages/dashboard.dart'; // Import this to use SystemNavigator

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
  const AboutPage({Key? key}) : super(key: key);
}

class _AboutPageState extends State<AboutPage> {
  Future<void> _showLogoutConfirmation() async {
    // Display a confirmation dialog before logging out
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Logout'),
          content: Text('Apakah Anda yakin ingin keluar?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await _logout(); // Perform the logout operation
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear login data
    SystemNavigator.pop(); // Exit the app
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Tentang FuTra',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.yellow,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Container(
                  margin: EdgeInsets.only(top: 5.0),
                  padding: EdgeInsets.all(5.0),
                  child: Image.asset('assets/images/lomo.png', width: 300, height: 200),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'FuTra (Fuel Tracking) adalah sebuah aplikasi canggih yang dirancang khusus untuk memantau dan mengelola penggunaan Bahan Bakar Minyak (BBM) di Unit Pelaksana Pengatur Beban (UP2B). Aplikasi ini bertujuan untuk meningkatkan efisiensi operasional, mengurangi pemborosan, dan memastikan ketersediaan bahan bakar yang optimal. Dengan FuTra, pengguna dapat memonitor konsumsi BBM secara real-time, melacak pengiriman dan penyimpanan, serta mendapatkan laporan yang komprehensif tentang penggunaan bahan bakar.',
                    textAlign: TextAlign.justify,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fitur Utama:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.circle, size: 6),
                          SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              'Monitoring Real-Time: FuTra memungkinkan pengguna untuk memantau konsumsi BBM secara langsung, memberikan data yang akurat dan terkini tentang jumlah bahan bakar yang digunakan dan tersisa.',
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.circle, size: 6),
                          SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              'Laporan Komprehensif: FuTra menyediakan laporan yang detail dan mudah dipahami tentang penggunaan BBM, tren konsumsi, dan analisis efisiensi. Laporan ini dapat diakses kapan saja untuk membantu pengambilan keputusan yang lebih baik.',
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Developer Android FuTra (Fuel Tracking)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage('assets/images/alvian.jpeg'),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Alvian Nur Firdaus',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Full Stack Developer',
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(height: 5),
                            Text(
                              '0802841757925',
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage('assets/images/yasmin.jpeg'),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Yasmine Navisha Andhani',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Full Stack Developer',
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(height: 5),
                            Text(
                              '08992828928',
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage('assets/images/rahma.jpeg'),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Yuliyana Rahmawati',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Full Stack Developer',
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(height: 5),
                            Text(
                              '081331138032',
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jika ada kendala dengan aplikasi ini, akan kami bantu dengan menghubungi nomor telepon/WA diatas.',
                      ),
                    ],
                  ),
                ),
                


                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _showLogoutConfirmation, // Call the confirmation dialog
                  icon: Icon(Icons.logout),
                  label: Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(MediaQuery.of(context).size.width * 0.7, 50), // Set the button to be wider
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Image.asset(
                    'assets/images/brand.png',
                    width: 500, // Adjust width to increase the size
                  ),
                ),
              ],
            ),
          ),
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
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => DashboardPage()),
            );
          }
        },
      ),
    );
  }
}
