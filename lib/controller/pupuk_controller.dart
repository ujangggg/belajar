
import 'package:absen01/model/model_pupuk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PupukController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  RxList<PupukModel> pupukList = <PupukModel>[].obs;
  RxBool isLoading = false.obs;

  // Mengambil histori pemupukan berdasarkan lahan tertentu
  void fetchPupukByLahan(String lahanId) {
    isLoading.value = true;
    _db
        .collection('pemupukan')
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
        Get.snackbar("Error", "Gagal mengambil data pupuk: $error",
            backgroundColor: Colors.red, colorText: Colors.white);
      },
    );
  }

  /// Menambah data pemupukan baru (Instan & Background)
  Future<void> addPupuk(PupukModel pupuk) async {
    try {
      // Langsung simpan ke Firebase tanpa set isLoading = true agar tidak mengganggu UI
      await _db.collection('pemupukan').add(pupuk.toMap());

      // Notifikasi sukses dengan tema hijau
      Get.snackbar(
        "Berhasil",
        "Data pemupukan ${pupuk.jenisPupuk} berhasil disimpan",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1B5E20),
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        "Gagal",
        "Gagal menyimpan data pupuk: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade800,
        colorText: Colors.white,
      );
    }
  }

  /// Menghapus data pemupukan
  Future<void> deletePupuk(String id) async {
    try {
      await _db.collection('pemupukan').doc(id).delete();
      Get.snackbar(
        "Dihapus",
        "Data pemupukan telah dihapus",
        backgroundColor: Colors.orange.shade800,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red);
    }
  }
}