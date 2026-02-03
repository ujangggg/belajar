import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthController _authController = Get.find();

  // Reactive loading & error
  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString(); // ⚡ RxnString untuk nullable

  /// VALIDASI INPUT
  bool validate() {
    final name = namaController.text.trim();
    final email = emailController.text.trim();
    final pass = passwordController.text.trim();

    if (name.isEmpty) {
      errorMessage.value = 'Nama tidak boleh kosong';
      return false;
    }
    if (email.isEmpty ||
        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      errorMessage.value = 'Email tidak valid';
      return false;
    }
    if (pass.isEmpty || pass.length < 6) {
      errorMessage.value = 'Password minimal 6 karakter';
      return false;
    }
    return true;
  }

  /// REGISTER
  Future<void> register() async {
    if (!validate()) return;

    isLoading.value = true;
    errorMessage.value = null;

    try {
      await _authController.register(
        namaController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      // Setelah register, AuthController akan otomatis trigger authStateChanges
      // dan navigasi ke HomePage
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1B5E20), Color(0xFF43A047), Color(0xFFFBC02D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const Icon(Icons.grass, size: 90, color: Colors.white),
                  const SizedBox(height: 12),
                  const Text(
                    'SITEBU',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'Dari lahan ke Gula, Semua Lebih Mudah',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 25),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Nama
                        TextField(
                          controller: namaController,
                          decoration: InputDecoration(
                            hintText: 'Nama Lengkap',
                            prefixIcon: const Icon(Icons.person),
                            filled: true,
                            fillColor: const Color(0xFFF3F3F3),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Email
                        TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            prefixIcon: const Icon(Icons.email),
                            filled: true,
                            fillColor: const Color(0xFFF3F3F3),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Password
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            prefixIcon: const Icon(Icons.lock),
                            filled: true,
                            fillColor: const Color(0xFFF3F3F3),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Error message
                        Obx(() {
                          if (errorMessage.value == null)
                            return const SizedBox.shrink();
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              errorMessage.value!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        }),
                        const SizedBox(height: 8),
                        // Register button
                        Obx(() {
                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isLoading.value ? null : register,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1B5E20),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child:
                                  isLoading.value
                                      ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                      : const Text(
                                        'DAFTAR',
                                        style: TextStyle(color: Colors.white),
                                      ),
                            ),
                          );
                        }),
                        const SizedBox(height: 16),
                        // Navigasi Login
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text(
                            'Sudah punya akun? Login',
                            style: TextStyle(color: Color(0xFF1B5E20)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
