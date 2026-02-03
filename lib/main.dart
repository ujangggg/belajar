import 'package:absen01/auth/auth_controller.dart';
import 'package:absen01/auth/login.dart';
import 'package:absen01/auth/register.dart';
import 'package:absen01/controller/analisis_controller.dart';
import 'package:absen01/controller/irigasi_controller.dart';
import 'package:absen01/controller/lahan_controller.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(AuthController());
  Get.put(LahanController());
  Get.put(IrigasiController());
  Get.put(AnalisisController());
  // Jika ada AuthController, masukkan juga
  // Get.put(AuthController()) // inisialisasi controller
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const Root()), // root redirect otomatis
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/register', page: () => const RegisterPage()),
        GetPage(name: '/home', page: () => const HomePage()),
      ],
    );
  }
}

// Root untuk redirect sesuai status login
class Root extends GetWidget<AuthController> {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // gunakan firebaseUser dari AuthController
      final user = controller.firebaseUser.value;
      if (user != null) {
        return const HomePage();
      } else {
        return const LoginPage();
      }
    });
  }
}
