class AnalisisModel {
  final String lahanId;
  final int umurTanamHari;
  final double totalAir;
  final String statusTanaman;
  final String rekomendasi;
  final DateTime terakhirUpdate;

  AnalisisModel({
    required this.lahanId,
    required this.umurTanamHari,
    required this.totalAir,
    required this.statusTanaman,
    required this.rekomendasi,
    required this.terakhirUpdate,
  });

  factory AnalisisModel.fromMap(Map<String, dynamic> map) {
    return AnalisisModel(
      lahanId: map['lahanId'],
      umurTanamHari: map['umurTanamHari'],
      totalAir: (map['totalAir'] as num).toDouble(),
      statusTanaman: map['statusTanaman'],
      rekomendasi: map['rekomendasi'],
      terakhirUpdate: DateTime.parse(map['terakhirUpdate']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lahanId': lahanId,
      'umurTanamHari': umurTanamHari,
      'totalAir': totalAir,
      'statusTanaman': statusTanaman,
      'rekomendasi': rekomendasi,
      'terakhirUpdate': terakhirUpdate.toIso8601String(),
    };
  }
}
