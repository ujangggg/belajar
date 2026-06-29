import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IdentifikasiPenyakit {
  final String namaPenyakit;
  final String penyebab;
  final String gejala;
  final String dampak;

  IdentifikasiPenyakit({
    required this.namaPenyakit,
    required this.penyebab,
    required this.gejala,
    required this.dampak,
  });
}

class IdentifikasiPenyakitController extends GetxController {
  final searchText = ''.obs;

  final List<IdentifikasiPenyakit> listPenyakit = [
    // 1. Luka Api (Smut)
    IdentifikasiPenyakit(
      namaPenyakit: "Penyakit Luka Api (Smut)",
      penyebab: "Jamur Sporisorium scitamineum",
      gejala:
          "Muncul pucuk berbentuk cambuk hitam yang menonjol berisi spora mudah terbang.",
      dampak:
          "Tanaman kerdil, muncul tunas abnormal, produksi gula turun drastis.",
    ),
    // 2. Mosaik (SCMV)
    IdentifikasiPenyakit(
      namaPenyakit: "Penyakit Mosaik",
      penyebab: "Sugarcane Mosaic Virus",
      gejala:
          "Pola bercak belang hijau-kuning tidak beraturan pada helai daun.",
      dampak:
          "Menurunkan efisiensi fotosintesis dan menghambat pertumbuhan batang.",
    ),
    // 3. Pokkahbung
    IdentifikasiPenyakit(
      namaPenyakit: "Penyakit Pokkahbung",
      penyebab: "Jamur Fusarium moniliforme",
      gejala: "Daun muda terpilin, klorosis, dan pangkal pucuk membusuk.",
      dampak: "Kematian titik tumbuh dan batang tebu menjadi mudah patah.",
    ),
    // 4. Karat Daun
    IdentifikasiPenyakit(
      namaPenyakit: "Penyakit Karat Daun",
      penyebab: "Jamur Puccinia melanocephala",
      gejala: "Bercak memanjang berwarna cokelat kemerahan di kedua sisi daun.",
      dampak: "Daun lebih cepat kering dan mengurangi energi tanaman.",
    ),
    // 5. Scald Daun
    IdentifikasiPenyakit(
      namaPenyakit: "Penyakit Scald Daun",
      penyebab: "Bakteri Xanthomonas albilineans",
      gejala:
          "Garis putih tipis memanjang pada daun, fase lanjut daun tampak terbakar.",
      dampak: "Tanaman layu mendadak dan pembusukan internal batang.",
    ),
    // 6. Busuk Batang Merah
    IdentifikasiPenyakit(
      namaPenyakit: "Busuk Batang Merah",
      penyebab: "Jamur Colletotrichum falcatum",
      gejala:
          "Bagian dalam batang merah dengan bercak putih melintang dan bau asam.",
      dampak: "Kandungan nira rusak dan rendemen gula menurun tajam.",
    ),
    // 7. Ratoon Stunting Disease (RSD)
    IdentifikasiPenyakit(
      namaPenyakit: "Ratoon Stunting Disease",
      penyebab: "Bakteri Leifsonia xyli",
      gejala:
          "Kerdil kronis, muncul bintik kemerahan pada buku-buku batang jika dibelah.",
      dampak: "Penurunan produktivitas yang sangat nyata pada tebu keprasan.",
    ),
    // 8. Busuk Nanas
    IdentifikasiPenyakit(
      namaPenyakit: "Penyakit Busuk Nanas",
      penyebab: "Jamur Ceratocystis paradoxa",
      gejala:
          "Stek bibit gagal berkecambah, jaringan dalam hitam dan berbau nanas busuk.",
      dampak: "Kegagalan pembibitan dan kepadatan populasi tanaman berkurang.",
    ),
    // 9. Bercak Cincin
    IdentifikasiPenyakit(
      namaPenyakit: "Penyakit Bercak Cincin",
      penyebab: "Jamur Leptosphaeria sacchari",
      gejala: "Bercak oval pusat putih/jerami dengan tepi cokelat kemerahan.",
      dampak: "Gangguan fungsi daun dalam fotosintesis jika serangan meluas.",
    ),
    // 10. Penyakit Fiji
    IdentifikasiPenyakit(
      namaPenyakit: "Penyakit Fiji",
      penyebab: "Fiji Disease Virus",
      gejala:
          "Daun kaku, menebal, dan ada bintil kecil (gall) di bawah tulang daun.",
      dampak: "Tanaman tidak tumbuh tinggi dan seringkali mati sebelum panen.",
    ),
    // 11. Bercak Kuning
    IdentifikasiPenyakit(
      namaPenyakit: "Penyakit Bercak Kuning",
      penyebab: "Jamur Mycovellosiella koepkei",
      gejala: "Bercak kuning tidak beraturan pada daun tua.",
      dampak: "Luas permukaan daun efektif berkurang drastis.",
    ),
    // 12. Garis Merah (Red Stripe)
    IdentifikasiPenyakit(
      namaPenyakit: "Penyakit Garis Merah",
      penyebab: "Acidovorax avenae",
      gejala: "Garis merah tua memanjang sejajar dengan tulang daun.",
      dampak: "Dapat memicu pembusukan pucuk pada serangan berat.",
    ),
    // 13. Busuk Akar
    IdentifikasiPenyakit(
      namaPenyakit: "Busuk Akar",
      penyebab: "Kompleks Jamur Pythium spp.",
      gejala: "Akar berwarna cokelat kehitaman dan membusuk.",
      dampak: "Pertumbuhan terhambat karena serapan hara terhenti.",
    ),
    // 14. Penyakit Streak
    IdentifikasiPenyakit(
      namaPenyakit: "Penyakit Streak",
      penyebab: "Streak Virus",
      gejala: "Garis-garis putus pendek berwarna kuning pada helai daun.",
      dampak: "Membuat tanaman lemah dan pertumbuhan stagnan.",
    ),
    // 15. Klorosis Garis
    IdentifikasiPenyakit(
      namaPenyakit: "Penyakit Klorosis Garis",
      penyebab: "Phytoplasma",
      gejala: "Garis kekuningan memanjang dengan batas yang samar.",
      dampak: "Melemahkan vigor tanaman dan menurunkan rendemen.",
    ),
    // 16. Busuk Pangkal
    IdentifikasiPenyakit(
      namaPenyakit: "Penyakit Busuk Pangkal",
      penyebab: "Jamur Thielaviopsis paradoxa",
      gejala: "Pangkal batang di dekat tanah lunak dan berbau fermentasi.",
      dampak: "Batang mudah roboh dan bibit gagal tumbuh.",
    ),
    // 17. Penyakit Mata Mata
    IdentifikasiPenyakit(
      namaPenyakit: "Penyakit Mata Mata",
      penyebab: "Jamur Helminthosporium ocelliferum",
      gejala: "Bercak daun berbentuk menyerupai mata.",
      dampak: "Menurunkan kualitas kesehatan daun secara umum.",
    ),
    // 18. Busuk Pelepah
    IdentifikasiPenyakit(
      namaPenyakit: "Penyakit Busuk Pelepah",
      penyebab: "Jamur Rhizoctonia solani",
      gejala: "Bercak cokelat basah meluas pada pelepah daun bawah.",
      dampak: "Merusak pelepah yang melindungi batang.",
    ),
    // 19. Layu Bakteri
    IdentifikasiPenyakit(
      namaPenyakit: "Penyakit Layu Bakteri",
      penyebab: "Ralstonia solanacearum",
      gejala: "Tanaman layu mendadak tanpa menunjukkan gejala klorosis.",
      dampak: "Kematian tanaman dengan cepat di area yang terinfeksi.",
    ),
    // 20. Antraknosa
    IdentifikasiPenyakit(
      namaPenyakit: "Penyakit Antraknosa",
      penyebab: "Jamur Colletotrichum graminicola",
      gejala: "Bercak hitam memanjang pada daun disertai massa spora.",
      dampak: "Mengurangi kemampuan tanaman untuk berproduksi optimal.",
    ),
  ];

