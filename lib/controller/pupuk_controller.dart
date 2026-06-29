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
        .where('uid', isEqualTo: currentUid)
        .where('lahanId', isEqualTo: lahanId)
        .orderBy('tanggal', descending: true)
        .snapshots()
        .listen(
          (snapshot) {
            pupukList.value =
                snapshot.docs
                    .map((doc) => PupukModel.fromMap(doc.id, doc.data()))
                    .toList();
            isLoading.value = false;
          },
          onError: (error) {
            isLoading.value = false;
            // Menggunakan debugPrint agar tidak mengganggu antrean UI/Snackbar saat pertama kali setup index
            debugPrint("Firestore Error di fetchPupukByLahan: $error");
          },
        );
  }

  // BERHASIL DIPERBAIKI: Bersih dari snackbar sukses & melempar error ke UI
  Future<void> addPupuk(PupukModel pupuk) async {
    try {
      await _db.collection('pemupukan').add(pupuk.toMap());
    } catch (e) {
      // Wajib di-throw agar try-catch di halaman AddPemupukan tahu kalau ini gagal
      throw Exception(e.toString());
    }
  }

  Future<void> deletePupuk(String id) async {
    try {
      await _db.collection('pemupukan').doc(id).delete();
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
