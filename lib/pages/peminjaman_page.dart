import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/peminjaman_model.dart'; // Pastikan path ini benar
import '../models/book_model.dart';
 // Pastikan path ini benar

class PeminjamanPage extends StatefulWidget {
  @override
  _PeminjamanPageState createState() => _PeminjamanPageState();
}

class _PeminjamanPageState extends State<PeminjamanPage> {
  List<Peminjaman> _peminjamanList = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchPeminjaman();
  }

  Future<void> _fetchPeminjaman() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('authToken');

    if (authToken != null) {
      final url = Uri.parse(
        'http://10.0.2.2:8000/api/peminjaman',
      ); // Ganti dengan URL API Anda
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      };

      try {
        final response = await http.get(url, headers: headers);

        print('Peminjaman Response Status Code: ${response.statusCode}');
        print('Peminjaman Response Body: ${response.body}');

        if (response.statusCode == 200) {
          final List<dynamic> jsonData = jsonDecode(response.body);
          _peminjamanList =
              jsonData.map((item) => Peminjaman.fromJson(item)).toList();
          setState(() {
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
            _errorMessage =
                'Gagal memuat daftar peminjaman: ${response.statusCode}';
          });
        }
      } catch (error) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error saat mengambil daftar peminjaman: $error';
        });
      }
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Token tidak tersedia. Silakan login kembali.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Peminjaman'),
        backgroundColor: Colors.blue[700],
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : _peminjamanList.isEmpty
              ? Center(child: Text('Tidak ada buku yang sedang Anda pinjam.'))
              : ListView.builder(
                itemCount: _peminjamanList.length,
                itemBuilder: (context, index) {
                  final peminjaman = _peminjamanList[index];
                  final book =
                      peminjaman
                          .buku; // Asumsi model Peminjaman memiliki relasi 'buku'

                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Judul: ${book?.title ?? 'Judul tidak tersedia'}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Tanggal Pinjam: ${peminjaman.tanggalPinjam?.split('T')[0] ?? 'Tidak ada tanggal'}',
                          ),
                          Text(
                            'Tanggal Kembali: ${peminjaman.tanggalKembali?.split('T')[0] ?? 'Tidak ada tanggal'}',
                          ),
                          Text(
                            'Status: ${peminjaman.status ?? 'Tidak ada status'}',
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              // Implementasikan logika pengembalian buku
                              print(
                                'Tombol Kembalikan ditekan untuk buku ${book?.id}',
                              );
                            },
                            child: Text('Kembalikan Buku'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
