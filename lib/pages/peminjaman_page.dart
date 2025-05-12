import 'package:flutter/material.dart';

class PeminjamanPage extends StatelessWidget {
  final List<String> bukuDipinjam;

  // Jadikan parameter bukuDipinjam opsional dengan nilai default (kosong)
  PeminjamanPage({this.bukuDipinjam = const []});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Peminjaman Buku"),
      ),
      body: ListView.builder(
        itemCount: bukuDipinjam.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(bukuDipinjam[index]),
          );
        },
      ),
    );
  }
}
