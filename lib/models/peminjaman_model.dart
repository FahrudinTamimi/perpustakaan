import 'package:perpustakaan/models/book_model.dart';

class Peminjaman {
  final int id;
  final int idBuku;
  final int idAnggota;
  final String? tanggalPinjam;
  final String? tanggalKembali;
  final String? status;
  final Book? buku; // Relasi ke model Book

  Peminjaman({
    required this.id,
    required this.idBuku,
    required this.idAnggota,
    this.tanggalPinjam,
    this.tanggalKembali,
    this.status,
    this.buku,
  });

  factory Peminjaman.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? bookData = json['buku'];
    if (bookData == null) {
      return Peminjaman(
        id: json['id'] as int,
        idBuku: int.parse(json['id_buku'].toString()),
        idAnggota: int.parse(json['id_anggota'].toString()),
        tanggalPinjam: json['tanggal_pinjam'],
        tanggalKembali: json['tanggal_kembali'],
        status: json['status'],
        buku: null,
      );
    }

    return Peminjaman(
      id: json['id'] as int,
      idBuku: int.parse(json['id_buku'].toString()),
      idAnggota: int.parse(json['id_anggota'].toString()),
      tanggalPinjam: json['tanggal_pinjam'],
      tanggalKembali: json['tanggal_kembali'],
      status: json['status'],
      buku: Book.fromJson(bookData),
    );
  }
}
