import 'package:absen01/model/model_lahan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';


class LaporanController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  RxList<Map<String, dynamic>> laporanList = <Map<String, dynamic>>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    generateLaporan();
  }

  Future<void> generateLaporan() async {
    isLoading.value = true;
    laporanList.clear();

    final lahanSnapshot = await _db.collection('lahan').get();

    for (var lahanDoc in lahanSnapshot.docs) {
      final lahan = LahanModel.fromMap(lahanDoc.id, lahanDoc.data());

      // Ambil analisis
      final analisisDoc =
          await _db.collection('analisis').doc(lahan.id).get();

      // Ambil irigasi
      final irigasiSnapshot = await _db
          .collection('irigasi')
          .where('lahanId', isEqualTo: lahan.id)
          .get();

      double totalAir = 0;
      for (var i in irigasiSnapshot.docs) {
        totalAir += (i['volumeAir'] as num).toDouble();
      }

      laporanList.add({
        'namaLahan': lahan.namaLahan,
        'luas': lahan.luas,
        'varietas': lahan.varietas,
        'totalAir': totalAir,
        'status': analisisDoc.exists
            ? analisisDoc['statusTanaman']
            : 'Belum dianalisis',
        'umur': analisisDoc.exists
            ? analisisDoc['umurTanamHari']
            : 0,
        'rekomendasi': analisisDoc.exists
            ? analisisDoc['rekomendasi']
            : '-',
      });
    }

    isLoading.value = false;
  }
}
