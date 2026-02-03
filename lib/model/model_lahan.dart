class LahanModel {
  final String id;
  final String namaLahan;
  final String lokasi;
  final double luas;
  final String varietas;
  final DateTime tanggalTanam;
  final String status;
  final String jenisTanah; // TAMBAHAN BARU
  final String? idSensor;  // TAMBAHAN BARU (Bisa null jika belum ada alat)

  LahanModel({
    required this.id,
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
    return LahanModel(
      id: id,
      namaLahan: map['namaLahan'] ?? 'Tanpa Nama',
      lokasi: map['lokasi'] ?? '-',
      luas: (map['luas'] ?? 0).toDouble(),
      varietas: map['varietas'] ?? '-',
      tanggalTanam: map['tanggalTanam'] != null
          ? DateTime.parse(map['tanggalTanam'])
          : DateTime.now(),
      status: map['status'] ?? 'aktif',
      jenisTanah: map['jenisTanah'] ?? 'Lempung', // Ambil dari Firebase
      idSensor: map['idSensor'], // Ambil dari Firebase
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
      'jenisTanah': jenisTanah, // Simpan ke Firebase
      'idSensor': idSensor,    // Simpan ke Firebase
    };
  }

  // --- LOGIKA OTOMATIS BERDASARKAN JURNAL MONTABU ---

  /// Menghitung usia tanaman dalam bulan secara real-time
  int get usiaBulan {
    final diff = DateTime.now().difference(tanggalTanam).inDays;
    return (diff / 30).floor();
  }

  /// Menentukan fase secara otomatis (Penting untuk rekomendasi air)
  String get fasePertumbuhan {
    int bulan = usiaBulan;
    if (bulan <= 4) return "Fase Awal (0-4 bln)";
    if (bulan <= 9) return "Fase Pertumbuhan";
    return "Fase Kemasakan (Kritis Rendemen)";
  }
}