import 'package:absen01/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    // Listen auth changes
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  void _setInitialScreen(User? user) {
    if (user == null) {
      // User logout
      Get.offAllNamed('/login');
    } else {
      // User login
      Get.offAll(() => const HomePage());
    }
  }

  /// REGISTER: FirebaseAuth + Firestore
  Future<void> register(String name, String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      // 1️⃣ Buat user di FirebaseAuth
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = cred.user;
      if (user != null) {
        // 2️⃣ Simpan data tambahan ke Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': name,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });

        firebaseUser.value = user; // trigger authStateChanges
      }
    } on FirebaseAuthException catch (e) {
      errorMessage.value = e.message;
      rethrow;
    } catch (e) {
      errorMessage.value = e.toString();
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

      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      firebaseUser.value = cred.user;
    } on FirebaseAuthException catch (e) {
      errorMessage.value = e.message;
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
  }

  /// Optional: ambil data user dari Firestore
  Future<Map<String, dynamic>?> getUserData() async {
    if (firebaseUser.value == null) return null;
    DocumentSnapshot doc =
        await _firestore.collection('users').doc(firebaseUser.value!.uid).get();
    return doc.data() as Map<String, dynamic>?;
  }
}
