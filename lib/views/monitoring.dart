
import 'package:absen01/monitoring/analisis_page.dart';
import 'package:absen01/monitoring/irigasi_page.dart';
import 'package:absen01/monitoring/lahan_page.dart';
import 'package:absen01/monitoring/pupuk_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MonitoringMainPage extends StatelessWidget {
  const MonitoringMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- HEADER VISUAL (DIKECILKAN) ---
            _buildVisualHeader(),

            const SizedBox(height: 20),

            // --- CONTENT SECTION ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Monitoring Dashboard",
                    style: TextStyle(
                      fontSize: 18, // Sedikit lebih kecil
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B4332),
                    ),
                  ),
                  Text(
                    "Pantau kondisi budidaya tebu secara real-time",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                  const SizedBox(height: 15),

                  // GRID MENU MONITORING
                  _buildMonitoringCard(
                    title: "Monitoring Lahan",
                    subtitle: "Cek pH & kelembapan tanah",
                    icon: Icons.landscape_rounded,
                    color: const Color(0xFF5A8B3C),
                    onTap: () => Get.to(() => LahanPage()),
                  ),
                  _buildMonitoringCard(
                    title: "Sistem Irigasi",
                    subtitle: "Jadwal & kontrol pengairan",
                    icon: Icons.water_drop_rounded,
                    color: const Color(0xFF40916C),
                    onTap: () => Get.to(() => IrigasiPage()),
                  ),
                  _buildMonitoringCard(
                    title: "Status Pemupukan",
                    subtitle: "Riwayat & dosis pupuk",
                    icon: Icons.science_rounded,
                    color: const Color(0xFF74A14E),
                    onTap:
                        () => Get.to(
                          () => PemupukanPage(),
                        ), // Pastikan nama class benar
                  ),
                  _buildMonitoringCard(
                    title: "Analisis Pertumbuhan",
                    subtitle: "Prediksi hasil panen",
                    icon: Icons.auto_graph_rounded,
                    color: const Color(0xFF2D6A4F),
                    onTap: () => Get.to(() => AnalisisPage()),
                  ),

                  const SizedBox(height: 20),

                  // INFO hgBANNER (LEBIH TIPIS)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B4332),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Color(0xFFC5E1A5),
                          size: 20,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "jangan lupa pantau terus untuk perkembangan tebu anda  .",
                            style: TextStyle(color: Colors.white, fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisualHeader() {
    return Container(
      height: 200, // Dikecilkan dari 280
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(35), // Radius dikurangi agar proporsional
          bottomRight: Radius.circular(35),
        ),
        image: DecorationImage(
          image: AssetImage('assets/lahan.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(35),
            bottomRight: Radius.circular(35),
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.2),
              const Color(0xFF1B4332).withOpacity(0.85),
            ],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pusat Kendali",
              style: TextStyle(
                color: Color(0xFFC5E1A5),
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 1.5,
              ),
            ),
            Text(
              "Budidaya Tebu",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24, // Dikecilkan dari 30
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonitoringCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12), // Jarak antar kartu dikurangi
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        elevation: 1, // Shadow lebih halus
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 12,
            ), // Padding lebih rapat
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10), // Padding ikon dikecilkan
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 22,
                  ), // Ikon dikecilkan dari 28
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14, // Dikecilkan dari 16
                          color: Color(0xFF1B4332),
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 11, // Dikecilkan dari 12
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey.shade300,
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
