import 'package:absen01/model/model_lahan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class LahanController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  RxList<LahanModel> lahanList = <LahanModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLahan();
  }

  void fetchLahan() {
    isLoading.value = true;
    _db
        .collection('lahan')
        .orderBy('namaLahan') // Opsional: Biar rapi berurutan
        .snapshots()
        .listen(
          (snapshot) {
            lahanList.value =
                snapshot.docs
                    .map((doc) => LahanModel.fromMap(doc.id, doc.data()))
                    .toList();

            // Pastikan loading berhenti setelah data diterima (meskipun list kosong)
            isLoading.value = false;
          },
          onError: (error) {
            isLoading.value = false;
            Get.snackbar("Error", "Gagal mengambil data: $error");
          },
        );
  }

  // Tambahkan async-await dan proteksi error
  Future<void> addLahan(LahanModel lahan) async {
    try {
      // Gunakan toMap() untuk kirim data ke Firebase
      await _db.collection('lahan').add(lahan.toMap());
    } catch (e) {
      Get.snackbar("Gagal Simpan", e.toString());
      rethrow; // Lempar error ke UI agar UI tahu proses gagal
    }
  }

  Future<void> updateLahan(LahanModel lahan) async {
    try {
      await _db.collection('lahan').doc(lahan.id).update(lahan.toMap());
    } catch (e) {
      Get.snackbar("Gagal Update", e.toString());
    }
  }

  Future<void> deleteLahan(String lahanId) async {
    try {
      await _db.collection('lahan').doc(lahanId).delete();
    } catch (e) {
      Get.snackbar("Gagal Hapus", e.toString());
    }
  }
}
