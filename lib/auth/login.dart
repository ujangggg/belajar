import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthController _authController = Get.find();
  final RxBool obscurePassword = true.obs;
  final RxBool isLoading = false.obs;

  Future<void> login() async {
    isLoading.value = true;
    try {
      await _authController.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
    } catch (e) {
      Get.snackbar("Error", "Login gagal. Periksa kembali akun Anda.");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/login.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                children: [
                  Expanded(
                    flex: 32,
                    child: _buildHeader(),
                  ),
                  Expanded(
                    flex: 48,
                    child: Center(
                      child: _buildLoginCard(),
                    ),
                  ),
                  Expanded(
                    flex: 20,
                    child: _buildFooter(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
              ),
            ],
          ),
          child: Image.asset(
            'assets/logo_login.png',
            height: 48,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'TEBU',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 5,
            shadows: [
              Shadow(
                blurRadius: 8,
                color: Colors.black54,
                offset: Offset(0, 3),
              ),
            ],
          ),
        ),
        const Text(
          'MAJU, PANEN MELIMPAH',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Color(0xFFC5E1A5),
            letterSpacing: 1.5,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          width: 45,
          height: 3,
          decoration: BoxDecoration(
            color: Color(0xFF74A14E),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const Text(
          'Dari Bibit Sampai Panen,\nSemua Lebih Mudah Dengan Sitebu',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 11,
            height: 1.25,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Selamat Datang!',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B4332),
            ),
          ),
          const SizedBox(height: 16),
          _buildField(
            controller: emailController,
            hint: "Username / Email",
            icon: Icons.person_outline_rounded,
          ),
          const SizedBox(height: 12),
          Obx(
            () => _buildField(
              controller: passwordController,
              hint: "Kata Sandi",
              icon: Icons.lock_outline_rounded,
              isPassword: true,
              obscure: obscurePassword.value,
              toggleObscure: () => obscurePassword.toggle(),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: Obx(
              () => ElevatedButton(
                onPressed: isLoading.value ? null : login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5A8B3C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 2,
                ),
                child: isLoading.value
                    ? const SizedBox(
                        height: 19,
                        width: 19,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Masuk Sekarang',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Belum punya akun? ",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                  ),
                ),
                InkWell(
                  onTap: () => Get.toNamed('/register'),
                  child: const Text(
                    "Daftar Disini",
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
  }) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(
            icon,
            color: const Color(0xFF5A8B3C),
            size: 21,
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscure ? Icons.visibility_off : Icons.visibility,
                    size: 20,
                  ),
                  onPressed: toggleObscure,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildFooterItem(Icons.eco_outlined, "Monitoring"),
        _buildFooterItem(Icons.analytics_outlined, "Manajemen"),
        _buildFooterItem(Icons.cloud_outlined, "Cuaca"),
      ],
    );
  }

  Widget _buildFooterItem(IconData icon, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 21,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}