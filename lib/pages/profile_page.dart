import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('authToken');

    if (authToken != null) {
      final url = Uri.parse(
        'http://10.0.2.2:8000/api/user',
      ); // Pastikan URL ini benar
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      };

      try {
        final response = await http.get(url, headers: headers);

        print('Profile Response Status Code: ${response.statusCode}');
        print('Profile Response Body: ${response.body}');

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          setState(() {
            _userData = data;
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
            _errorMessage =
                'Gagal memuat data pengguna: ${response.statusCode}';
          });
        }
      } catch (error) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error saat mengambil data pengguna: $error';
        });
      }
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Token tidak tersedia. Silakan login kembali.';
      });
    }
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('userData');
    await prefs.remove('authToken');
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profil')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profil')),
        body: Center(child: Text(_errorMessage!)),
      );
    }

    if (_userData == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profil')),
        body: const Center(child: Text('Data pengguna tidak tersedia.')),
      );
    }

    final String username = _userData!['nama'] as String? ?? 'Tidak ada nama';
    final String email = _userData!['email'] as String? ?? 'Tidak ada email';
    final String kelas = _userData!['kelas'] as String? ?? 'Tidak ada kelas';
    final String alamat = _userData!['alamat'] as String? ?? 'Tidak ada alamat';
    final String noHp = _userData!['no_hp'] as String? ?? 'Tidak ada nomor HP';

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 20),
            CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
            SizedBox(height: 30),
            _infoCard("Username", username, Icons.account_circle),
            SizedBox(height: 20),
            _infoCard("Email", email, Icons.email),
            SizedBox(height: 20),
            _infoCard("Kelas", kelas, Icons.school),
            SizedBox(height: 20),
            _infoCard("Alamat", alamat, Icons.home),
            SizedBox(height: 20),
            _infoCard("No. HP", noHp, Icons.phone),
            SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => _logout(context),
              icon: Icon(Icons.logout),
              label: Text("Logout"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(String label, String value, IconData icon) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          SizedBox(width: 10),
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 10),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
