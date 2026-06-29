import 'dart:async';
import 'package:absen01/auth/auth_controller.dart';
import 'package:absen01/model/model_irigasi.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IrigasiController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final AuthController _auth = Get.find<AuthController>();

  RxList<IrigasiModel> irigasiList = <IrigasiModel>[].obs;

  RxString selectedLahanId = ''.obs;
  RxBool isLoading = false.obs;

  RxDouble latestHumidity = 0.0.obs;
  RxString latestCondition = '-'.obs;

  StreamSubscription? _irigasiSubscription;

  void fetchIrigasiByLahan(String lahanId) {
    final currentUid = _auth.firebaseUser.value?.uid;
    if (currentUid == null) return;

    selectedLahanId.value = lahanId;
    isLoading.value = true;

    _irigasiSubscription?.cancel();

    _irigasiSubscription = _db
        .collection('irigasi')
        .where('uid', isEqualTo: currentUid)
        .where('lahanId', isEqualTo: lahanId)
        .orderBy('tanggal', descending: true)
        .snapshots()
        .listen(
          (snapshot) {
            final data =
                snapshot.docs
                    .map((doc) => IrigasiModel.fromMap(doc.id, doc.data()))
                    .toList();

            irigasiList.assignAll(data);
            print("DATA IRIGASI MASUK: ${data.length}");

            if (data.isNotEmpty) {
              latestHumidity.value = data.first.kelembabanTanah;
              latestCondition.value = data.first.kondisiTanah;
            } else {
              latestHumidity.value = 0.0;
              latestCondition.value = '-';
            }

            isLoading.value = false;
          },
          onError: (e) {
            isLoading.value = false;
            debugPrint("Firestore Error: $e");
          },
        );
  }

  Future<void> deleteIrigasi(String id) async {
    await _db.collection('irigasi').doc(id).delete();
  }

  Future<void> addIrigasi(IrigasiModel data) async {
    try {
      isLoading.value = true;
      await _db.collection('irigasi').add(data.toMap());
    } catch (e) {
      debugPrint("Error Add: $e");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _irigasiSubscription?.cancel();
    super.onClose();
  }
}
