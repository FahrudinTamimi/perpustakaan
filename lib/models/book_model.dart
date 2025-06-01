class Book {
  final String id;
  final String code;
  final String title;
  final String author;
  final String publisher;
  final String year;
  final String status;
  final String description;
  final String category;
  final int totalQuantity;
  final int availableQuantity;
  final String dateInput;
  final String photo;

  Book({
    required this.id,
    required this.code,
    required this.title,
    required this.author,
    required this.publisher,
    required this.year,
    required this.status,
    required this.description,
    required this.category,
    required this.totalQuantity,
    required this.availableQuantity,
    required this.dateInput,
    required this.photo,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id']?.toString() ?? '',
      code: json['kode_buku'] ?? '',
      title: json['judul_buku'] ?? '',
      author: json['penulis'] ?? '',
      publisher: json['penerbit'] ?? '',
      year: json['tahun_terbit'] ?? '',
      status: json['status'] ?? '',
      description: json['deskripsi'] ?? '',
      category: json['kategori'] ?? '',
      totalQuantity: int.tryParse(json['jumlah_total'] ?? '0') ?? 0,
      availableQuantity: int.tryParse(json['jumlah_tersedia'] ?? '0') ?? 0,
      dateInput: json['tanggal_input'] ?? '',
      photo: json['foto'] ?? '',
    );
  }

  String get photoUrl {
    if (photo.startsWith('http')) return photo;
    if (photo.contains('storage')) {
      return 'http://10.0.2.2:8000/$photo';
    }
    return 'http://10.0.2.2:8000/storage/$photo';
  }

  // HAPUS ATAU KOMENTARI BARIS DI BAWAH INI
  // get judulBuku => null;
}
