import 'dart:io';
import 'package:absen01/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';

import 'dart:convert';

class EditProfilController extends GetxController {
  final nameController = TextEditingController();

  final firestore = FirebaseFirestore.instance;
  final firebaseAuth = fb_auth.FirebaseAuth.instance;

  final ImagePicker picker = ImagePicker();

  final isUploadingPhoto = false.obs;
  final isSavingProfile = false.obs;

  final email = ''.obs;
  final photoBase64 = RxnString();

  @override
  void onInit() {
    super.onInit();
    loadProfileData();
  }

  Future<void> loadProfileData() async {
    final user = firebaseAuth.currentUser;

    if (user == null) return;

    nameController.text = user.displayName ?? '';
    email.value = user.email ?? '';
    photoBase64.value = null;

    try {
      final doc = await firestore.collection('users').doc(user.uid).get();
      final data = doc.data();

      if (data == null) return;

      nameController.text = data['name']?.toString() ?? user.displayName ?? '';
      email.value = data['email']?.toString() ?? user.email ?? '';
      photoBase64.value = data['photoBase64'];
    } catch (e) {
      debugPrint('Load Firestore profile gagal: $e');
    }
  }

  Future<void> uploadPhoto() async {
    try {
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 40,
        maxWidth: 400,
        maxHeight: 400,
      );

      if (picked == null) return;

      isUploadingPhoto.value = true;

      final bytes = await File(picked.path).readAsBytes();

      photoBase64.value = base64Encode(bytes);

      Get.snackbar(
        'Sukses',
        'Foto berhasil dipilih',
        backgroundColor: Colors.white,
        colorText: Colors.black,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Gagal',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUploadingPhoto.value = false;
    }
  }

  Future<void> saveProfile() async {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      Get.snackbar('Gagal', 'User belum login');
      return;
    }

    final name = nameController.text.trim();
    final photo = photoBase64.value;

    if (name.isEmpty) {
      Get.snackbar('Peringatan', 'Nama tidak boleh kosong');
      return;
    }

    try {
      isSavingProfile.value = true;

      final futures = <Future>[
        firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': name,
          'email': user.email,
          'photoBase64': photo,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true)),

        user.updateDisplayName(name),
      ];
      Get.snackbar(
        "Berhasil",
        "Data lahan berhasil disimpan",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white,
        colorText: Colors.black87,
        borderRadius: 12,
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        boxShadows: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
        icon: const Icon(Icons.check_circle, color: Colors.green),
        duration: const Duration(seconds: 2),
        isDismissible: true,
        forwardAnimationCurve: Curves.easeOutBack,
      );
      Get.offAll(() => const HomePage(initialIndex: 3));
    } catch (e) {
      Get.snackbar(
        'Gagal',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(20),
      );
    } finally {
      isSavingProfile.value = false;
    }
  }
}
