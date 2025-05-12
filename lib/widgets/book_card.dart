import 'package:flutter/material.dart';
import '../models/book_model.dart';

class BookCard extends StatelessWidget {
  final Book book;

  BookCard({required this.book});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Column(
        children: [
          Image.asset(book.cover, height: 130),
          SizedBox(height: 5),
          Text(book.title, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(book.author, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
