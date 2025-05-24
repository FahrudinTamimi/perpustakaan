import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PeminjamanPage extends StatelessWidget {
  final List<Map<String, dynamic>> bukuDipinjam;

  PeminjamanPage({this.bukuDipinjam = const []});

  final DateFormat formatter = DateFormat('dd MMM yyyy');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Peminjaman Buku"),
      ),
      body: bukuDipinjam.isEmpty
          ? Center(child: Text("Belum ada buku yang dipinjam"))
          : ListView.builder(
              itemCount: bukuDipinjam.length,
              itemBuilder: (context, index) {
                final buku = bukuDipinjam[index];
                final tanggalPinjam = buku['tanggalPinjam'] as DateTime;
                final tanggalKembali = buku['tanggalKembali'] as DateTime;

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(buku['judul']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 6),
                        Text("Tanggal Pinjam: ${formatter.format(tanggalPinjam)}"),
                        Text("Tanggal Kembali: ${formatter.format(tanggalKembali)}"),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
