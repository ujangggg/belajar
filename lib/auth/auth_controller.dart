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
  final RxnString errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  void _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAllNamed('/login');
    } else {
      Get.offAll(() => const HomePage());
    }
  }

  /// REGISTER
  Future<void> register(String name, String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = cred.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': name,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } on FirebaseAuthException catch (e) {
      errorMessage.value = e.message;
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// LOGIN
  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      errorMessage.value = e.message;
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// UPGRADE: Fungsi Edit Profil (Tetap ada tanpa variabel Rx)
  Future<void> updateProfile(String newName) async {
    try {
      if (firebaseUser.value == null) return;
      isLoading.value = true;

      await _firestore.collection('users').doc(firebaseUser.value!.uid).update({
        'name': newName,
      });
      Get.back();
      Get.snackbar(
        "Berhasil",
        "Profil telah diperbarui",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Update tampilan secara manual setelah sukses
      update();
    } catch (e) {
      Get.snackbar("Gagal", e.toString(), backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  /// LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
  }

  /// Fungsi Ambil Data User (Digunakan oleh FutureBuilder)
  Future<Map<String, dynamic>?> getUserData() async {
    if (firebaseUser.value == null) return null;
    DocumentSnapshot doc =
        await _firestore.collection('users').doc(firebaseUser.value!.uid).get();
    return doc.data() as Map<String, dynamic>?;
  }
}
