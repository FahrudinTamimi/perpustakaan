import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';
import '../widgets/book_card.dart';
import '../models/book_model.dart';

class HomePage extends StatelessWidget {
  final List<Book> books = [
    Book(title: "Hujan", author: "Tere Liye", cover: "assets/hujan.jpg"),
    Book(title: "Laut Bercerita", author: "Leila Chudori", cover: "assets/laut.jpg"),
    Book(title: "Atomic Habits", author: "James Clear", cover: "assets/atomic.jpg"),
    Book(title: "Madilog", author: "Tan Malaka", cover: "assets/madilog.jpg"),
    Book(title: "Perahu Kertas", author: "Dee Lestari", cover: "assets/perahu.jpg"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE7F5FF),
      body: Row(
        children: [
          Sidebar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Daftar Buku",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: books
                          .map((book) => Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: BookCard(book: book),
                              ))
                          .toList(),
                    ),
                  ),
                  SizedBox(height: 30),
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
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey)),
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
          ),
        ],
      ),
    );
  }
}
