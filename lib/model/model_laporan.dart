class LaporanModel {
  final String lahanId;
  final String namaLahan;
  final double luas;
  final double totalAir;
  final String statusTanaman;
  final String estimasiPanen;
  final DateTime periode;

  LaporanModel({
    required this.lahanId,
    required this.namaLahan,
    required this.luas,
    required this.totalAir,
    required this.statusTanaman,
    required this.estimasiPanen,
    required this.periode,
  });
}
