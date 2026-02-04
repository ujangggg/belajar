import 'package:absen01/auth/auth_controller.dart';
import 'package:absen01/auth/login.dart';
import 'package:absen01/auth/register.dart';
import 'package:absen01/controller/pupuk_controller.dart';
import 'package:absen01/controller/irigasi_controller.dart';
import 'package:absen01/controller/lahan_controller.dart';
import 'package:absen01/controller/laporan_controller.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'home.dart';

void main() async {
  // 1. Inisialisasi binding untuk Splash Screen
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // 2. Inisialisasi Firebase
  await Firebase.initializeApp();

  // 3. Dependency Injection (Inject semua controller di awal)
  // Gunakan permanent: true agar controller tidak terhapus saat pindah page
  Get.put(AuthController(), permanent: true);
  Get.put(LahanController(), permanent: true);
  Get.put(IrigasiController(), permanent: true);
  Get.put(PupukController(), permanent: true);
  Get.put(LaporanController(), permanent: true);

  // 4. Hapus Splash Screen setelah inisialisasi selesai
  FlutterNativeSplash.remove();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SITEBU',
      // Setup tema global agar warna hijau konsisten di seluruh aplikasi
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.green,
        primaryColor: const Color(0xFF1B5E20),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B5E20),
          primary: const Color(0xFF1B5E20),
          secondary: const Color(0xFF2E7D32),
        ),
      ),
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/', 
          page: () => const Root(),
          transition: Transition.fadeIn, // Animasi perpindahan halus
        ),
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/register', page: () => const RegisterPage()),
        GetPage(name: '/home', page: () => const HomePage()),
      ],
    );
  }
}

// Root untuk redirect otomatis berdasarkan status Login Firebase
class Root extends GetWidget<AuthController> {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Pantau status user secara real-time
      final user = controller.firebaseUser.value;
      
      if (user != null) {
        return const HomePage();
      } else {
        return const LoginPage();
      }
    });
  }
}