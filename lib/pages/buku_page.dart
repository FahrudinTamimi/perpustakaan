import 'package:flutter/material.dart';
import 'peminjaman_page.dart';

class BukuPage extends StatefulWidget {
  @override
  _BukuPageState createState() => _BukuPageState();
}

class _BukuPageState extends State<BukuPage> {
  final List<Map<String, String>> daftarBuku = [
    {
      'judul': 'Hujan',
      'gambar': 'assets/hujan.jpg',
    },
    {
      'judul': 'Laut Bercerita',
      'gambar': 'assets/laut.jpg',
    },
    {
      'judul': 'Perahu Kertas',
      'gambar': 'assets/perahu.jpg',
    },
  ];

  List<String> bukuDipinjam = [];

  void pinjamBuku(String judul) {
    setState(() {
      bukuDipinjam.add(judul);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$judul berhasil dipinjam')),
    );
  }

  void bukaHalamanPeminjaman() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PeminjamanPage(bukuDipinjam: bukuDipinjam),
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
          )
        ],
      ),
      body: ListView.builder(
        itemCount: daftarBuku.length,
        itemBuilder: (context, index) {
          final buku = daftarBuku[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: Image.asset(buku['gambar']!, width: 50, height: 50, fit: BoxFit.cover),
              title: Text(buku['judul']!),
              trailing: ElevatedButton(
                onPressed: () => pinjamBuku(buku['judul']!),
                child: Text("Pinjam"),
              ),
            ),
          );
        },
      ),
    );
  }
}
