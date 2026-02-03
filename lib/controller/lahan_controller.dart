import 'package:absen01/model/model_lahan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
        .orderBy('namaLahan')
        .snapshots()
        .listen(
          (snapshot) {
            lahanList.value = snapshot.docs
                .map((doc) => LahanModel.fromMap(doc.id, doc.data()))
                .toList();
            isLoading.value = false;
          },
          onError: (error) {
            isLoading.value = false;
            Get.snackbar("Error", "Gagal mengambil data lahan: $error",
                backgroundColor: Colors.red, colorText: Colors.white);
          },
        );
  }

  Future<bool> addLahan(LahanModel lahan) async {
    try {
      isLoading.value = true;
      await _db.collection('lahan').add(lahan.toMap());
      
      // Notifikasi Berhasil
      Get.snackbar(
        "Berhasil", 
        "Lahan ${lahan.namaLahan} berhasil didaftarkan",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        duration: const Duration(seconds: 3),
      );
      return true; // Mengembalikan true agar UI tahu proses selesai
    } catch (e) {
      Get.snackbar("Gagal Simpan", "Terjadi kesalahan: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateLahan(LahanModel lahan) async {
    try {
      isLoading.value = true;
      await _db.collection('lahan').doc(lahan.id).update(lahan.toMap());
      Get.snackbar("Sukses", "Data lahan berhasil diperbarui",
          backgroundColor: Colors.blue, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Gagal Update", e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteLahan(String lahanId) async {
    try {
      await _db.collection('lahan').doc(lahanId).delete();
      Get.snackbar("Sukses", "Lahan telah dihapus",
          backgroundColor: Colors.orange, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Gagal Hapus", e.toString());
    }
  }

  List<LahanModel> get lahanFaseKritis {
    return lahanList.where((l) => l.fasePertumbuhan.contains("Kemasakan")).toList();
  }

  double get totalLuasLahan {
    return lahanList.fold(0, (sum, item) => sum + item.luas);
  }
}