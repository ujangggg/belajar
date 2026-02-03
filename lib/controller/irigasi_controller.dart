import 'package:absen01/model/model_irigasi.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';


class IrigasiController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  RxList<IrigasiModel> irigasiList = <IrigasiModel>[].obs;
  RxString selectedLahanId = ''.obs;
  RxBool isLoading = false.obs;

  void fetchIrigasiByLahan(String lahanId) {
    selectedLahanId.value = lahanId;
    isLoading.value = true;

    _db
        .collection('irigasi')
        .where('lahanId', isEqualTo: lahanId)
        .orderBy('tanggal', descending: true)
        .snapshots()
        .listen((snapshot) {
      irigasiList.value = snapshot.docs
          .map((doc) => IrigasiModel.fromMap(doc.id, doc.data()))
          .toList();
      isLoading.value = false;
    });
  }

  Future<void> addIrigasi(IrigasiModel irigasi) async {
    await _db.collection('irigasi').add(irigasi.toMap());
  }
}