  List<IdentifikasiPenyakit> get filteredList {
    if (searchText.value.isEmpty) {
      return listPenyakit;
    }

    final q = searchText.value.toLowerCase();

    return listPenyakit.where((e) {
      return e.namaPenyakit.toLowerCase().contains(q) ||
          e.penyebab.toLowerCase().contains(q) ||
          e.gejala.toLowerCase().contains(q) ||
          e.dampak.toLowerCase().contains(q);
    }).toList();
  }
}

class IdentifikasiPenyakitPage extends StatelessWidget {
  const IdentifikasiPenyakitPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(IdentifikasiPenyakitController());

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
                      "Data tidak ditemukan",
                      style: TextStyle(color: Colors.black45, fontSize: 13),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 16),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return _buildCard(items[index]);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(IdentifikasiPenyakitController controller) {
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
                "Identifikasi Penyakit",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const Spacer(),

              _icon(Icons.biotech, () {}),
            ],
          ),

          const SizedBox(height: 8),

          const Text(
            "Kenali gejala dan dampaknya",
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
      borderRadius: BorderRadius.circular(8),
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

  Widget _buildCard(IdentifikasiPenyakit data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE6EEE8)),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 12),
        childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
        iconColor: const Color(0xFF2E7D32),
        collapsedIconColor: Colors.black45,

        title: Text(
          data.namaPenyakit,
          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
        ),

        children: [
          _block("Penyebab", data.penyebab),

          const SizedBox(height: 6),

          _block("Gejala", data.gejala),

          const SizedBox(height: 6),

          _block("Dampak", data.dampak),
        ],
      ),
    );
  }

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
