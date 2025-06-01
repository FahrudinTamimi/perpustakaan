import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/book_model.dart';

class BukuDetailPage extends StatelessWidget {
  static const routeName = '/buku-detail';

  final Book book;

  BukuDetailPage({required this.book});

  Future<void> _borrowBook(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('authToken');

    if (authToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Anda perlu login untuk meminjam buku.')),
      );
      return;
    }

    final url = Uri.parse(
      'http://10.0.2.2:8000/api/borrow',
    ); // Ganti dengan URL API Anda
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    };
    final body = jsonEncode({'buku_id': book.id});

    try {
      final response = await http.post(url, headers: headers, body: body);

      print('Borrow Response Status Code: ${response.statusCode}');
      print('Borrow Response Body: ${response.body}');

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(data['message'])));
        // Anda mungkin ingin melakukan sesuatu setelah peminjaman berhasil,
        // seperti memperbarui status buku di UI atau kembali ke halaman beranda.
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(data['message'])));
      } else if (response.statusCode == 404) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Buku tidak ditemukan.')));
      } else if (response.statusCode == 422) {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data['message'] + ': ' + (data['errors']?.toString() ?? ''),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan saat meminjam buku.')),
        );
      }
    } catch (error) {
      print('Error saat meminjam buku: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tidak dapat menghubungi server.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
        backgroundColor: Colors.blue[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child:
                  book.photoUrl != null && book.photoUrl.isNotEmpty
                      ? Image.network(
                        book.photoUrl!,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return SizedBox(
                            height: 200,
                            child: Center(child: Text('Gambar tidak tersedia')),
                          );
                        },
                      )
                      : SizedBox(
                        height: 200,
                        child: Center(child: Text('Gambar tidak tersedia')),
                      ),
            ),
            SizedBox(height: 20),
            Text(
              book.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Penulis: ${book.author}',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 10),
            Text(
              'ISBN: ${book.code?.toString() ?? 'Tidak ada ISBN'}',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),
            Text(
              'Kategori: ${book.category}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 20),
            Text(
              'Status: ${book.status}',
              style: TextStyle(
                fontSize: 18,
                color: book.status == 'Tersedia' ? Colors.green : Colors.red,
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed:
                  book.status == 'Tersedia'
                      ? () => _borrowBook(context)
                      : null, // Panggil _borrowBook saat tombol ditekan
              child: Text(
                book.status == 'Tersedia' ? 'Pinjam Buku' : 'Tidak Tersedia',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    book.status == 'Tersedia' ? Colors.blue[700] : Colors.grey,
                foregroundColor: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Deskripsi:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              book.description ?? 'Tidak ada deskripsi',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
