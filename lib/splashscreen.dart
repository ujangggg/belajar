import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'main.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 4), () {
      Get.off(() => const Root());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Container(
        width: double.infinity,
        height: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8FFF4), Colors.white],
          ),
        ),

        child: Stack(
          children: [
            // Background sawah di bawah
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Image.asset('assets/splash_bg.png', fit: BoxFit.fitWidth),
            ),

            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo
                        Container(
                          width: 140,
                          height: 140,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 15,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.agriculture,
                              size: 70,
                              color: Color(0xFF1B5E20),
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        const Text(
                          'SITEBU',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B5E20),
                            letterSpacing: 2,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Container(
                          width: 60,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Color(0xFF8DBE54),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),

                        const SizedBox(height: 18),

                        Text(
                          'Smart Garden Ecosystem',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          'Sistem Informasi Budidaya Tebu',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),

                        const SizedBox(height: 30),

                        const SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Color(0xFF1B5E20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
