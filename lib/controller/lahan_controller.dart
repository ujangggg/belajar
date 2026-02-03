import 'package:absen01/auth/auth_controller.dart';
import 'package:absen01/model/model_lahan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LahanController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  
  // Gunakan getter agar lebih aman saat memanggil AuthController
  AuthController get _auth => Get.find<AuthController>();

  RxList<LahanModel> lahanList = <LahanModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Monitor status user secara terus menerus
    ever(_auth.firebaseUser, (user) {
      if (user != null) {
        print("LahanController: User Terdeteksi (${user.uid}), mengambil data...");
        fetchLahan();
      } else {
        lahanList.clear();
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    // Dipanggil setelah semua controller terpasang di memori
    fetchLahan();
  }

  void fetchLahan() {
    final user = _auth.firebaseUser.value;
    
    if (user == null) {
      print("LahanController: Gagal Fetch - User is NULL");
      return;
    }

    String currentUid = user.uid;
    isLoading.value = true;

    // Gunakan Stream agar real-time
    _db
        .collection('lahan')
        .where('uid', isEqualTo: currentUid)
        .snapshots()
        .listen(
          (snapshot) {
            print("LahanController: Berhasil menarik ${snapshot.docs.length} dokumen");
            lahanList.value = snapshot.docs
                .map((doc) => LahanModel.fromMap(doc.id, doc.data()))
                .toList();
            isLoading.value = false;
          },
          onError: (error) {
            isLoading.value = false;
            print("LahanController Error: $error");
          },
        );
  }

  Future<bool> addLahan(LahanModel lahan) async {
    try {
      isLoading.value = true;
      final user = _auth.firebaseUser.value;
      if (user == null) return false;

      // Pastikan UID ikut tersimpan
      Map<String, dynamic> data = lahan.toMap();
      data['uid'] = user.uid;

      await _db.collection('lahan').add(data);
      return true;
    } catch (e) {
      print("Error Add Lahan: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteLahan(String id) async {
    try {
      await _db.collection('lahan').doc(id).delete();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}