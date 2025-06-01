class Anggota {
  final int? id; // Tambahkan tanda tanya (?) untuk nullable
  final String? nama;
  final String? kelas;
  final String? alamat;
  final String? noHp;
  final String? email;
  final String? status;

  Anggota({
    this.id,
    this.nama,
    this.kelas,
    this.alamat,
    this.noHp,
    this.email,
    this.status,
  });

  factory Anggota.fromJson(Map<String, dynamic> json) {
    return Anggota(
      id: json['id'],
      nama: json['nama'],
      kelas: json['kelas'],
      alamat: json['alamat'],
      noHp: json['no_hp'],
      email: json['email'],
      status: json['status'],
    );
  }
}
