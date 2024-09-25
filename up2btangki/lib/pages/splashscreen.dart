import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:up2btangki/routes/routes.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _showFirstLogo = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _showLogoTransition();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    // Navigate based on login status after the logo transition
    Future.delayed(Duration(seconds: 5), () {
      if (isLoggedIn) {
        Navigator.pushReplacementNamed(context, Routes.dashboard);
      } else {
        Navigator.pushReplacementNamed(context, Routes.loginscreen);
      }
    });
  }

  void _showLogoTransition() {
    // Transition between logos
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _showFirstLogo = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 239, 59),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: Duration(seconds: 1),
              child: _showFirstLogo
                  ? Image.asset(
                      'assets/images/3.png',
                      key: ValueKey(1),
                      width: 170,
                      height: 170,
                    )
                  : Image.asset(
                      'assets/images/logoatas.png',
                      key: ValueKey(2),
                      width: 170,
                      height: 170,
                    ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'FuTra @ 2024',
          style: TextStyle(
            fontFamily: 'Urbanist',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: const Color(0xff4a4a4a),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
