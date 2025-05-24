import 'package:flutter/material.dart';
import 'peminjaman_page.dart';

class BukuPage extends StatefulWidget {
  @override
  _BukuPageState createState() => _BukuPageState();
}

class _BukuPageState extends State<BukuPage> {
  final Map<String, List<Map<String, String>>> bukuPerKategori = {
    "Fiksi": [
      {'judul': 'Hujan', 'gambar': 'assets/hujan.jpg'},
      {'judul': 'Perahu Kertas', 'gambar': 'assets/perahu.jpg'},
    ],
    "Sejarah": [
      {'judul': 'Laut Bercerita', 'gambar': 'assets/laut.jpg'},
    ],
  };

  List<Map<String, dynamic>> bukuDipinjam = [];
  String searchQuery = '';

  void pinjamBuku(String judul) {
    final now = DateTime.now();
    final tanggalKembali = now.add(Duration(days: 14));

    setState(() {
      bukuDipinjam.add({
        'judul': judul,
        'tanggalPinjam': now,
        'tanggalKembali': tanggalKembali,
      });
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
      body: Column(
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
              children: bukuPerKategori.entries.map((entry) {
                final kategori = entry.key;
                final bukuList = entry.value.where((buku) {
                  return buku['judul']!.toLowerCase().contains(searchQuery);
                }).toList();

                if (bukuList.isEmpty) return SizedBox();

                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          kategori,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 10),
                      ...bukuList.map((buku) {
                        return Card(
                          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: ListTile(
                            leading: Image.asset(
                              buku['gambar']!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            title: Text(buku['judul']!),
                            trailing: ElevatedButton(
                              onPressed: () => pinjamBuku(buku['judul']!),
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
