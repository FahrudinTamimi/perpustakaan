import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../widgets/book_card.dart';
import '../models/book_model.dart';
import '../pages/buku_detail_page.dart'; // Import halaman detail buku

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  Map<String, List<Book>> allBooks = {};
  String _searchQuery = '';
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    final url = Uri.parse('http://10.0.2.2:8000/api/buku');
    try {
      final response = await http.get(url);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        print('Decoded JSON data length: ${jsonData.length}');

        allBooks.clear();

        for (var item in jsonData) {
          Book book = Book.fromJson(item);
          if (!allBooks.containsKey(book.category)) {
            allBooks[book.category] = [];
          }
          allBooks[book.category]!.add(book);
        }

        setState(() {
          isLoading = false;
          error = null;
        });
      } else {
        setState(() {
          isLoading = false;
          error = 'Gagal mengambil data buku (status ${response.statusCode})';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        error = 'Terjadi kesalahan: $e';
      });
    }
  }

  void _navigateToBookDetail(Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BukuDetailPage(book: book)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE7F5FF),
      appBar: AppBar(title: Text("Beranda"), backgroundColor: Colors.blue[700]),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : error != null
              ? Center(child: Text(error!))
              : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _searchController,
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
                          _searchQuery = value.toLowerCase();
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    ...allBooks.entries.map((entry) {
                      final filteredBooks =
                          entry.value.where((book) {
                            final title = book.title.toLowerCase();
                            final author = book.author.toLowerCase();
                            return title.contains(_searchQuery) ||
                                author.contains(_searchQuery);
                          }).toList();

                      if (filteredBooks.isEmpty) return SizedBox();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.key,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children:
                                  filteredBooks
                                      .map(
                                        (book) => Padding(
                                          padding: const EdgeInsets.only(
                                            right: 16,
                                          ),
                                          child: GestureDetector(
                                            onTap:
                                                () =>
                                                    _navigateToBookDetail(book),
                                            child: BookCard(book: book),
                                          ),
                                        ),
                                      )
                                      .toList(),
                            ),
                          ),
                          SizedBox(height: 30),
                        ],
                      );
                    }).toList(),
                    Text(
                      "Buku yang dipinjam",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(blurRadius: 5, color: Colors.grey.shade300),
                        ],
                      ),
                      child: Row(
                        children: [
                          Image.asset("assets/atomic.jpg", height: 150),
                          SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Atomic Habits",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "James Clear",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Text(
                                    "Kembalikan",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Icon(Icons.arrow_right_alt),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
