class LahanModel {
  final String id;
  final String namaLahan;
  final String lokasi;
  final double luas;
  final String varietas;
  final DateTime tanggalTanam;
  final String status;

  LahanModel({
    required this.id,
    required this.namaLahan,
    required this.lokasi,
    required this.luas,
    required this.varietas,
    required this.tanggalTanam,
    required this.status,
  });

  factory LahanModel.fromMap(String id, Map<String, dynamic> map) {
    return LahanModel(
      id: id,
      namaLahan: map['namaLahan'] ?? 'Tanpa Nama',
      lokasi: map['lokasi'] ?? '-',
      luas: (map['luas'] ?? 0).toDouble(),
      varietas: map['varietas'] ?? '-',
      tanggalTanam:
          map['tanggalTanam'] != null
              ? DateTime.parse(map['tanggalTanam'])
              : DateTime.now(),
      status: map['status'] ?? 'aktif',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'namaLahan': namaLahan,
      'lokasi': lokasi,
      'luas': luas,
      'varietas': varietas,
      'tanggalTanam': tanggalTanam.toIso8601String(),
      'status': status,
    };
  }
}
