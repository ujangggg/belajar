import 'package:flutter/material.dart';

class PanduanTebuPage extends StatelessWidget {
  const PanduanTebuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeader(),
        const SizedBox(height: 20),
        _buildPanduanCard(
          title: "1. Pemilihan Bibit",
          icon: Icons.grass,
          content:
              "Gunakan bibit unggul yang bebas dari hama penyakit. Jenis bibit yang disarankan adalah bibit bagal (2-3 mata tunas) atau bibit pucuk dari tanaman yang berumur 6-7 bulan.",
        ),
        _buildPanduanCard(
          title: "2. Pengolahan Tanah",
          icon: Icons.landscape,
          content:
              "Tanah harus dibajak sedalam 20-30 cm agar perakaran tebu bisa tumbuh maksimal. Pastikan sistem drainase (got) dibuat dengan benar agar air tidak menggenang.",
        ),
        _buildPanduanCard(
          title: "3. Pengairan (Irigasi)",
          icon: Icons.water_drop,
          content:
              "Tebu sangat butuh air di fase awal pertumbuhan (0-4 bulan). Gunakan data irigasi di aplikasi ini untuk memantau jadwal penyiraman.",
        ),
        _buildPanduanCard(
          title: "4. Pemupukan",
          icon: Icons.science,
          content:
              "Berikan pupuk Urea, TSP/SP-36, dan KCl sesuai dosis. Pemupukan pertama dilakukan saat umur 1 bulan, dan pemupukan kedua saat umur 3 bulan.",
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: const Row(
        children: [
          Icon(Icons.menu_book, size: 50, color: Colors.green),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "E-Panduan Budidaya",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text("Teknik terbaik untuk hasil panen maksimal."),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPanduanCard({
    required String title,
    required IconData icon,
    required String content,
  }) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: Icon(icon, color: Colors.green[700]),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(content, textAlign: TextAlign.justify),
          ),
        ],
      ),
    );
  }
}