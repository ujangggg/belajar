import 'package:absen01/auth/auth_controller.dart';
import 'package:absen01/auth/login.dart';
import 'package:absen01/auth/register.dart';
import 'package:absen01/controller/pupuk_controller.dart';
import 'package:absen01/controller/irigasi_controller.dart';
import 'package:absen01/controller/lahan_controller.dart';
import 'package:absen01/controller/riwayat_controller.dart';
import 'package:absen01/splashscreen.dart';

import 'package:absen01/views/chatAiPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  // Dependency Injection
  Get.put(AuthController(), permanent: true);
  Get.put(LahanController(), permanent: true);
  Get.put(IrigasiController(), permanent: true);
  Get.put(PupukController(), permanent: true);
  Get.put(RiwayatController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SITEBU',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF1B5E20),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B5E20),
          primary: const Color(0xFF1B5E20),
          secondary: const Color(0xFF8DBE54),
        ),
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      ),
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => const SplashView(),
          transition: Transition.fadeIn,
        ),

        GetPage(name: '/login', page: () => const LoginPage()),

        GetPage(name: '/register', page: () => const RegisterPage()),

        GetPage(name: '/home', page: () => const HomePage()),

        GetPage(
          name: '/chat-ai',
          page: () => const GeminiPage(),
          transition: Transition.rightToLeftWithFade,
        ),
      ],
    );
  }
}

class Root extends GetWidget<AuthController> {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = controller.firebaseUser.value;

      if (user != null) {
        return const HomePage();
      } else {
        return const LoginPage();
      }
    });
  }
}
