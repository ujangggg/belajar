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
    // Fungsi internal untuk konversi tanggal yang tangguh
    DateTime parseDate(dynamic date) {
      if (date == null) return DateTime.now();
      if (date is Timestamp) return date.toDate();
      if (date is String) return DateTime.tryParse(date) ?? DateTime.now();
      return DateTime.now();
    }

    return LahanModel(
      id: id,
      uid: map['uid'] ?? '',
      namaLahan: map['namaLahan'] ?? 'Tanpa Nama',
      lokasi: map['lokasi'] ?? '-',
      luas: (map['luas'] ?? 0).toDouble(),
      varietas: map['varietas'] ?? '-',
      tanggalTanam: parseDate(map['tanggalTanam']),
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
      'tanggalTanam': Timestamp.fromDate(tanggalTanam), // Simpan sebagai Timestamp
      'status': status,
      'jenisTanah': jenisTanah,
      'idSensor': idSensor,
    };
  }
}