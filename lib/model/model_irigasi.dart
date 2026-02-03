class IrigasiModel {
  final String id;
  final String lahanId;
  final DateTime tanggal;
  final String metode;
  final double volumeAir;
  final int durasi;
  final String kondisiTanah;
  final String? catatan;

  IrigasiModel({
    required this.id,
    required this.lahanId,
    required this.tanggal,
    required this.metode,
    required this.volumeAir,
    required this.durasi,
    required this.kondisiTanah,
    this.catatan,
  });

  factory IrigasiModel.fromMap(String id, Map<String, dynamic> map) {
    return IrigasiModel(
      id: id,
      lahanId: map['lahanId'],
      tanggal: DateTime.parse(map['tanggal']),
      metode: map['metode'],
      volumeAir: (map['volumeAir'] as num).toDouble(),
      durasi: map['durasi'],
      kondisiTanah: map['kondisiTanah'],
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
      'kondisiTanah': kondisiTanah,
      'catatan': catatan,
    };
  }
}
