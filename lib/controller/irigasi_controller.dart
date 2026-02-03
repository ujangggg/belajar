import 'package:absen01/model/model_irigasi.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart'; // Tambahkan ini untuk akses warna/ikon
import 'package:get/get.dart';

class IrigasiController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  RxList<IrigasiModel> irigasiList = <IrigasiModel>[].obs;
  RxString selectedLahanId = ''.obs;
  RxBool isLoading = false.obs;

  RxDouble latestHumidity = 0.0.obs;
  RxString latestCondition = '-'.obs;

  void fetchIrigasiByLahan(String lahanId) {
    selectedLahanId.value = lahanId;
    isLoading.value = true;

    _db
        .collection('irigasi')
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
      onError: (error) {
        isLoading.value = false;
        Get.snackbar(
          "Error",
          "Gagal mengambil data irigasi: $error",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  /// Menambah data irigasi baru
  Future<void> addIrigasi(IrigasiModel irigasi) async {
    try {
      // Kita tidak set isLoading = true di sini agar tidak mengganggu UI yang sudah Get.back()
      
      String kondisiOtomatis = IrigasiModel.hitungKondisi(irigasi.kelembabanTanah);
      
      final dataBaru = {
        ...irigasi.toMap(),
        'kondisiTanah': kondisiOtomatis,
      };

      await _db.collection('irigasi').add(dataBaru);
      
      // Notifikasi Sukses yang lebih keren
      Get.snackbar(
        "Berhasil Simpan",
        "Data irigasi lahan berhasil dicatat ke sistem",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1B5E20), // Hijau Tua sesuai tema
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        margin: const EdgeInsets.all(15),
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        "Gagal Menyimpan",
        "Terjadi kesalahan koneksi: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade800,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    }
  }

  Future<void> deleteIrigasi(String id) async {
    try {
      await _db.collection('irigasi').doc(id).delete();
      Get.snackbar(
        "Hapus Berhasil",
        "Data irigasi telah dihapus dari riwayat",
        backgroundColor: Colors.orange.shade800,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar("Gagal", e.toString(), backgroundColor: Colors.red);
    }
  }
}