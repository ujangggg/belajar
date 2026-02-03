import 'package:cloud_firestore/cloud_firestore.dart';

class PupukModel {
  String id;
  String lahanId;
  DateTime tanggal;
  String jenisPupuk; // Contoh: Urea, ZA, NPK, Organik
  double jumlah;     // Dalam Kg
  String metode;     // Contoh: Tabur, Kocor, Benam
  String faseTanam;  // Contoh: Awal, Pertumbuhan
  String catatan;

  PupukModel({
    required this.id,
    required this.lahanId,
    required this.tanggal,
    required this.jenisPupuk,
    required this.jumlah,
    required this.metode,
    required this.faseTanam,
    this.catatan = '',
  });

  // Convert dari Map (Firestore) ke Object
  factory PupukModel.fromMap(String id, Map<String, dynamic> data) {
    return PupukModel(
      id: id,
      lahanId: data['lahanId'] ?? '',
      tanggal: (data['tanggal'] as Timestamp).toDate(),
      jenisPupuk: data['jenisPupuk'] ?? '-',
      jumlah: (data['jumlah'] ?? 0).toDouble(),
      metode: data['metode'] ?? '-',
      faseTanam: data['faseTanam'] ?? '-',
      catatan: data['catatan'] ?? '',
    );
  }

  // Convert dari Object ke Map untuk disimpan di Firestore
  Map<String, dynamic> toMap() {
    return {
      'lahanId': lahanId,
      'tanggal': Timestamp.fromDate(tanggal),
      'jenisPupuk': jenisPupuk,
      'jumlah': jumlah,
      'metode': metode,
      'faseTanam': faseTanam,
      'catatan': catatan,
    };
  }
}