import 'package:absen01/information/hama/gejala.dart';
import 'package:absen01/information/hama/hama.dart';
import 'package:absen01/information/hama/musuhalami.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HamaMainPage extends StatelessWidget {
  const HamaMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF1B5E20);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F5),

      // ================= APPBAR =================
      appBar: AppBar(
        title: const Text(
          "Modul Hama Tebu",
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
          // ================= HEADER BOX =================
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
                  "Pusat Informasi & Diagnosa Hama",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1B5E20),
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Pilih menu untuk mengenali, memahami, dan mengendalikan hama pada tanaman tebu.",
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
            icon: Icons.search,
            title: "Identifikasi Gejala",
            subtitle: "Kenali hama berdasarkan tanda fisik di lapangan.",
            color: Colors.orange,
            onTap: () => Get.to(() => const HamaGejalaPage()),
          ),

          const SizedBox(height: 12),

          // ================= MENU 2 =================
          _menuCard(
            icon: Icons.bug_report,
            title: "Informasi Hama Tebu",
            subtitle: "Data lengkap jenis hama dan penjelasan ilmiah.",
            color: Colors.red,
            onTap: () => Get.to(() => const HamaInformasiPage()),
          ),

          const SizedBox(height: 12),

          // ================= MENU 3 =================
          _menuCard(
            icon: Icons.shield,
            title: "Musuh Alami Hama",
            subtitle: "Pengendalian hayati menggunakan predator alami.",
            color: Colors.teal,
            onTap: () => Get.to(() => const HamaMusuhAlamiPage()),
          ),

          const SizedBox(height: 16),

          // ================= TIP BOX =================
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F8F4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE6EEE8)),
            ),
            child: const Row(
              children: [
                Icon(Icons.lightbulb_outline, color: Color(0xFF1B5E20)),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Gunakan fitur AI Chat untuk diagnosa cepat melalui foto hama di lapangan.",
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
