import 'package:absen01/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Rxn<User> firebaseUser = Rxn<User>();
  final RxBool isLoading = false.obs;
  final RxString userRole = "user".obs;

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  void _setInitialScreen(User? user) async {
    if (user == null) {
      Get.offAllNamed('/login');
      return;
    }

    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(user.uid).get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        if (data['isBanned'] == true) {
          await _auth.signOut();
          Get.offAllNamed('/login');

          Get.snackbar(
            "Akses Ditolak",
            "Maaf, akun Anda saat ini sedang dinonaktifkan.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.shade700,
            colorText: Colors.white,
            borderRadius: 15,
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            icon: const Icon(
              Icons.block_flipped,
              color: Colors.white,
              size: 28,
            ),
            shouldIconPulse: true,
            duration: const Duration(seconds: 4),
            snackStyle: SnackStyle.FLOATING,
          );
          return;
        }
      }

      userRole.value = "user";
      Get.offAll(() => const HomePage());
    } catch (e) {
      Get.offAll(() => const HomePage());
    }
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar(
        "Data Tidak Lengkap",
        "Semua kolom harus diisi untuk menjaga keamanan akun tebu Anda.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white,
        colorText: Colors.black87,
      );
      return;
    }

    if (newPassword.length < 6) {
      Get.snackbar(
        "Password Terlalu Pendek",
        "Gunakan minimal 6 karakter agar akun Anda tetap aman.",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (newPassword != confirmPassword) {
      Get.snackbar(
        "Konfirmasi Salah",
        "Password baru dan konfirmasi tidak cocok.",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      isLoading.value = true;

      final user = _auth.currentUser;
      if (user == null || user.email == null) {
        throw 'Sesi login telah berakhir.';
      }

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );

      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);

      isLoading.value = false;

      Get.back();

      Get.snackbar(
        "Berhasil",
        "Kata sandi akun Anda telah diperbarui.",
        snackPosition: SnackPosition.TOP,
      );
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;

      String message = "Gagal memperbarui password.";

      if (e.code == "wrong-password" || e.code == "invalid-credential") {
        message = "Password lama salah.";
      } else if (e.code == "requires-recent-login") {
        message = "Silakan login ulang.";
      }

      Get.snackbar("Gagal", message);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      isLoading.value = true;

      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (cred.user != null) {
        await _firestore.collection('users').doc(cred.user!.uid).set({
          'uid': cred.user!.uid,
          'name': name,
          'email': email.trim(),
          'isBanned': false,
          'createdAt': FieldValue.serverTimestamp(),
        });

        Get.snackbar(
          "Berhasil",
          "Akun berhasil dibuat.",
          snackPosition: SnackPosition.TOP,
        );
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Registrasi Gagal", e.message ?? "Terjadi kesalahan.");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;

      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Login Gagal", e.message ?? "Cek email/password");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    userRole.value = "";
    Get.offAllNamed('/login');
  }

  Future<Map<String, dynamic>?> getUserData() async {
    if (firebaseUser.value == null) return null;

    try {
      DocumentSnapshot doc =
          await _firestore
              .collection('users')
              .doc(firebaseUser.value!.uid)
              .get();

      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      return null;
    }
  }

  Future<void> updateProfile(String newName) async {
    try {
      if (firebaseUser.value == null) return;

      isLoading.value = true;

      await _firestore.collection('users').doc(firebaseUser.value!.uid).update({
        'name': newName,
      });

      Get.back();

      Get.snackbar(
        "Sukses",
        "Profil diperbarui",
        backgroundColor: const Color(0xFF8DBE54),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Gagal",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Stream<Map<String, dynamic>?> getUserStream() {
    final user = firebaseUser.value;

    if (user == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .map((doc) => doc.data());
  }
}
