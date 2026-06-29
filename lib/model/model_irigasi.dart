import 'package:cloud_firestore/cloud_firestore.dart';

class IrigasiModel {
  final String id;
  final String uid; // Identitas Pemilik Akun
  final String lahanId; // Relasi ke Koleksi Lahan
  final DateTime tanggal; // Waktu Aktivitas
  final String metode; // Contoh: Manual, Otomatis, Drop
  final double volumeAir; // Dalam Liter
  final int durasi; // Dalam Menit
  final double kelembabanTanah; // Persentase %
  final String kondisiTanah; // Kering, Optimal, Basah
  final String faseTanam; // Tahap pertumbuhan tebu
  final String? catatan; // Opsional

  // --- FIELD TAMBAHAN UNTUK AKURASI DATA ---
  final String? cuaca; // Contoh: Cerah, Mendung, Hujan
  final String? waktu; // Contoh: Pagi, Siang, Sore

  // Di dalam class IrigasiModel
  IrigasiModel({
    required this.id,
    required this.uid,
    required this.lahanId,
    required this.tanggal,
    required this.metode,
    required this.volumeAir,
    required this.durasi,
    this.kelembabanTanah = 0.0, // <-- Hapus 'required', beri nilai default
    required this.kondisiTanah,
    required this.faseTanam,
    this.catatan,
    this.cuaca,
    this.waktu,
  });

  // --- FACTORY FROM MAP (Membaca dari Firestore) ---
  factory IrigasiModel.fromMap(String id, Map<String, dynamic> map) {
    // Fungsi pembantu untuk menangani berbagai tipe data tanggal dari Firebase
    DateTime parseTanggal(dynamic dateData) {
      if (dateData == null) return DateTime.now();
      if (dateData is Timestamp) return dateData.toDate();
      if (dateData is String)
        return DateTime.tryParse(dateData) ?? DateTime.now();
      return DateTime.now();
    }

    return IrigasiModel(
      id: id,
      uid: map['uid'] ?? '',
      lahanId: map['lahanId'] ?? '',
      tanggal: parseTanggal(map['tanggal']),
      metode: map['metode'] ?? 'Manual',
      volumeAir: (map['volumeAir'] ?? 0.0).toDouble(),
      durasi: (map['durasi'] ?? 0).toInt(),
      kelembabanTanah: (map['kelembabanTanah'] ?? 0.0).toDouble(),
      kondisiTanah: map['kondisiTanah'] ?? '-',
      faseTanam: map['faseTanam'] ?? 'Pertumbuhan',
      catatan: map['catatan'] ?? '',
      cuaca: map['cuaca'] ?? 'Cerah', // Default jika null
      waktu: map['waktu'] ?? 'Pagi', // Default jika null
    );
  }

  // --- TO MAP (Menyimpan ke Firestore) ---
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'lahanId': lahanId,
      'tanggal': Timestamp.fromDate(tanggal),
      'metode': metode,
      'volumeAir': volumeAir,
      'durasi': durasi,
      'kelembabanTanah': kelembabanTanah,
      'kondisiTanah': kondisiTanah,
      'faseTanam': faseTanam,
      'catatan': catatan,
      'cuaca': cuaca,
      'waktu': waktu,
    };
  }

  // --- LOGIKA BISNIS ---
  // Ubah menjadi Enum atau daftar yang mudah dipilih
  static String deskripsiTanah(double moisture) {
    if (moisture < 20) return "Sangat Kering (Retak-retak)";
    if (moisture < 60) return "Kering (Perlu Disiram)";
    if (moisture <= 80) return "Lembab (Cukup)";
    return "Basah (Tergenang)";
  }
}
