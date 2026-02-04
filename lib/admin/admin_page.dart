import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth/auth_controller.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();

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
          child: Column(
            children: [
              // --- UI HELPER: HEADER SECTION ---
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Dashboard Admin",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Kelola ekosistem SITEBU",
                          style: TextStyle(color: Colors.white.withOpacity(0.8)),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.logout, color: Colors.white),
                        onPressed: () {
                          // Dialog Konfirmasi Logout
                          Get.defaultDialog(
                            title: "Konfirmasi Keluar",
                            middleText: "Apakah Anda yakin ingin keluar dari Admin Panel?",
                            textConfirm: "Ya, Keluar",
                            textCancel: "Batal",
                            confirmTextColor: Colors.white,
                            buttonColor: const Color(0xFFB71C1C),
                            onConfirm: () {
                              Get.back(); // Tutup dialog
                              authC.logout(); // Jalankan logout
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // --- MAIN CONTENT ---
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF4F6F5),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Ringkasan Sistem",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B5E20),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Grid Statistik
                        GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _buildStatCard(
                              title: "Total Petani",
                              collection: "users",
                              icon: Icons.people,
                              color: Colors.blue,
                            ),
                            _buildStatCard(
                              title: "Total Lahan",
                              collection: "lahan",
                              icon: Icons.landscape,
                              color: Colors.green,
                            ),
                            _buildStatCard(
                              title: "Laporan Masuk",
                              collection: "laporan",
                              icon: Icons.assignment,
                              color: Colors.orange,
                            ),
                            _buildStatCard(
                              title: "Aktivitas Air",
                              collection: "irigasi",
                              icon: Icons.water_drop,
                              color: Colors.cyan,
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),
                        const Text(
                          "Manajemen Data",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B5E20),
                          ),
                        ),
                        const SizedBox(height: 12),

                        _buildAdminMenu(
                          title: "Daftar Seluruh Lahan",
                          subtitle: "Pantau perkembangan tebu nasional",
                          icon: Icons.view_list,
                          onTap: () {},
                        ),
                        _buildAdminMenu(
                          title: "Validasi Laporan",
                          subtitle: "Verifikasi kiriman data petani",
                          icon: Icons.verified_user,
                          onTap: () {},
                        ),
                        _buildAdminMenu(
                          title: "Pengaturan Sistem",
                          subtitle: "Hak akses dan konfigurasi",
                          icon: Icons.settings,
                          onTap: () {},
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({required String title, required String collection, required IconData icon, required Color color}) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(collection).snapshots(),
      builder: (context, snapshot) {
        String count = snapshot.hasData ? snapshot.data!.docs.length.toString() : "...";
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 30),
              ),
              const SizedBox(height: 8),
              Text(
                count,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600], fontSize: 11),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAdminMenu({required String title, required String subtitle, required IconData icon, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
          )
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF1B5E20).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF1B5E20)),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 12),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        onTap: onTap,
      ),
    );
  }
}