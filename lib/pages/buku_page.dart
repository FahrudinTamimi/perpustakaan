import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/book_model.dart'; // Import model Book
import 'peminjaman_page.dart'; // Halaman peminjaman

class BukuPage extends StatefulWidget {
  @override
  _BukuPageState createState() => _BukuPageState();
}

class _BukuPageState extends State<BukuPage> {
  List<Book> allBooks = [];
  Map<String, List<Book>> bukuPerKategori = {};
  List<Map<String, dynamic>> bukuDipinjam = [];
  String searchQuery = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBukuFromAPI();
  }

  Future<void> fetchBukuFromAPI() async {
    final url = Uri.parse('http://10.0.2.2:8000/api/buku'); // Sesuaikan URL
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      final books = data.map((json) => Book.fromJson(json)).toList();

      final Map<String, List<Book>> kategoriMap = {};
      for (var book in books) {
        kategoriMap.putIfAbsent(book.category, () => []);
        kategoriMap[book.category]!.add(book);
      }

      setState(() {
        allBooks = books.cast<Book>();
        bukuPerKategori = kategoriMap;
        isLoading = false;
      });
    } else {
      throw Exception('Gagal memuat buku dari API');
    }
  }

  void pinjamBuku(Book book) {
    final now = DateTime.now();
    final tanggalKembali = now.add(Duration(days: 14));

    setState(() {
      bukuDipinjam.add({
        'judul': book.title,
        'tanggalPinjam': now,
        'tanggalKembali': tanggalKembali,
      });
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${book.title} berhasil dipinjam')));
  }

void bukaHalamanPeminjaman() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PeminjamanPage(), // Hapus pengiriman bukuDipinjam
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Buku"),
        backgroundColor: Colors.blue[700],
        actions: [
          IconButton(
            icon: Icon(Icons.assignment),
            onPressed: bukaHalamanPeminjaman,
          ),
        ],
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Cari buku...',
                        prefixIcon: Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value.toLowerCase();
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children:
                          bukuPerKategori.entries.map((entry) {
                            final kategori = entry.key;
                            final bukuList =
                                entry.value.where((book) {
                                  return book.title.toLowerCase().contains(
                                    searchQuery,
                                  );
                                }).toList();

                            if (bukuList.isEmpty) return SizedBox();

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                    ),
                                    child: Text(
                                      kategori,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  ...bukuList.map((book) {
                                    return Card(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      child: ListTile(
                                        leading: Image.network(
                                          book.photoUrl,
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Icon(Icons.broken_image),
                                        ),
                                        title: Text(book.title),
                                        subtitle: Text(book.author),
                                        trailing: ElevatedButton(
                                          onPressed: () => pinjamBuku(book),
                                          child: Text("Pinjam"),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ],
              ),
    );
  }
}
