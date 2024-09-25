import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<void> _updatePassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          // Re-authenticate the user
          final credential = EmailAuthProvider.credential(
            email: user.email!,
            password: _oldPasswordController.text,
          );

          await user.reauthenticateWithCredential(credential);

          // Update the password
          if (_newPasswordController.text == _confirmPasswordController.text) {
            await user.updatePassword(_newPasswordController.text);
            print('Password updated successfully');
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Password berhasil diperbarui'),
              backgroundColor: Colors.green,
            ));
          } else {
            print('New password and confirm password do not match');
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Password baru dan konfirmasi password tidak cocok'),
              backgroundColor: Colors.red,
            ));
          }
        } else {
          print('User is not signed in');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Pengguna tidak masuk'),
            backgroundColor: Colors.red,
          ));
        }
      } catch (e) {
        print('Failed to update password: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Gagal memperbarui password: $e'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Pengguna'),
        backgroundColor: Colors.yellow,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ganti Password',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 16.0),
              buildInputField(
                controller: _oldPasswordController,
                hintText: 'Masukkan password lama',
                validationMessage: 'Masukkan password lama',
                obscureText: true,
              ),
              SizedBox(height: 16.0),
              buildInputField(
                controller: _newPasswordController,
                hintText: 'Masukkan password baru',
                validationMessage: 'Masukkan password baru',
                obscureText: true,
              ),
              SizedBox(height: 16.0),
              buildInputField(
                controller: _confirmPasswordController,
                hintText: 'Konfirmasi password baru',
                validationMessage: 'Konfirmasi password baru',
                obscureText: true,
              ),
              SizedBox(height: 24.0),
              Center(
                child: ElevatedButton(
                  onPressed: _updatePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    foregroundColor: Colors.black,
                  ),
                  child: Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputField({
    required TextEditingController controller,
    required String hintText,
    required String validationMessage,
    required bool obscureText,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(),
        contentPadding:
            EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      ),
      obscureText: obscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validationMessage;
        }
        return null;
      },
    );
  }
}
