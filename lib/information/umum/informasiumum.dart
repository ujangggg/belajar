import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TebuProblem {
  final String title;
  final String description;
  final String solution;

  TebuProblem({
    required this.title,
    required this.description,
    required this.solution,
  });
}

class InformasiTebuController extends GetxController {
  final searchText = ''.obs;

  final List<TebuProblem> listInformasi = [
    TebuProblem(
      title: "Tanaman Roboh (Lodging)",
      description: "Batang tidak tegak akibat beban tajuk berlebih atau cuaca.",
      solution:
          "Lakukan pembumbunan lebih awal dan pilih varietas berakar kuat.",
    ),
    TebuProblem(
      title: "Kekurangan Nitrogen",
      description: "Daun hijau pucat hingga kekuningan merata.",
      solution:
          "Aplikasikan pupuk Urea sesuai dosis rekomendasi pada fase vegetatif awal.",
    ),
    TebuProblem(
      title: "Muncul Siwilan",
      description: "Tunas samping tumbuh berlebihan sebelum panen.",
      solution: "Kurangi nitrogen saat fase pematangan (masak).",
    ),
    TebuProblem(
      title: "Kekurangan Kalium (K)",
      description: "Batang lunak, rendemen rendah, dan rentan rebah.",
      solution:
          "Berikan pupuk KCl untuk mempertebal dinding sel dan meningkatkan gula.",
    ),
    TebuProblem(
      title: "Drainase Buruk",
      description: "Akar terendam menyebabkan pembusukan dan kurang oksigen.",
      solution: "Buat parit drainase sedalam 30-50 cm antar barisan.",
    ),
    TebuProblem(
      title: "Tanaman Kerdil",
      description: "Kepadatan tanah menghambat penembusan akar.",
      solution: "Lakukan pengolahan tanah minimal dua kali (bajak dan garu).",
    ),
    TebuProblem(
      title: "Stres Kekeringan",
      description: "Daun menggulung di siang hari.",
      solution: "Tingkatkan efisiensi irigasi atau gunakan mulsa sisa tanaman.",
    ),
    TebuProblem(
      title: "pH Tanah Asam",
      description: "Penyerapan hara terhambat karena pH terlalu rendah.",
      solution: "Berikan kapur pertanian (dolomit) saat pengolahan lahan.",
    ),
    TebuProblem(
      title: "Kekurangan Fosfor (P)",
      description: "Daun hijau keunguan dan tunas lambat tumbuh.",
      solution:
          "Aplikasikan pupuk SP-36 atau TSP saat tanam untuk merangsang akar.",
    ),
    TebuProblem(
      title: "Panen Terlalu Dini",
      description: "Kadar gula belum mencapai titik maksimal.",
      solution: "Lakukan pengujian kadar brix nira sebelum menebang.",
    ),
    TebuProblem(
      title: "Pertumbuhan Gulma",
      description: "Perebutan nutrisi antara gulma dan bibit tebu.",
      solution:
          "Penyiangan mekanis atau aplikasi herbisida selektif tepat waktu.",
    ),
    TebuProblem(
      title: "Kekurangan Magnesium",
      description: "Tepi daun klorosis tapi tulang daun tetap hijau.",
      solution: "Berikan pupuk mengandung Magnesium (seperti Kieserite).",
    ),
    TebuProblem(
      title: "Tanaman Kurang Cahaya",
      description:
          "Batang kurus dan memanjang (etiolasi) karena jarak tanam rapat.",
      solution:
          "Atur jarak tanam yang ideal agar sirkulasi cahaya matahari optimal.",
    ),
    TebuProblem(
      title: "Salinitas Tinggi",
      description: "Tepi daun terbakar/kering karena kadar garam tanah tinggi.",
      solution:
          "Lakukan pencucian lahan (leaching) dengan air irigasi yang cukup.",
    ),
    TebuProblem(
      title: "Kematian Tunas Baru",
      description: "Bibit gagal tumbuh merata setelah tanam.",
      solution:
          "Pastikan bibit memiliki mata tunas yang sehat dan lembap saat ditanam.",
    ),
  ];

  List<TebuProblem> get filteredList {
    if (searchText.value.isEmpty) return listInformasi;

    final q = searchText.value.toLowerCase();

    return listInformasi.where((e) {
      return e.title.toLowerCase().contains(q) ||
          e.description.toLowerCase().contains(q) ||
          e.solution.toLowerCase().contains(q);
    }).toList();
  }
}

class InformasiTebuPage extends StatelessWidget {
  const InformasiTebuPage({super.key});

  final Color primaryGreen = const Color(0xFF2E7D32);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(InformasiTebuController());

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F5),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(controller),

            Expanded(
              child: Obx(() {
                final items = controller.filteredList;

                if (items.isEmpty) {
                  return const Center(
                    child: Text(
                      "Tidak ditemukan",
                      style: TextStyle(color: Colors.black45, fontSize: 13),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 16),
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    return _buildCard(items[i]);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // ================= HEADER COMPACT =================
  Widget _buildHeader(InformasiTebuController controller) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 10, 14, 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _icon(Icons.arrow_back_ios_new, () => Get.back()),
              const Spacer(),
              const Text(
                "Informasi Tebu",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              _icon(Icons.eco, () {}),
            ],
          ),

          const SizedBox(height: 8),

          const Text(
            "Gejala & solusi tanaman",
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),

          const SizedBox(height: 10),

          Container(
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              onChanged: (v) => controller.searchText.value = v,
              style: const TextStyle(fontSize: 13),
              decoration: const InputDecoration(
                isDense:
                    true, // 1. Memaksa TextField mengecil mengikuti ukuran teksnya
                border: InputBorder.none,

                // 2. Menggunakan prefixIcon dengan constraints yang presisi
                prefixIcon: Icon(Icons.search, size: 18),
                prefixIconConstraints: BoxConstraints(
                  minWidth: 36,
                  minHeight: 38, // Menyamakan tinggi area ikon dengan container
                ),

                hintText: "Cari...",
                hintStyle: TextStyle(fontSize: 12),

                // 3. Memberikan sedikit padding vertikal manual untuk menyeimbangkan posisi teks
                contentPadding: EdgeInsets.only(
                  left: 0,
                  right: 10,
                  top:
                      10, // Mengatur posisi teks dari atas (sesuaikan 9-11 jika perlu)
                  bottom: 10, // Mengatur posisi teks dari bawah
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _icon(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 32,
        width: 32,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }

  // ================= CARD COMPACT =================
  Widget _buildCard(TebuProblem data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE6EEE8)),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
        iconColor: const Color(0xFF2E7D32),
        collapsedIconColor: Colors.black45,

        title: Text(
          data.title,
          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
        ),

        children: [
          _block("Deskripsi", data.description),
          const SizedBox(height: 6),
          _block("Solusi", data.solution),
        ],
      ),
    );
  }

  // ================= BLOCK COMPACT =================
  Widget _block(String title, String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F8F4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12.5,
              color: Colors.black54,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
