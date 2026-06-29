import 'package:absen01/home.dart';
import 'package:absen01/admin/admin_page.dart';
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
    // Menggunakan debounce agar navigasi tidak bertabrakan saat aplikasi baru terbuka
    ever(firebaseUser, _setInitialScreen);
  }

  void _setInitialScreen(User? user) async {
    if (user == null) {
      Get.offAllNamed('/login');
    } else {
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
              "Maaf, akun Anda saat ini sedang dinonaktifkan oleh admin.",
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
              isDismissible: true,
              snackStyle: SnackStyle.FLOATING,
              forwardAnimationCurve: Curves.easeOutBack,
              reverseAnimationCurve: Curves.easeInCirc,
              boxShadows: [
                BoxShadow(
                  color: Colors.red.shade900.withOpacity(0.4),
                  offset: const Offset(0, 4),
                  blurRadius: 8,
                ),
              ],
            );
            return;
          }

          String role = data['role'] ?? "user";
          userRole.value = role;

          if (role == "admin") {
            Get.offAll(() => const AdminPage());
          } else {
            Get.offAll(() => const HomePage());
          }
        } else {
          // Jika dokumen tidak ada di Firestore (user baru/error sync)
          Get.offAll(() => const HomePage());
        }
      } catch (e) {
        Get.offAll(() => const HomePage());
      }
    }
  }

  // --- FUNGSI RESET PASSWORD (BARU) ---
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    // 1. Validasi Input Ringan (Tanpa Loading)
    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar(
        "Data Tidak Lengkap",
        "Semua kolom harus diisi untuk menjaga keamanan akun tebu Anda.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white,
        colorText: Colors.black87,
        borderRadius: 15,
        margin: const EdgeInsets.all(15),
        borderColor: Colors.orange.shade100,
        borderWidth: 1,
        icon: Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700),
        shouldIconPulse: true,
        duration: const Duration(seconds: 3),
        isDismissible: true,
        forwardAnimationCurve: Curves.easeOutBack,
      );
      return;
    }

    if (newPassword.length < 6) {
      Get.snackbar(
        "Password Terlalu Pendek",
        "Gunakan minimal 6 karakter agar akun Anda tetap aman.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white,
        colorText: Colors.black87,
        borderRadius: 15,
        margin: const EdgeInsets.all(15),
        borderColor: Colors.orange.shade100,
        borderWidth: 1,
        icon: Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700),
        shouldIconPulse: true,
        duration: const Duration(seconds: 3),
        isDismissible: true,
        forwardAnimationCurve: Curves.easeOutBack,
      );
      return;
    }

    if (newPassword != confirmPassword) {
      Get.snackbar(
        "Konfirmasi Salah",
        "Password baru dan konfirmasi tidak cocok.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white,
        colorText: Colors.black87,
        borderRadius: 15,
        margin: const EdgeInsets.all(15),
        borderColor: Colors.orange.shade100,
        borderWidth: 1,
        icon: Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700),
        shouldIconPulse: true,
        duration: const Duration(seconds: 3),
        isDismissible: true,
        forwardAnimationCurve: Curves.easeOutBack,
      );
      return;
    }

    try {
      // 2. Mulai Loading
      isLoading.value = true;

      final user = _auth.currentUser;
      if (user == null || user.email == null) {
        throw 'Sesi login telah berakhir. Silakan login kembali.';
      }

      // 3. Re-Autentikasi (Cek Password Lama ke Firebase)
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );

      // Menunggu verifikasi dari server Google
      await user.reauthenticateWithCredential(credential);

      // 4. Update Password Baru
      await user.updatePassword(newPassword);

      // 5. EKSEKUSI SELESAI: Langsung matikan loading dan kembali
      isLoading.value = false;

      Get.back(); // Langsung tutup halaman Change Password

      // Tampilkan pesan sukses di halaman tujuan (biasanya Profil)
      Get.snackbar(
        "Berhasil",
        "Kata sandi akun Anda telah diperbarui.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white, // Latar belakang putih bersih
        colorText: Colors.black87, // Teks hitam agar mudah dibaca
        icon: const Icon(
          Icons.check_circle_rounded,
          color: Color(
            0xFF2E7D32,
          ), // Ikon tetap hijau untuk memberi kesan sukses
          size: 30,
        ),
        margin: const EdgeInsets.all(15),
        borderRadius: 15,
        borderWidth: 1,
        borderColor: Colors.grey.shade200, // Border tipis agar terlihat elegan
        duration: const Duration(seconds: 3),
        snackStyle: SnackStyle.FLOATING,
        forwardAnimationCurve: Curves.easeOutBack,
        boxShadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08), // Bayangan lembut
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      );
    } on FirebaseAuthException catch (e) {
      isLoading.value = false; // Matikan loading jika error

      String message = "Gagal memperbarui password.";
      if (e.code == "wrong-password" || e.code == "invalid-credential") {
        message = "Password lama yang Anda masukkan salah.";
      } else if (e.code == "requires-recent-login") {
        message = "Aksi ini butuh login ulang demi keamanan.";
      } else if (e.code == "network-request-failed") {
        message = "Koneksi internet tidak stabil. Coba lagi di area terbuka.";
      }

      Get.snackbar(
        "Gagal",
        message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent.shade700,
        colorText: Colors.white,
        borderRadius: 15,
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        icon: const Icon(
          Icons.error_outline_rounded,
          color: Colors.white,
          size: 28,
        ),
        duration: const Duration(seconds: 4),
        isDismissible: true,
        snackStyle: SnackStyle.FLOATING,
        forwardAnimationCurve: Curves.easeOutBack,
        boxShadows: [
          BoxShadow(
            color: Colors.red.shade900.withOpacity(0.3),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      );
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        "Terjadi Kesalahan",
        e.toString(), // Pesan error teknis
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade800,
        colorText: Colors.white,
        borderRadius: 15,
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        icon: const Icon(
          Icons.bug_report_rounded,
          color: Colors.white,
          size: 28,
        ),
        duration: const Duration(
          seconds: 5,
        ), // Error biasanya butuh waktu lebih lama dibaca
        isDismissible: true,
        snackStyle: SnackStyle.FLOATING,
        forwardAnimationCurve: Curves.easeOutBack,
        boxShadows: [
          BoxShadow(
            color: Colors.red.shade900.withOpacity(0.3),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      );
    } finally {
      // Memastikan loading berhenti meskipun terjadi error tak terduga
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
          'role': 'user',
          'isBanned': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
        Get.snackbar(
          "Berhasil",
          "Akun Anda telah berhasil dibuat. Selamat bergabung!",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.white, // Latar putih bersih
          colorText: Colors.black87, // Teks hitam
          borderRadius: 15,
          margin: const EdgeInsets.all(15),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          icon: const Icon(
            Icons.verified_user_rounded,
            color: Color(
              0xFF2E7D32,
            ), // Ikon hijau tetap ada sebagai aksen sukses
            size: 28,
          ),
          duration: const Duration(seconds: 3),
          isDismissible: true,
          snackStyle: SnackStyle.FLOATING,
          forwardAnimationCurve: Curves.easeOutBack,
          borderWidth: 1,
          borderColor: Colors.grey.shade200,
          boxShadows: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08), // Bayangan lembut
              offset: const Offset(0, 4),
              blurRadius: 10,
            ),
          ],
        );
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Registrasi Gagal",
        e.message ??
            "Terjadi kesalahan yang tidak terduga, silakan coba lagi nanti.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
        borderRadius: 15,
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.white,
          size: 28,
        ),
        duration: const Duration(seconds: 4),
        isDismissible: true,
        snackStyle: SnackStyle.FLOATING,
        forwardAnimationCurve: Curves.easeOutBack,
        boxShadows: [
          BoxShadow(
            color: Colors.red.shade900.withOpacity(0.3),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      );
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
      Get.snackbar(
        "Login Gagal",
        e.message ?? "Cek email/password",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
        borderRadius: 15,
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.white,
          size: 28,
        ),
        duration: const Duration(seconds: 4),
        isDismissible: true,
        snackStyle: SnackStyle.FLOATING,
        forwardAnimationCurve: Curves.easeOutBack,
        boxShadows: [
          BoxShadow(
            color: Colors.red.shade900.withOpacity(0.3),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      );
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
      // Refresh user data secara lokal jika perlu
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
    if (user == null) return const Stream.empty();

    return _firestore
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .map((doc) => doc.data());
  }
}
