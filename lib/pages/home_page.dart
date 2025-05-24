import 'package:flutter/material.dart';
import '../widgets/book_card.dart';
import '../models/book_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  final Map<String, List<Book>> allBooks = {
    "Fiksi": [
      Book(title: "Hujan", author: "Tere Liye", cover: "assets/hujan.jpg"),
      Book(title: "Perahu Kertas", author: "Dee Lestari", cover: "assets/perahu.jpg"),
    ],
    "Non-Fiksi": [
      Book(title: "Atomic Habits", author: "James Clear", cover: "assets/atomic.jpg"),
      Book(title: "Madilog", author: "Tan Malaka", cover: "assets/madilog.jpg"),
    ],
    "Sejarah": [
      Book(title: "Laut Bercerita", author: "Leila Chudori", cover: "assets/laut.jpg"),
    ],
  };

  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE7F5FF),
      appBar: AppBar(
        title: Text("Beranda"),
        backgroundColor: Colors.blue[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔍 Search Field
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

            // 🔖 Buku per kategori
            ...allBooks.entries.map((entry) {
              // Filter buku sesuai pencarian
              final filteredBooks = entry.value
                  .where((book) =>
                      book.title.toLowerCase().contains(_searchQuery) ||
                      book.author.toLowerCase().contains(_searchQuery))
                  .toList();

              if (filteredBooks.isEmpty) return SizedBox();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.key,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: filteredBooks
                          .map((book) => Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: BookCard(book: book),
                              ))
                          .toList(),
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              );
            }).toList(),

            // 📘 Buku yang dipinjam (tidak ikut dicari)
            Text(
              "Buku yang dipinjam",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(blurRadius: 5, color: Colors.grey.shade300)
                ],
              ),
              child: Row(
                children: [
                  Image.asset("assets/atomic.jpg", height: 150),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Atomic Habits",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500)),
                      Text("James Clear",
                          style: TextStyle(fontSize: 14, color: Colors.grey)),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text("Kembalikan",
                              style: TextStyle(color: Colors.grey)),
                          Icon(Icons.arrow_right_alt),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
