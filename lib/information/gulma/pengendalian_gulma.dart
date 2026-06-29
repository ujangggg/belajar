import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GulmaTebu {
  final String judul;
  final String waktu;
  final String tujuan;
  final String cara;
  final String catatan;

  GulmaTebu({
    required this.judul,
    required this.waktu,
    required this.tujuan,
    required this.cara,
    required this.catatan,
  });
}

class PengendalianGulmaController extends GetxController {
  final searchText = ''.obs;

  final List<GulmaTebu> listGulma = [
    // 1. Pengendalian Gulma Terpadu
    GulmaTebu(
      judul: "Pengendalian Gulma Terpadu",
      waktu: "Sepanjang masa tanam",
      tujuan:
          "Mengendalikan gulma secara efektif dan berkelanjutan tanpa merusak ekosistem lahan.",
      cara:
          "Menggabungkan penyiangan manual, mekanis, mulsa, herbisida selektif, serta pengelolaan tajuk.",
      catatan: "Pendekatan lebih stabil dan ramah lingkungan.",
    ),

    // 2. Gulma Teki (Cyperus rotundus)
    GulmaTebu(
      judul: "Gulma Teki",
      waktu: "Fase Tebu Muda (0-3 bln)",
      tujuan: "Mencegah persaingan hara pada fase kritis.",
      cara:
          "Pengolahan tanah sempurna sebelum tanam dan aplikasi herbisida pra-tumbuh.",
      catatan: "Umbi teki sulit mati, harus dicabut hingga akar terdalam.",
    ),

    // 3. Gulma Rumput Belulang (Eleusine indica)
    GulmaTebu(
      judul: "Rumput Belulang",
      waktu: "Awal musim hujan",
      tujuan: "Menekan pertumbuhan rumput yang agresif.",
      cara: "Penyiangan mekanis dengan cangkul atau traktor kecil.",
      catatan:
          "Sangat tahan terhadap kekeringan, harus dikendalikan saat masih muda.",
    ),

    // 4. Penggunaan Mulsa Daun Kering
    GulmaTebu(
      judul: "Mulsa Daun Kering",
      waktu: "Setelah panen/keprasan",
      tujuan: "Menekan perkecambahan biji gulma.",
      cara: "Menutup permukaan tanah dengan sisa daun tebu kering (trash).",
      catatan:
          "Juga berfungsi menjaga kelembapan tanah dan menambah unsur hara.",
    ),

    // 5. Herbisida Pra-Tumbuh
    GulmaTebu(
      judul: "Herbisida Pra-Tumbuh",
      waktu: "Segera setelah tanam",
      tujuan: "Mencegah benih gulma berkecambah.",
      cara: "Penyemprotan larutan herbisida secara merata di permukaan tanah.",
      catatan: "Pastikan tanah cukup lembap agar herbisida bekerja maksimal.",
    ),

    // 6. Gulma Lulangan (Digitaria ciliaris)
    GulmaTebu(
      judul: "Gulma Lulangan",
      waktu: "Fase vegetatif",
      tujuan: "Menghindari kompetisi cahaya.",
      cara: "Penyiangan manual pada barisan tebu.",
      catatan:
          "Mudah berkembang biak melalui stolon, segera cabut sebelum berbunga.",
    ),

    // 7. Penggunaan Tanaman Penutup
    GulmaTebu(
      judul: "Tanaman Penutup (Cover Crop)",
      waktu: "Awal tanam",
      tujuan: "Menutup permukaan tanah agar cahaya tidak mencapai gulma.",
      cara: "Menanam kacang-kacangan di sela barisan tebu.",
      catatan: "Meningkatkan nitrogen tanah sekaligus menekan gulma.",
    ),

    // 8. Penyiangan Mekanis
    GulmaTebu(
      judul: "Penyiangan Mekanis",
      waktu: "Fase 1-2 bulan",
      tujuan: "Memutus akar gulma di lorong antar barisan.",
      cara: "Menggunakan kultivator atau traktor antar barisan.",
      catatan: "Hati-hati jangan sampai merusak akar tebu yang dangkal.",
    ),

    // 9. Gulma Bandotan (Ageratum conyzoides)
    GulmaTebu(
      judul: "Gulma Bandotan",
      waktu: "Sepanjang tahun",
      tujuan: "Mencegah penyebaran biji.",
      cara: "Pencabutan manual sebelum tanaman berbunga.",
      catatan: "Biji bandotan sangat ringan dan mudah terbawa angin.",
    ),

    // 10. Pengelolaan Drainase
    GulmaTebu(
      judul: "Pengelolaan Drainase",
      waktu: "Musim hujan",
      tujuan: "Mencegah pertumbuhan gulma air.",
      cara: "Pembersihan saluran drainase secara rutin.",
      catatan:
          "Air menggenang memicu munculnya gulma seperti enceng atau kangkung liar.",
    ),

    // 11. Herbisida Pasca-Tumbuh
    GulmaTebu(
      judul: "Herbisida Pasca-Tumbuh",
      waktu: "Saat gulma sudah muncul",
      tujuan: "Membasmi gulma yang lolos fase pra-tumbuh.",
      cara: "Aplikasi herbisida selektif (bisa membedakan gulma dan tebu).",
      catatan:
          "Gunakan pelindung (shield) pada nozzle agar tidak terkena daun tebu.",
    ),

    // 12. Gulma Bayam Duri (Amaranthus spinosus)
    GulmaTebu(
      judul: "Bayam Duri",
      waktu: "Fase awal tanam",
      tujuan: "Keamanan pekerja dan tanaman.",
      cara: "Pengendalian mekanis atau herbisida daun lebar.",
      catatan:
          "Duri sangat tajam, memerlukan sarung tangan khusus saat penyiangan.",
    ),

    // 13. Gulma Ilalang (Imperata cylindrica)
    GulmaTebu(
      judul: "Gulma Ilalang",
      waktu: "Sebelum pengolahan tanah",
      tujuan: "Mematikan rimpang ilalang.",
      cara: "Aplikasi herbisida sistemik dosis tinggi (glifosat).",
      catatan:
          "Ilalang sangat kompetitif, harus dibersihkan total sebelum tanam.",
    ),

    // 14. Pembersihan Lahan Manual
    GulmaTebu(
      judul: "Penyiangan Manual (Koret)",
      waktu: "Fase kritis",
      tujuan: "Membantu pertumbuhan tunas muda.",
      cara: "Menggunakan koret/cangkul kecil di sekitar rumpun tebu.",
      catatan:
          "Metode paling efektif untuk titik yang tidak terjangkau traktor.",
    ),

    // 15. Gulma Putri Malu (Mimosa pudica)
    GulmaTebu(
      judul: "Putri Malu",
      waktu: "Fase vegetatif",
      tujuan: "Mencegah gangguan duri.",
      cara: "Penyiangan mekanis sebelum berbunga.",
      catatan:
          "Duri pada batang cukup mengganggu saat proses klentek atau panen.",
    ),

    // 16. Rotasi Tanaman
    GulmaTebu(
      judul: "Rotasi Tanaman",
      waktu: "Antar periode tanam",
      tujuan: "Memutus siklus gulma khusus.",
      cara: "Menanam komoditas lain (misal: jagung/kedelai) satu periode.",
      catatan: "Efektif untuk mengubah metode pengendalian gulma.",
    ),

    // 17. Pengaturan Jarak Tanam
    GulmaTebu(
      judul: "Pengaturan Jarak Tanam",
      waktu: "Saat tanam",
      tujuan: "Mempercepat penutupan tajuk (canopy).",
      cara: "Jarak tanam rapat (sistem single/double row).",
      catatan: "Tajuk yang cepat rapat akan menghambat cahaya bagi gulma.",
    ),

    // 18. Penggunaan Pupuk Tepat Sasaran
    GulmaTebu(
      judul: "Pemupukan Tepat Sasaran",
      waktu: "Saat pemupukan",
      tujuan: "Memberi makan tebu, bukan gulma.",
      cara: "Pupuk diberikan pada alur, tidak disebar.",
      catatan: "Penyebaran pupuk merata justru memicu pertumbuhan gulma.",
    ),

    // 19. Gulma Rumput Kerbau (Paspalum conjugatum)
    GulmaTebu(
      judul: "Rumput Kerbau",
      waktu: "Fase lembap",
      tujuan: "Mencegah penutupan area.",
      cara: "Penyiangan mekanis.",
      catatan: "Cepat sekali menjalar, harus dikendalikan sejak dini.",
    ),

    // 20. Sanitas Alat
    GulmaTebu(
      judul: "Sanitasi Alat",
      waktu: "Setiap selesai operasional",
      tujuan: "Mencegah penyebaran biji gulma antar lahan.",
      cara: "Membersihkan traktor/alat dari tanah sisa.",
      catatan: "Tanah yang menempel di ban sering membawa biji gulma baru.",
    ),
  ];

  List<GulmaTebu> get filteredList {
    if (searchText.value.isEmpty) return listGulma;

    final q = searchText.value.toLowerCase();

    return listGulma.where((e) {
      return e.judul.toLowerCase().contains(q) ||
          e.waktu.toLowerCase().contains(q) ||
          e.tujuan.toLowerCase().contains(q) ||
          e.cara.toLowerCase().contains(q) ||
          e.catatan.toLowerCase().contains(q);
    }).toList();
  }
}

class PengendalianGulmaPage extends StatelessWidget {
  const PengendalianGulmaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PengendalianGulmaController());

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

  Widget _buildHeader(PengendalianGulmaController controller) {
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
                "Pengendalian Gulma",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              _icon(Icons.grass, () {}),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "Strategi pengendalian gulma tebu",
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

  Widget _buildCard(GulmaTebu data) {
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
          data.judul,
          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
        ),
        children: [
          _block("Waktu", data.waktu),
          const SizedBox(height: 6),
          _block("Tujuan", data.tujuan),
          const SizedBox(height: 6),
          _block("Cara", data.cara),
          const SizedBox(height: 6),
          _block("Catatan", data.catatan),
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
