import 'package:cloud_firestore/cloud_firestore.dart';

class LahanModel {
  final String id;
  final String uid;
  final String namaLahan;
  final String lokasi;
  final double luas;
  final String varietas;
  final DateTime tanggalTanam;
  final String status;
  final String jenisTanah;
  final String? idSensor;

  LahanModel({
    required this.id,
    required this.uid,
    required this.namaLahan,
    required this.lokasi,
    required this.luas,
    required this.varietas,
    required this.tanggalTanam,
    required this.status,
    required this.jenisTanah,
    this.idSensor,
  });

  factory LahanModel.fromMap(String id, Map<String, dynamic> map) {
    // Fungsi pembantu untuk handle tanggal yang fleksibel
    DateTime parseTanggal(dynamic dateData) {
      if (dateData == null) return DateTime.now();
      if (dateData is Timestamp) return dateData.toDate(); // Jika tipe Firebase Timestamp
      if (dateData is String) return DateTime.tryParse(dateData) ?? DateTime.now(); // Jika tipe String
      return DateTime.now();
    }

    return LahanModel(
      id: id,
      uid: map['uid'] ?? '',
      namaLahan: map['namaLahan'] ?? 'Tanpa Nama',
      lokasi: map['lokasi'] ?? '-',
      luas: (map['luas'] ?? 0).toDouble(),
      varietas: map['varietas'] ?? '-',
      tanggalTanam: parseTanggal(map['tanggalTanam']),
      status: map['status'] ?? 'aktif',
      jenisTanah: map['jenisTanah'] ?? 'Lempung',
      idSensor: map['idSensor'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'namaLahan': namaLahan,
      'lokasi': lokasi,
      'luas': luas,
      'varietas': varietas,
      // Lebih disarankan simpan sebagai Timestamp agar mudah di-query di Firebase
      'tanggalTanam': Timestamp.fromDate(tanggalTanam), 
      'status': status,
      'jenisTanah': jenisTanah,
      'idSensor': idSensor,
    };
  }

  int get usiaBulan {
    final diff = DateTime.now().difference(tanggalTanam).inDays;
    return (diff / 30).floor();
  }

  String get fasePertumbuhan {
    int bulan = usiaBulan;
    if (bulan <= 4) return "Fase Awal (0-4 bln)";
    if (bulan <= 9) return "Fase Pertumbuhan";
    return "Fase Kemasakan (Kritis Rendemen)";
  }
}