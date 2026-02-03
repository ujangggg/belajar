import 'package:cloud_firestore/cloud_firestore.dart';

class PupukModel {
  String id;
  String uid; // TAMBAHAN: Identitas pemilik data
  String lahanId;
  DateTime tanggal;
  String jenisPupuk; 
  double jumlah;     
  String metode;     
  String faseTanam;  
  String catatan;

  PupukModel({
    required this.id,
    required this.uid, // Required baru
    required this.lahanId,
    required this.tanggal,
    required this.jenisPupuk,
    required this.jumlah,
    required this.metode,
    required this.faseTanam,
    this.catatan = '',
  });

  factory PupukModel.fromMap(String id, Map<String, dynamic> data) {
    return PupukModel(
      id: id,
      uid: data['uid'] ?? '', // Ambil UID dari Firestore
      lahanId: data['lahanId'] ?? '',
      tanggal: data['tanggal'] != null 
          ? (data['tanggal'] as Timestamp).toDate() 
          : DateTime.now(),
      jenisPupuk: data['jenisPupuk'] ?? '-',
      jumlah: (data['jumlah'] ?? 0).toDouble(),
      metode: data['metode'] ?? '-',
      faseTanam: data['faseTanam'] ?? '-',
      catatan: data['catatan'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid, // Simpan UID
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