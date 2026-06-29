import 'package:absen01/information/penyakit/identifikasi_gejala.dart';
import 'package:absen01/information/penyakit/penyakit_tebu.dart';
import 'package:flutter/material.dart';

class PenyakitMainPage extends StatelessWidget {
  const PenyakitMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF1B5E20);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F5),

      // ================= APPBAR CLEAN =================
      appBar: AppBar(
        title: const Text(
          "Modul Penyakit Tebu",
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
          // ================= HEADER CARD (TERPISAH) =================
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
                  "Pusat Informasi & Diagnosa",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1B5E20),
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Pilih menu untuk mengenali dan mempelajari penyakit pada tanaman tebu secara detail.",
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
            icon: Icons.search_rounded,
            title: "Identifikasi Gejala",
            subtitle: "Kenali penyakit berdasarkan gejala visual di lapangan.",
            color: Colors.orange,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const IdentifikasiPenyakitPage(),
                ),
              );
            },
          ),

          const SizedBox(height: 12),

          // ================= MENU 2 =================
          _menuCard(
            icon: Icons.menu_book_rounded,
            title: "Ensiklopedia Penyakit",
            subtitle: "Data lengkap patogen, gejala, dan pengendalian ilmiah.",
            color: const Color(0xFF2E7D32),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const InformasiPenyakitPage(),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // ================= INFO BOX =================
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F8F4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE6EEE8)),
            ),
            child: const Row(
              children: [
                Icon(Icons.lightbulb_outline, color: Colors.green),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Tips: Gunakan identifikasi gejala untuk diagnosa awal sebelum masuk ke data ilmiah.",
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
