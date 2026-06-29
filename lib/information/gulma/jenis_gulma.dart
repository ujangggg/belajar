import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GulmaTebu {
  final String nama;
  final String namaIlmiah;
  final String jenis;
  final String ciri;
  final String dampak;
  final String pengendalian;

  GulmaTebu({
    required this.nama,
    required this.namaIlmiah,
    required this.jenis,
    required this.ciri,
    required this.dampak,
    required this.pengendalian,
  });
}

class JenisGulmaController extends GetxController {
  final searchText = ''.obs;

  final List<GulmaTebu> listGulma = [
    // 1. Rumput Teki
    GulmaTebu(
      nama: "Rumput Teki",
      namaIlmiah: "Cyperus rotundus",
      jenis: "Gulma Teki-tekian",
      ciri:
          "Batang segitiga dan memiliki umbi di dalam tanah yang sulit dibasmi.",
      dampak: "Bersaing kuat menyerap air dan hara, menghambat akar tebu.",
      pengendalian:
          "Pencabutan manual hingga umbi atau pengolahan tanah intensif.",
    ),
    // 2. Rumput Belulang
    GulmaTebu(
      nama: "Rumput Belulang",
      namaIlmiah: "Eleusine indica",
      jenis: "Gulma Rumput",
      ciri: "Batang pipih dan bercabang seperti jari tangan di ujungnya.",
      dampak:
          "Tumbuh sangat cepat di area terbuka dan menutupi permukaan tanah.",
      pengendalian: "Penyiangan mekanis atau herbisida pra-tumbuh.",
    ),
    // 3. Bandotan
    GulmaTebu(
      nama: "Bandotan",
      namaIlmiah: "Ageratum conyzoides",
      jenis: "Gulma Daun Lebar",
      ciri:
          "Daun berbulu halus, bunga berwarna putih/ungu kecil seperti kancing.",
      dampak: "Cepat menyebar melalui biji yang terbawa angin.",
      pengendalian: "Pencabutan sebelum berbunga.",
    ),
    // 4. Lulangan
    GulmaTebu(
      nama: "Lulangan",
      namaIlmiah: "Digitaria ciliaris",
      jenis: "Gulma Rumput",
      ciri: "Tumbuh menjalar dengan stolon yang panjang di permukaan tanah.",
      dampak:
          "Menutupi permukaan tanah sehingga menghambat pertumbuhan tunas tebu.",
      pengendalian: "Penggunaan herbisida selektif atau penyiangan manual.",
    ),
    // 5. Bayam Duri
    GulmaTebu(
      nama: "Bayam Duri",
      namaIlmiah: "Amaranthus spinosus",
      jenis: "Gulma Daun Lebar",
      ciri: "Batang berduri tajam pada ketiak daun.",
      dampak: "Mengganggu operasional pekerja kebun saat klentek atau panen.",
      pengendalian: "Penyiangan mekanis dengan alat pelindung tangan.",
    ),
    // 6. Ilalang
    GulmaTebu(
      nama: "Ilalang",
      namaIlmiah: "Imperata cylindrica",
      jenis: "Gulma Rumput",
      ciri: "Memiliki rimpang putih yang tajam dan tumbuh sangat rapat.",
      dampak:
          "Sangat kompetitif menyerap hara dan bersifat alelopati (meracuni tanaman lain).",
      pengendalian:
          "Aplikasi herbisida sistemik dosis tinggi sebelum pengolahan lahan.",
    ),
    // 7. Putri Malu
    GulmaTebu(
      nama: "Putri Malu",
      namaIlmiah: "Mimosa pudica",
      jenis: "Gulma Daun Lebar",
      ciri: "Daun menutup jika disentuh dan memiliki duri di seluruh batang.",
      dampak: "Menghambat akses pekerja dan menyaingi ruang tumbuh.",
      pengendalian: "Penyiangan mekanis dengan cangkul.",
    ),
    // 8. Rumput Kerbau
    GulmaTebu(
      nama: "Rumput Kerbau",
      namaIlmiah: "Paspalum conjugatum",
      jenis: "Gulma Rumput",
      ciri: "Daun lebar dengan bunga berbentuk huruf Y di ujung.",
      dampak: "Cepat menutupi permukaan tanah pada kondisi lembap.",
      pengendalian: "Penyiangan manual pada area yang lembap.",
    ),
    // 9. Kangkung Liar
    GulmaTebu(
      nama: "Kangkung Liar",
      namaIlmiah: "Ipomoea aquatica",
      jenis: "Gulma Daun Lebar",
      ciri: "Tanaman merambat dengan daun berbentuk hati.",
      dampak:
          "Menjalar di atas tanaman tebu sehingga menutupi cahaya matahari.",
      pengendalian: "Pembersihan saluran air dan pencabutan manual.",
    ),
    // 10. Meniran
    GulmaTebu(
      nama: "Meniran",
      namaIlmiah: "Phyllanthus niruri",
      jenis: "Gulma Daun Lebar",
      ciri: "Daun kecil-kecil bersirip dengan biji bulat di bawah daun.",
      dampak: "Tumbuh dalam jumlah besar sehingga menguras hara permukaan.",
      pengendalian: "Penyiangan mekanis ringan.",
    ),
    // 11. Rumput Grinting
    GulmaTebu(
      nama: "Rumput Grinting",
      namaIlmiah: "Cynodon dactylon",
      jenis: "Gulma Rumput",
      ciri: "Tumbuh menjalar dengan stolon yang masuk ke tanah.",
      dampak: "Sangat sulit dibasmi karena akarnya sangat dalam.",
      pengendalian: "Pengolahan tanah sempurna dan herbisida sistemik.",
    ),
    // 12. Kirinyuh
    GulmaTebu(
      nama: "Kirinyuh",
      namaIlmiah: "Chromolaena odorata",
      jenis: "Gulma Daun Lebar",
      ciri: "Semak berkayu dengan daun segitiga berbau khas.",
      dampak:
          "Tumbuh sangat tinggi dan menghambat akses cahaya matahari total.",
      pengendalian: "Penebasan rutin dan pencabutan rimpang.",
    ),
    // 13. Teki Ladang
    GulmaTebu(
      nama: "Teki Ladang",
      namaIlmiah: "Cyperus iria",
      jenis: "Gulma Teki-tekian",
      ciri: "Mirip teki tetapi batang lebih lunak dan kepala bunga bercabang.",
      dampak: "Pesaing hara pada fase pertumbuhan tebu muda.",
      pengendalian: "Penyiangan manual dan herbisida pasca-tumbuh.",
    ),
    // 14. Rumput Padi-padian
    GulmaTebu(
      nama: "Rumput Padi-padian",
      namaIlmiah: "Echinochloa colona",
      jenis: "Gulma Rumput",
      ciri: "Bentuk tanaman sangat mirip dengan tebu muda.",
      dampak: "Sulit dibedakan secara visual sehingga sering lolos penyiangan.",
      pengendalian: "Pengenalan visual yang teliti dan pencabutan manual.",
    ),
    // 15. Anting-anting
    GulmaTebu(
      nama: "Anting-anting",
      namaIlmiah: "Acalypha indica",
      jenis: "Gulma Daun Lebar",
      ciri: "Memiliki bunga menjuntai seperti anting.",
      dampak: "Kompetisi hara di lahan subur.",
      pengendalian: "Penyiangan rutin.",
    ),
    // 16. Rumput Belang
    GulmaTebu(
      nama: "Rumput Belang",
      namaIlmiah: "Setaria viridis",
      jenis: "Gulma Rumput",
      ciri: "Bunga berbentuk bulu sikat berwarna hijau/ungu.",
      dampak: "Pesaing cahaya matahari bagi tebu muda.",
      pengendalian: "Penyiangan mekanis.",
    ),
    // 17. Sembung
    GulmaTebu(
      nama: "Sembung",
      namaIlmiah: "Blumea balsamifera",
      jenis: "Gulma Daun Lebar",
      ciri: "Tanaman berkayu dengan bau aromatik kuat.",
      dampak: "Tumbuh di pinggir lahan dan menaungi barisan tebu.",
      pengendalian: "Penebasan manual.",
    ),
    // 18. Semanggi
    GulmaTebu(
      nama: "Semanggi",
      namaIlmiah: "Marsilea crenata",
      jenis: "Gulma Air",
      ciri: "Daun terdiri dari empat anak daun.",
      dampak: "Tumbuh di saluran air atau lahan tergenang.",
      pengendalian: "Perbaikan drainase lahan.",
    ),
    // 19. Rumput Bambu
    GulmaTebu(
      nama: "Rumput Bambu",
      namaIlmiah: "Lophatherum gracile",
      jenis: "Gulma Rumput",
      ciri: "Daun lebar menyerupai bambu kecil.",
      dampak: "Mengurangi ruang tumbuh di bawah tajuk tebu.",
      pengendalian: "Penyiangan manual.",
    ),
    // 20. Teki Wewe
    GulmaTebu(
      nama: "Teki Wewe",
      namaIlmiah: "Kyllinga brevifolia",
      jenis: "Gulma Teki-tekian",
      ciri: "Kepala bunga bulat padat berwarna hijau.",
      dampak: "Tumbuh sangat rapat menutupi tanah.",
      pengendalian: "Pencabutan manual secara intensif.",
    ),
  ];

  List<GulmaTebu> get filteredList {
    if (searchText.value.isEmpty) return listGulma;

    final q = searchText.value.toLowerCase();

    return listGulma.where((e) {
      return e.nama.toLowerCase().contains(q) ||
          e.namaIlmiah.toLowerCase().contains(q) ||
          e.jenis.toLowerCase().contains(q) ||
          e.ciri.toLowerCase().contains(q) ||
          e.dampak.toLowerCase().contains(q) ||
          e.pengendalian.toLowerCase().contains(q);
    }).toList();
  }
}

class JenisGulmaPage extends StatelessWidget {
  const JenisGulmaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(JenisGulmaController());

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
                      "Gulma tidak ditemukan",
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

  Widget _buildHeader(JenisGulmaController controller) {
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
                "Jenis Gulma",
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
            "Gulma pada tanaman tebu",
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
          data.nama,
          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
        ),
        children: [
          _block("Nama Ilmiah", data.namaIlmiah),
          const SizedBox(height: 6),
          _block("Jenis Gulma", data.jenis),
          const SizedBox(height: 6),
          _block("Ciri-ciri", data.ciri),
          const SizedBox(height: 6),
          _block("Dampak", data.dampak),
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
