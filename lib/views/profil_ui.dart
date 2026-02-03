import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:absen01/auth/auth_controller.dart'; // Sesuaikan path ini

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  // Memanggil AuthController yang sudah di-inject
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F5),

      body: FutureBuilder<Map<String, dynamic>?>(
        future: authController.getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final userData = snapshot.data;
          final name = userData?['name'] ?? "User";
          final email = userData?['email'] ?? "Email tidak ditemukan";

          return Column(
            children: [
              const SizedBox(height: 30),
              // Header Profil
              Center(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundColor: const Color(0xFF2E7D32),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            // Pakai icon eco agar nyambung sama logo SITEBU
                            child: Icon(
                              Icons.eco,
                              size: 50,
                              color: Colors.green[800],
                            ),
                          ),
                        ),
                        const CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.camera_alt,
                            size: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      email,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Menu Options
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView(
                    children: [
                      _buildMenuTile(
                        Icons.person_outline,
                        "Edit Profil",
                        () {},
                      ),
                      _buildMenuTile(Icons.history, "Riwayat Aktivitas", () {}),
                      const Divider(height: 30),
                      _buildMenuTile(
                        Icons.logout_rounded,
                        "Keluar dari SITEBU",
                        () => _showLogoutDialog(context),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMenuTile(
    IconData icon,
    String title,
    VoidCallback onTap, {
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.black87),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    Get.defaultDialog(
      title: "Logout",
      middleText: "Yakin ingin keluar dari aplikasi SITEBU?",
      textConfirm: "Ya, Keluar",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        await authController.logout();
        // Get.offAllNamed('/login') sudah dihandle oleh worker 'ever' di controller kamu
      },
    );
  }
}
