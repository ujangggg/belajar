import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthController _authController = Get.find();
  final RxBool obscurePassword = true.obs;
  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();

  bool validate() {
    final name = namaController.text.trim();
    final email = emailController.text.trim();
    final pass = passwordController.text.trim();

    if (name.isEmpty) {
      errorMessage.value = 'Nama tidak boleh kosong';
      return false;
    }
    if (email.isEmpty || !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      errorMessage.value = 'Email tidak valid';
      return false;
    }
    if (pass.isEmpty || pass.length < 6) {
      errorMessage.value = 'Password minimal 6 karakter';
      return false;
    }
    return true;
  }

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
    } catch (e) {
      errorMessage.value = "Pendaftaran gagal. Silakan coba lagi.";
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false, // Anti-overflow saat keyboard muncul
      body: Stack(
        children: [
          // --- 1. BACKGROUND (Sama dengan Login) ---
          Positioned.fill(
            child: Image.asset(
              'assets/login.png', // Menggunakan asset yang sama agar senada
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),

          // --- 2. LAYER KONTEN ---
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  // --- ATAS: Logo & Teks Judul ---
                  SizedBox(height: screenHeight * 0.04),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
                    ),
                    child: Image.asset('assets/logo_login.png', height: 60),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'DAFTAR',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 4,
                      shadows: [
                        Shadow(blurRadius: 10, color: Colors.black54, offset: const Offset(0, 4))
                      ],
                    ),
                  ),
                  const Text(
                    'BERGABUNG DENGAN EKOSISTEM SITEBU',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFC5E1A5),
                      letterSpacing: 1.5,
                    ),
                  ),

                  const Spacer(),

                  // --- TENGAH: Kartu Register (Ukuran Pas Isi) ---
                  Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(35),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15)
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Buat Akun Baru',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1B4332)),
                        ),
                        const SizedBox(height: 15),

                        // Field Nama
                        _buildField(
                          controller: namaController,
                          hint: "Nama Lengkap",
                          icon: Icons.person_outline_rounded,
                        ),
                        const SizedBox(height: 12),

                        // Field Email
                        _buildField(
                          controller: emailController,
                          hint: "Email",
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 12),

                        // Field Password
                        Obx(() => _buildField(
                          controller: passwordController,
                          hint: "Kata Sandi",
                          icon: Icons.lock_outline_rounded,
                          isPassword: true,
                          obscure: obscurePassword.value,
                          toggleObscure: () => obscurePassword.toggle(),
                        )),

                        // Error Message Area
                        Obx(() => errorMessage.value != null
                            ? Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  errorMessage.value!,
                                  style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                                ),
                              )
                            : const SizedBox(height: 10)),

                        const SizedBox(height: 10),

                        // Tombol Daftar
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: Obx(() => ElevatedButton(
                            onPressed: isLoading.value ? null : register,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF5A8B3C),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              elevation: 2,
                            ),
                            child: isLoading.value
                                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                : const Text('Daftar Sekarang', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                          )),
                        ),

                        const SizedBox(height: 15),

                        // Link ke Login
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Sudah punya akun? ", style: TextStyle(color: Colors.black54, fontSize: 13)),
                            InkWell(
                              onTap: () => Get.back(),
                              child: const Text(
                                "Masuk Disini",
                                style: TextStyle(
                                  color: Color(0xFF2D6A4F),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // --- BAWAH: Footer (Konsisten dengan Login) ---
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildFooterItem(Icons.security_outlined, "Aman"),
                        _buildFooterItem(Icons.speed_outlined, "Cepat"),
                        _buildFooterItem(Icons.help_outline_rounded, "Bantuan"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscure = false,
    VoidCallback? toggleObscure,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFFF1F5F1), borderRadius: BorderRadius.circular(15)),
      child: TextField(
        controller: controller,
        obscureText: isPassword && obscure,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: const Color(0xFF5A8B3C), size: 22),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, size: 20, color: Colors.grey),
                  onPressed: toggleObscure)
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildFooterItem(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    );
  }
}