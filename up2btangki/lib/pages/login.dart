import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:up2btangki/pages/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 239, 59),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/orang.png', width: 250),
            SizedBox(height: 16),
            Text(
              "''Genset Terpantau\ndalam Satu Genggaman''",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AccessCodeDialog();
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  shadowColor: Colors.black,
                ),
                child: Text("Masuk"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AccessCodeDialog extends StatefulWidget {
  @override
  _AccessCodeDialogState createState() => _AccessCodeDialogState();
}

class _AccessCodeDialogState extends State<AccessCodeDialog> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _verifyLogin(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _usernameController.text,
              password: _passwordController.text);

      if (userCredential.user != null) {
        await _saveLoginState();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()),
          (Route<dynamic> route) => false, // Remove all previous routes
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'Username tidak ditemukan';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Password salah';
      } else {
        errorMessage = 'Terjadi kesalahan';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  Future<void> _saveLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
  }
  Future<void> _checkSessionExpiry() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loginTimeStr = prefs.getString('loginTime');

    if (loginTimeStr != null) {
      DateTime loginTime = DateTime.parse(loginTimeStr);
      DateTime now = DateTime.now();

      // Check if 24 hours have passed
      if (now.isAfter(loginTime.add(Duration(hours: 24)))) {
        _logout();
      } else {
        // Check if it's midnight and the day has changed
        if (now.day != loginTime.day) {
          _logout();
        }
      }
    }
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('loginTime');
    await FirebaseAuth.instance.signOut();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Masuk",
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              hintText: "Masukkan email",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          SizedBox(height: 8),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              hintText: "Masukkan password",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            obscureText: true,
          ),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 253, 218, 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(color: Color.fromARGB(255, 253, 218, 13)),
                ),
              ),
            ),
            SizedBox(width: 10), // Optional space between buttons
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      _verifyLogin(context);
                    },
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 253, 218, 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ],
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
    );
  }
}
