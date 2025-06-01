import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/anggota_model.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  String? errorMessage;

  Future<void> login() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final url = Uri.parse(
      'http://10.0.2.2:8000/api/login', // Ganti dengan API login Anda yang sebenarnya
    );
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
        }),
      );

      print('Login Response Status Code: ${response.statusCode}');
      print('Login Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['message'] == 'Login berhasil!' &&
            data.containsKey('token') &&
            data.containsKey('anggota')) {
          Anggota? anggota;
          if (data['anggota'] != null) {
            anggota = Anggota.fromJson(data['anggota']);
          }

          final String token =
              data['token'] as String? ?? ''; // Ambil token dari response

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setInt('anggota_id', anggota?.id ?? 0);
          await prefs.setString('anggota_nama', anggota?.nama ?? '');
          await prefs.setString('anggota_email', anggota?.email ?? '');
          await prefs.setString('authToken', token);
          await prefs.setString('userData', jsonEncode(data));

          Navigator.pushReplacementNamed(context, '/main');
        } else {
          setState(() {
            errorMessage = data['message'] ?? 'Login gagal.';
          });
        }
      } else {
        setState(() {
          errorMessage = 'Server error: ${response.statusCode}';
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Terjadi kesalahan: $error';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.library_books, size: 100, color: Colors.brown[700]),
                SizedBox(height: 20),
                Text(
                  'Perpustakaan Digital',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                if (errorMessage != null) ...[
                  Text(errorMessage!, style: TextStyle(color: Colors.red)),
                  SizedBox(height: 10),
                ],
                ElevatedButton(
                  onPressed: isLoading ? null : login,
                  child:
                      isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                            'Login',
                            style: TextStyle(color: Colors.white),
                          ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Text(
                    'Belum punya akun? Daftar di sini',
                    style: TextStyle(color: Colors.brown[700]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
