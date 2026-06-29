import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PenyakitTebu {
  final String nama;
  final String patogen;
  final String gejala;
  final String pengendalian;

  PenyakitTebu({
    required this.nama,
    required this.patogen,
    required this.gejala,
    required this.pengendalian,
  });
}

class InformasiPenyakitController extends GetxController {
  final searchText = ''.obs;

  final List<PenyakitTebu> listPenyakit = [
    // 1. Luka Api (Smut)
    PenyakitTebu(
      nama: "Luka Api (Smut)",
      patogen: "Sporisorium scitamineum",
      gejala:
          "Terdapat struktur cambuk hitam di pucuk yang berisi spora halus.",
      pengendalian:
          "Gunakan varietas tahan, eradikasi tanaman sakit, dan treatment HWT.",
    ),
    // 2. Mosaik (SCMV)
    PenyakitTebu(
      nama: "Mosaik (SCMV)",
      patogen: "Sugarcane Mosaic Virus",
      gejala: "Pola bercak belang hijau-kuning tidak beraturan pada daun.",
      pengendalian:
          "Gunakan bibit bebas virus, kendalikan serangga vektor kutu daun.",
    ),
    // 3. Pokkahbung
    PenyakitTebu(
      nama: "Pokkahbung",
      patogen: "Fusarium moniliforme",
      gejala: "Daun muda terpilin, klorosis, dan pangkal membusuk.",
      pengendalian: "Gunakan fungisida sistemik dan perbaiki drainase lahan.",
    ),
    // 4. Karat Daun
    PenyakitTebu(
      nama: "Karat Daun (Rust)",
      patogen: "Puccinia melanocephala",
      gejala: "Bercak memanjang cokelat kemerahan seperti karat besi.",
      pengendalian:
          "Hindari varietas rentan dan atur jarak tanam agar sirkulasi baik.",
    ),
    // 5. Scald Daun
    PenyakitTebu(
      nama: "Scald Daun",
      patogen: "Xanthomonas albilineans",
      gejala:
          "Muncul garis putih halus dan daun tampak seperti terkena air panas.",
      pengendalian:
          "Sterilisasi alat potong dan gunakan bibit hasil kultur jaringan.",
    ),
    // 6. Busuk Batang Merah
    PenyakitTebu(
      nama: "Busuk Batang Merah",
      patogen: "Colletotrichum falcatum",
      gejala:
          "Jaringan dalam batang merah dengan garis putih melintang dan bau asam.",
      pengendalian: "Rotasi tanaman dan hindari luka fisik pada batang.",
    ),
    // 7. Penyakit Sereh (RSD)
    PenyakitTebu(
      nama: "Ratoon Stunting Disease",
      patogen: "Leifsonia xyli",
      gejala: "Kerdil kronis, terdapat bintik oranye di buku-buku batang.",
      pengendalian: "Hot Water Treatment dan disinfeksi alat penebangan.",
    ),
    // 8. Busuk Nanas
    PenyakitTebu(
      nama: "Busuk Nanas",
      patogen: "Ceratocystis paradoxa",
      gejala: "Stek bibit gagal tumbuh, bagian dalam hitam berbau nanas.",
      pengendalian:
          "Pencelupan bibit dalam fungisida dan jangan menanam di tanah becek.",
    ),
    // 9. Bercak Cincin
    PenyakitTebu(
      nama: "Bercak Cincin",
      patogen: "Leptosphaeria sacchari",
      gejala: "Bercak oval pusat putih dengan tepi cokelat kemerahan.",
      pengendalian: "Pemupukan Kalium yang cukup dan bersihkan daun kering.",
    ),
    // 10. Penyakit Fiji
    PenyakitTebu(
      nama: "Penyakit Fiji",
      patogen: "Fiji Disease Virus",
      gejala: "Daun kaku dan bintil kecil (gall) di bawah urat daun.",
      pengendalian: "Eradikasi tanaman sakit dan kendalikan hama wereng daun.",
    ),
    // 11. Bercak Kuning
    PenyakitTebu(
      nama: "Bercak Kuning",
      patogen: "Mycovellosiella koepkei",
      gejala: "Bercak kuning tidak merata yang berubah menjadi cokelat.",
      pengendalian: "Klentek daun kering untuk mengurangi kelembapan.",
    ),
    // 12. Garis Merah (Red Stripe)
    PenyakitTebu(
      nama: "Garis Merah",
      patogen: "Acidovorax avenae",
      gejala: "Garis merah tua memanjang sejajar tulang daun.",
      pengendalian: "Hindari pemberian pupuk Nitrogen berlebih.",
    ),
    // 13. Busuk Akar
    PenyakitTebu(
      nama: "Busuk Akar",
      patogen: "Pythium spp.",
      gejala: "Akar menghitam dan membusuk, tanaman mudah layu.",
      pengendalian: "Rotasi tanaman dan aplikasi agen hayati Trichoderma.",
    ),
    // 14. Penyakit Streak
    PenyakitTebu(
      nama: "Penyakit Streak",
      patogen: "Streak Virus",
      gejala: "Garis putus-putus kuning keputihan pada helai daun.",
      pengendalian:
          "Pemusnahan tanaman inang dan pengendalian vektor serangga.",
    ),
    // 15. Klorosis Garis
    PenyakitTebu(
      nama: "Klorosis Garis",
      patogen: "Phytoplasma",
      gejala: "Garis klorotik kekuningan dengan batas yang tidak tegas.",
      pengendalian: "Perbaikan drainase dan penggunaan bibit sehat.",
    ),
    // 16. Busuk Pangkal
    PenyakitTebu(
      nama: "Busuk Pangkal",
      patogen: "Thielaviopsis paradoxa",
      gejala: "Batang bawah menghitam dan lunak berbau fermentasi.",
      pengendalian: "Pengaturan tata air tanah yang baik.",
    ),
    // 17. Penyakit Mata Mata
    PenyakitTebu(
      nama: "Penyakit Mata Mata",
      patogen: "Helminthosporium ocelliferum",
      gejala: "Bercak menyerupai bentuk mata pada daun.",
      pengendalian: "Pembersihan kebun dari gulma inang.",
    ),
    // 18. Busuk Pelepah
    PenyakitTebu(
      nama: "Busuk Pelepah",
      patogen: "Rhizoctonia solani",
      gejala: "Bercak cokelat basah pada pelepah daun bawah.",
      pengendalian: "Pengaturan populasi tanaman agar tidak terlalu rapat.",
    ),
    // 19. Penyakit Layu Bakteri
    PenyakitTebu(
      nama: "Layu Bakteri",
      patogen: "Ralstonia solanacearum",
      gejala: "Tanaman layu mendadak tanpa menguning sebelumnya.",
      pengendalian: "Gunakan lahan bebas inang bakteri.",
    ),
    // 20. Antraknosa
    PenyakitTebu(
      nama: "Antraknosa",
      patogen: "Colletotrichum graminicola",
      gejala: "Bercak hitam memanjang disertai masa spora.",
      pengendalian: "Aplikasi fungisida protektif pada fase awal.",
    ),
  ];

  List<PenyakitTebu> get filteredList {
    if (searchText.value.isEmpty) {
      return listPenyakit;
    }

    final q = searchText.value.toLowerCase();

    return listPenyakit.where((e) {
      return e.nama.toLowerCase().contains(q) ||
          e.patogen.toLowerCase().contains(q) ||
          e.gejala.toLowerCase().contains(q) ||
          e.pengendalian.toLowerCase().contains(q);
    }).toList();
  }
}

class InformasiPenyakitPage extends StatelessWidget {
  const InformasiPenyakitPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(InformasiPenyakitController());

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
                      "Penyakit tidak ditemukan",
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

  Widget _buildHeader(InformasiPenyakitController controller) {
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
                "Penyakit Tebu",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const Spacer(),

              _icon(Icons.health_and_safety, () {}),
            ],
          ),

          const SizedBox(height: 8),

          const Text(
            "Penyebab, gejala & pengendalian",
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

  Widget _buildCard(PenyakitTebu data) {
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
          data.nama,
          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
        ),

        children: [
          _block("Patogen", data.patogen),

          const SizedBox(height: 6),

          _block("Gejala", data.gejala),

          const SizedBox(height: 6),

          _block("Pengendalian", data.pengendalian),
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
