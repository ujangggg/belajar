import 'package:absen01/information/gulma/jenis_gulma.dart';
import 'package:absen01/information/gulma/pengendalian_gulma.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GulmaMainPage extends StatelessWidget {
  const GulmaMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF1B5E20);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F5),

      // ================= APPBAR (BERSIH SAJA) =================
      appBar: AppBar(
        title: const Text(
          "Manajemen Gulma Tebu",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16.5),
        ),
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),

      // ================= BODY =================
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ================= INFO HEADER (TERPISAH DARI APPBAR) =================
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE6EEE8)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Identifikasi & Kontrol Gulma",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1B5E20),
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Gulma dapat menurunkan produktivitas tebu karena bersaing dalam air, cahaya, dan unsur hara. Pengelolaan yang tepat sangat penting sejak awal pertumbuhan.",
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ================= MENU 1 =================
          _menuCard(
            icon: Icons.grass,
            title: "Jenis-Jenis Gulma",
            subtitle:
                "Mengenali gulma rumput, teki, dan daun lebar di lahan tebu.",
            color: const Color(0xFF2E7D32),
            onTap: () => Get.to(() => const JenisGulmaPage()),
          ),

          const SizedBox(height: 12),

          // ================= MENU 2 =================
          _menuCard(
            icon: Icons.handyman,
            title: "Pengendalian Gulma",
            subtitle: "Strategi pengendalian manual, mekanis, dan kimiawi.",
            color: Colors.orange,
            onTap: () => Get.to(() => const PengendalianGulmaPage()),
          ),

          const SizedBox(height: 16),

          // ================= INFO BAWAH =================
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F8F4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE6EEE8)),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Color(0xFF2E7D32)),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Fase kritis pengendalian gulma adalah 0–4 bulan pertama setelah tanam.",
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.3,
                      color: Colors.black87,
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

  // ================= MENU CARD =================
  Widget _menuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE6EEE8)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.black38,
            ),
          ],
        ),
      ),
    );
  }
}
