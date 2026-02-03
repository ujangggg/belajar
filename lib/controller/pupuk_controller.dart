import 'package:absen01/auth/auth_controller.dart';
import 'package:absen01/model/model_pupuk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PupukController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final AuthController _auth = Get.find<AuthController>();

  RxList<PupukModel> pupukList = <PupukModel>[].obs;
  RxBool isLoading = false.obs;

  void fetchPupukByLahan(String lahanId) {
    String? currentUid = _auth.firebaseUser.value?.uid;
    if (currentUid == null) return;

    isLoading.value = true;
    _db
        .collection('pemupukan')
        .where('uid', isEqualTo: currentUid) // FILTER PER USER
        .where('lahanId', isEqualTo: lahanId)
        .orderBy('tanggal', descending: true)
        .snapshots()
        .listen(
      (snapshot) {
        pupukList.value = snapshot.docs
            .map((doc) => PupukModel.fromMap(doc.id, doc.data()))
            .toList();
        isLoading.value = false;
      },
      onError: (error) {
        isLoading.value = false;
        Get.snackbar("Error", "Gagal mengambil data: $error",
            backgroundColor: Colors.red, colorText: Colors.white);
      },
    );
  }

  Future<void> addPupuk(PupukModel pupuk) async {
    try {
      await _db.collection('pemupukan').add(pupuk.toMap());
      Get.snackbar(
        "Berhasil",
        "Data pemupukan ${pupuk.jenisPupuk} dicatat",
        backgroundColor: const Color(0xFF1B5E20),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar("Gagal", e.toString(), backgroundColor: Colors.red);
    }
  }

  Future<void> deletePupuk(String id) async {
    try {
      await _db.collection('pemupukan').doc(id).delete();
      Get.snackbar("Dihapus", "Data pemupukan telah dihapus", backgroundColor: Colors.orange);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}