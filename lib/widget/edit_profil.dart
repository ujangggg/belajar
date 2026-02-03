import 'package:absen01/auth/auth_controller.dart';
import 'package:absen01/logo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfilPage extends StatelessWidget {
  EditProfilPage({super.key});

  final AuthController authC = Get.find();
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan AppBar standar agar tombol back otomatis ada
      appBar: AppBar(
        title: const Text("Edit Profil", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1B5E20),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: authC.getUserData(),
        builder: (context, snapshot) {
          // 1. Tampilan saat loading ambil data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF1B5E20)),
            );
          }

          // 2. Isi data ke controller jika berhasil ambil data
          if (snapshot.hasData && nameController.text.isEmpty) {
            nameController.text = snapshot.data?['name'] ?? "";
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                /// FOTO PROFIL (Visual Only)
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: const Color(0xFF2E7D32),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          // Menggunakan AssetImage untuk memanggil logo SITEBU
                          backgroundImage: const AssetImage(
                            'assets/logo_sitebu.jpeg',
                          ),
                          // backgroundImage otomatis menutupi CircleAvatar,
                          // jadi Icon di child sebelumnya bisa dihapus.
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                /// INPUT NAMA LENGKAP
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Nama Lengkap",
                    prefixIcon: const Icon(
                      Icons.badge_outlined,
                      color: Color(0xFF1B5E20),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF1B5E20),
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                /// INFO EMAIL (Non-Editable)
                TextField(
                  enabled: false,
                  controller: TextEditingController(
                    text: snapshot.data?['email'] ?? "",
                  ),
                  decoration: InputDecoration(
                    labelText: "Email",
                    prefixIcon: const Icon(Icons.email_outlined),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                /// TOMBOL SIMPAN (Dengan Obx untuk handle Loading)
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B5E20),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon:
                          authC.isLoading.value
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : const Icon(
                                Icons.save_rounded,
                                color: Colors.white,
                              ),
                      label: Text(
                        authC.isLoading.value
                            ? "Menyimpan..."
                            : "Simpan Perubahan",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed:
                          authC.isLoading.value
                              ? null
                              : () async {
                                if (nameController.text.trim().isNotEmpty) {
                                  await authC.updateProfile(
                                    nameController.text.trim(),
                                  );
                                  // Get.back() sudah ditangani di updateProfile,
                                  // tapi jika belum, bisa tambahkan Get.back() di sini.
                                  Get.back();
                                } else {
                                  Get.snackbar(
                                    "Peringatan",
                                    "Nama tidak boleh kosong",
                                    backgroundColor: Colors.amber,
                                    icon: const Icon(
                                      Icons.warning,
                                      color: Colors.white,
                                    ),
                                  );
                                }
                              },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
