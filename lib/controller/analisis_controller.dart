import 'package:absen01/model/model_analisis.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';


class AnalisisController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Rx<AnalisisModel?> analisis = Rx<AnalisisModel?>(null);
  RxBool isLoading = false.obs;

  Future<void> hitungAnalisis({
    required String lahanId,
    required DateTime tanggalTanam,
  }) async {
    isLoading.value = true;

    final irigasiSnapshot = await _db
        .collection('irigasi')
        .where('lahanId', isEqualTo: lahanId)
        .get();

    double totalAir = 0;
    for (var doc in irigasiSnapshot.docs) {
      totalAir += (doc['volumeAir'] as num).toDouble();
    }

    final umurHari = DateTime.now().difference(tanggalTanam).inDays;

    String status;
    String rekomendasi;

    if (totalAir < umurHari * 10) {
      status = 'Kurang Air';
      rekomendasi = 'Tambahkan intensitas irigasi';
    } else {
      status = 'Normal';
      rekomendasi = 'Kondisi tanaman baik';
    }

    final data = AnalisisModel(
      lahanId: lahanId,
      umurTanamHari: umurHari,
      totalAir: totalAir,
      statusTanaman: status,
      rekomendasi: rekomendasi,
      terakhirUpdate: DateTime.now(),
    );

    await _db.collection('analisis').doc(lahanId).set(data.toMap());

    analisis.value = data;
    isLoading.value = false;
  }

  void fetchAnalisis(String lahanId) {
    _db.collection('analisis').doc(lahanId).snapshots().listen((doc) {
      if (doc.exists) {
        analisis.value = AnalisisModel.fromMap(doc.data()!);
      }
    });
  }
}
