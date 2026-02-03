class IrigasiModel {
  final String id;
  final String uid; // TAMBAHAN: Untuk filter per akun
  final String lahanId;
  final DateTime tanggal;
  final String metode; 
  final double volumeAir;
  final int durasi; 
  final double kelembabanTanah; 
  final String kondisiTanah; 
  final String faseTanam; 
  final String? catatan;

  IrigasiModel({
    required this.id,
    required this.uid, // Required baru
    required this.lahanId,
    required this.tanggal,
    required this.metode,
    required this.volumeAir,
    required this.durasi,
    required this.kelembabanTanah,
    required this.kondisiTanah,
    required this.faseTanam,
    this.catatan,
  });

  factory IrigasiModel.fromMap(String id, Map<String, dynamic> map) {
    return IrigasiModel(
      id: id,
      uid: map['uid'] ?? '', // Ambil UID
      lahanId: map['lahanId'] ?? '',
      tanggal: map['tanggal'] != null 
          ? DateTime.parse(map['tanggal']) 
          : DateTime.now(),
      metode: map['metode'] ?? 'Manual',
      volumeAir: (map['volumeAir'] ?? 0.0).toDouble(),
      durasi: map['durasi'] ?? 0,
      kelembabanTanah: (map['kelembabanTanah'] ?? 0.0).toDouble(),
      kondisiTanah: map['kondisiTanah'] ?? '-',
      faseTanam: map['faseTanam'] ?? 'Pertumbuhan',
      catatan: map['catatan'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid, // Simpan UID
      'lahanId': lahanId,
      'tanggal': tanggal.toIso8601String(),
      'metode': metode,
      'volumeAir': volumeAir,
      'durasi': durasi,
      'kelembabanTanah': kelembabanTanah,
      'kondisiTanah': kondisiTanah,
      'faseTanam': faseTanam,
      'catatan': catatan,
    };
  }

  static String hitungKondisi(double moisture) {
    if (moisture < 16) return "Kering";
    if (moisture >= 70 && moisture <= 80) return "Optimal";
    if (moisture > 80) return "Basah";
    return "Normal";
  }
}