import 'package:absen01/auth/auth_controller.dart';
import 'package:absen01/model/model_lahan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'dart:async';

class LahanController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  AuthController get _auth => Get.find<AuthController>();

  RxList<LahanModel> lahanList = <LahanModel>[].obs;
  RxBool isLoading = false.obs;
  StreamSubscription? _lahanSubscription;

  @override
  void onInit() {
    super.onInit();
    ever(_auth.firebaseUser, (user) {
      if (user != null) {
        fetchLahan();
      } else {
        _lahanSubscription?.cancel();
        lahanList.clear();
      }
    });
  }

  void fetchLahan() {
    final user = _auth.firebaseUser.value;
    if (user == null) return;

    isLoading.value = true;
    _lahanSubscription?.cancel();

    _lahanSubscription = _db
        .collection('lahan')
        .where('uid', isEqualTo: user.uid)
        .snapshots()
        .listen(
      (snapshot) {
        lahanList.assignAll(
          snapshot.docs.map((doc) => LahanModel.fromMap(doc.id, doc.data())).toList(),
        );
        isLoading.value = false;
      },
      onError: (error) {
        isLoading.value = false;
        print("LahanController Error: $error");
      },
    );
  }

  // 🌟 PERBAIKAN: Mengembalikan Future<bool>
  Future<bool> addLahan(LahanModel lahan) async {
    try {
      isLoading.value = true;
      final user = _auth.firebaseUser.value;
      if (user == null) return false;

      Map<String, dynamic> data = lahan.toMap();
      data['uid'] = user.uid;

      await _db.collection('lahan').add(data);
      Get.snackbar("Sukses", "Lahan baru berhasil didaftarkan!");
      return true; // ⚡ Kembalikan TRUE jika berhasil menambahkan
    } catch (e) {
      print("Error Add Lahan: $e");
      Get.snackbar("Error", "Gagal menambahkan lahan: $e");
      return false; // ⚡ Kembalikan FALSE jika gagal
    } finally {
      isLoading.value = false;
    }
  }

  // 🌟 KUNCI PERBAIKAN UTAMA ADA DI SINI:
  // Fungsi dipastikan bertipe Future<bool> dan wajib mengembalikan nilai TRUE/FALSE
  Future<bool> updateLahan(String id, LahanModel lahan) async {
    try {
      isLoading.value = true;
      
      // Kirim data update ke Firestore
      await _db.collection('lahan').doc(id).update(lahan.toMap());
      
      // Sinkronisasi instan ke local state list agar UI langsung segar
      int index = lahanList.indexWhere((element) => element.id == id);
      if (index != -1) {
        lahanList[index] = lahan;
        lahanList.refresh();
      }

      Get.snackbar("Sukses", "Data lahan berhasil diperbarui!");
      return true; // ⚡ KUNCI: Wajib mengembalikan true agar AddLahan tahu ini sukses dan bisa panggil Get.back()
    } catch (e) {
      print("Error Update Lahan: $e");
      Get.snackbar("Error", "Gagal memperbarui lahan: $e");
      return false; // ⚡ KUNCI: Kembalikan false jika proses gagal/error
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteLahan(String id) async {
    try {
      await _db.collection('lahan').doc(id).delete();
      Get.snackbar("Sukses", "Lahan berhasil dihapus.");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  @override
  void onClose() {
    _lahanSubscription?.cancel();
    super.onClose();
  }
}