import 'package:absen01/auth/auth_controller.dart'; // Import Auth
import 'package:absen01/model/model_irigasi.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IrigasiController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final AuthController _auth = Get.find<AuthController>(); // Inisialisasi Auth

  RxList<IrigasiModel> irigasiList = <IrigasiModel>[].obs;
  RxString selectedLahanId = ''.obs;
  RxBool isLoading = false.obs;

  RxDouble latestHumidity = 0.0.obs;
  RxString latestCondition = '-'.obs;

  void fetchIrigasiByLahan(String lahanId) {
    String? currentUid = _auth.firebaseUser.value?.uid;
    if (currentUid == null) return;

    selectedLahanId.value = lahanId;
    isLoading.value = true;

    _db
        .collection('irigasi')
        .where('uid', isEqualTo: currentUid) // FILTER PER USER
        .where('lahanId', isEqualTo: lahanId)
        .orderBy('tanggal', descending: true)
        .snapshots()
        .listen(
      (snapshot) {
        irigasiList.value = snapshot.docs
            .map((doc) => IrigasiModel.fromMap(doc.id, doc.data()))
            .toList();

        if (irigasiList.isNotEmpty) {
          latestHumidity.value = irigasiList.first.kelembabanTanah;
          latestCondition.value = irigasiList.first.kondisiTanah;
        }
        isLoading.value = false;
      },
    );
  }

  Future<void> addIrigasi(IrigasiModel irigasi) async {
    try {
      await _db.collection('irigasi').add(irigasi.toMap());
      
      Get.snackbar(
        "Berhasil Simpan",
        "Data irigasi berhasil dicatat",
        backgroundColor: const Color(0xFF1B5E20),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar("Gagal", e.toString(), backgroundColor: Colors.red);
    }
  }

  Future<void> deleteIrigasi(String id) async {
    try {
      await _db.collection('irigasi').doc(id).delete();
      Get.snackbar("Terhapus", "Data telah dihapus", backgroundColor: Colors.orange);
    } catch (e) {
      Get.snackbar("Gagal", e.toString());
    }
  }
}