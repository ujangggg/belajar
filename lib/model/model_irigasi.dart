class IrigasiModel {
  final String id;
  final String lahanId;
  final DateTime tanggal;
  final String metode; // Manual atau Otomatis (berdasarkan jurnal)
  final double volumeAir;
  final int durasi; // Dalam menit
  final double kelembabanTanah; // TAMBAHAN: Data persentase % dari sensor (Jurnal: 0-100%)
  final String kondisiTanah; // Otomatis terisi (Kering, Optimal, Basah)
  final String faseTanam; // TAMBAHAN: Fase awal, pertumbuhan, atau kemasakan
  final String? catatan;

  IrigasiModel({
    required this.id,
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

  // Tambahan helper fungsi untuk menentukan status berdasarkan Jurnal MONTABU
  static String hitungKondisi(double moisture) {
    if (moisture < 16) return "Kering";
    if (moisture >= 70 && moisture <= 80) return "Optimal";
    if (moisture > 80) return "Basah";
    return "Normal";
  }
}