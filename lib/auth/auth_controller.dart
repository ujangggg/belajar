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
  final RxnString errorMessage = RxnString();
  
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
    } else {
      try {
        DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
        
        if (doc.exists) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          String role = data['role'] ?? "user"; 
          userRole.value = role;

          if (role == "admin") {
            Get.offAll(() => const AdminPage());
          } else {
            Get.offAll(() => const HomePage());
          }
        } else {
          Get.offAll(() => const HomePage());
        }
      } catch (e) {
        Get.offAll(() => const HomePage());
      }
    }
  }

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
          'role': 'user',
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
      update();
    } catch (e) {
      Get.snackbar("Gagal", e.toString(), backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  /// LOGOUT DENGAN NOTIFIKASI
  Future<void> logout() async {
    try {
      await _auth.signOut();
      userRole.value = ""; 
      
      Get.snackbar(
        "Logout Berhasil",
        "Anda telah keluar dari akun SITEBU",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1B5E20),
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        margin: const EdgeInsets.all(15),
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar("Error", "Gagal logout: $e");
    }
  }

  Future<Map<String, dynamic>?> getUserData() async {
    if (firebaseUser.value == null) return null;
    DocumentSnapshot doc =
        await _firestore.collection('users').doc(firebaseUser.value!.uid).get();
    return doc.data() as Map<String, dynamic>?;
  }
}