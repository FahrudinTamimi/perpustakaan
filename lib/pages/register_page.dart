import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController kelasController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController noHpController = TextEditingController();
  final TextEditingController statusController = TextEditingController();

  bool isLoading = false;
  String? errorMessage;

  Future<void> register() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      setState(() {
        errorMessage = 'Konfirmasi password tidak sesuai.';
        isLoading = false;
      });
      return;
    }

    final url = Uri.parse(
      'http://127.0.0.1:8000/api/register', // Ganti dengan API register Anda yang sebenarnya
    );

    final client = http.Client();
    try {
      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nama': namaController.text.trim(),
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
          'kelas': kelasController.text.trim(),
          'alamat': alamatController.text.trim(),
          'no_hp': noHpController.text.trim(),
          'status': statusController.text.trim(),
        }),
      );

      print('Register Response Status Code: ${response.statusCode}');
      print('Register Response Body: ${response.body}');

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['message'] == 'Registrasi berhasil!' &&
            data.containsKey('token')) {
          // Ambil dan simpan token
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', data['token']);
          await prefs.setBool('isLoggedIn', true); // Set status login

          // Navigasi ke halaman utama
          Navigator.pushReplacementNamed(context, '/main');
        } else {
          setState(() {
            errorMessage = data['message'] ?? 'Registrasi gagal.';
          });
        }
      } else {
        setState(() {
          errorMessage = 'Server error saat registrasi: ${response.statusCode}';
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Terjadi kesalahan: $error';
      });
    } finally {
      client.close();
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(backgroundColor: Colors.brown, title: Text('Daftar Akun')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_add, size: 100, color: Colors.brown[700]),
                SizedBox(height: 20),
                Text(
                  'Buat Akun Baru',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),
                TextField(
                  controller: namaController,
                  decoration: InputDecoration(
                    labelText: 'Nama Lengkap',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                SizedBox(height: 20),
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
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Konfirmasi Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: kelasController,
                  decoration: InputDecoration(
                    labelText: 'Kelas',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: alamatController,
                  decoration: InputDecoration(
                    labelText: 'Alamat',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: noHpController,
                  decoration: InputDecoration(
                    labelText: 'No. HP',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: statusController,
                  decoration: InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                if (errorMessage != null) ...[
                  SizedBox(height: 10),
                  Text(errorMessage!, style: TextStyle(color: Colors.red)),
                ],
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isLoading ? null : register,
                  child:
                      isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                            'Daftar',
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
                SizedBox(height: 10),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Sudah punya akun? Login di sini',
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
