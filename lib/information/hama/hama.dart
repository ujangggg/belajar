import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HamaInfo {
  final String namaPopuler;
  final String namaIlmiah;
  final String klasifikasi;
  final String morfologi;
  final String siklusHidup;
  final String penyebaran;

  HamaInfo({
    required this.namaPopuler,
    required this.namaIlmiah,
    required this.klasifikasi,
    required this.morfologi,
    required this.siklusHidup,
    required this.penyebaran,
  });
}

class HamaInformasiController extends GetxController {
  final searchText = ''.obs;

  final List<HamaInfo> listHama = [
    // 1. Penggerek Pucuk Tebu
    HamaInfo(
      namaPopuler: "Penggerek Pucuk Tebu",
      namaIlmiah: "Scirpophaga excerptalis Walker",
      klasifikasi: "Ordo: Lepidoptera | Famili: Pyralidae",
      morfologi:
          "Ngengat dewasa putih bersih. Betina punya rumbai bulu cokelat di ujung perut. Larva krem kekuningan dengan kepala cokelat muda.",
      siklusHidup:
          "Total 45–60 hari: Telur 7-9 hr, larva 25-30 hr, pupa 10-14 hr.",
      penyebaran:
          "Populasi meningkat saat peralihan kemarau ke hujan dengan kelembapan tinggi.",
    ),

    // 2. Penggerek Batang Bergaris
    HamaInfo(
      namaPopuler: "Penggerek Batang Bergaris",
      namaIlmiah: "Chilo sacchariphagus",
      klasifikasi: "Ordo: Lepidoptera | Famili: Crambidae",
      morfologi:
          "Ngengat berwarna cokelat muda dengan garis perak pada sayap. Larva bergaris ungu memanjang.",
      siklusHidup:
          "Sekitar 35–45 hari, berkembang sangat cepat di batang yang sukulen.",
      penyebaran:
          "Tersebar luas di perkebunan tebu yang kurang perawatan kebersihan daun.",
    ),

    // 3. Penggerek Batang Abu-abu
    HamaInfo(
      namaPopuler: "Penggerek Batang Abu-abu",
      namaIlmiah: "Eucosma schistaceana",
      klasifikasi: "Ordo: Lepidoptera | Famili: Tortricidae",
      morfologi:
          "Ngengat abu-abu gelap dengan pola sayap tidak beraturan. Larva berwarna putih kotor.",
      siklusHidup:
          "Larva sering masuk ke ruas batang muda, merusak titik tumbuh utama.",
      penyebaran: "Sering menyerang tebu muda di bawah umur 3 bulan.",
    ),

    // 4. Wereng Daun Tebu
    HamaInfo(
      namaPopuler: "Wereng Daun Tebu",
      namaIlmiah: "Perkinsiella saccharicida",
      klasifikasi: "Ordo: Hemiptera | Famili: Delphacidae",
      morfologi:
          "Serangga kecil kecokelatan dengan sayap transparan yang memiliki pola kecokelatan.",
      siklusHidup:
          "Mencakup telur, 5 instar nimfa, dan dewasa dalam 30–40 hari.",
      penyebaran:
          "Dapat menularkan penyakit virus secara efektif di lahan lembap.",
    ),

    // 5. Kutu Perisai
    HamaInfo(
      namaPopuler: "Kutu Perisai",
      namaIlmiah: "Aulacaspis tegalensis",
      klasifikasi: "Ordo: Hemiptera | Famili: Diaspididae",
      morfologi:
          "Betina tertutup perisai putih berbentuk oval. Jantan jauh lebih kecil dan berwarna putih.",
      siklusHidup:
          "Tumbuh menetap di ruas batang dan menghisap cairan tanaman.",
      penyebaran: "Sangat cepat pada musim kemarau panjang yang kering.",
    ),

    // 6. Uret (Penggerek Akar)
    HamaInfo(
      namaPopuler: "Uret",
      namaIlmiah: "Lepidiota stigma",
      klasifikasi: "Ordo: Coleoptera | Famili: Scarabaeidae",
      morfologi:
          "Larva berukuran besar berbentuk huruf C (grub), berwarna putih dengan kepala cokelat.",
      siklusHidup: "Siklus hidup di dalam tanah hingga 1 tahun.",
      penyebaran:
          "Kerusakan parah pada sistem perakaran yang menyebabkan tanaman roboh.",
    ),

    // 7. Kutu Daun
    HamaInfo(
      namaPopuler: "Kutu Daun",
      namaIlmiah: "Ceratovacuna lanigera",
      klasifikasi: "Ordo: Hemiptera | Famili: Aphididae",
      morfologi:
          "Tubuh tertutup serbuk putih seperti kapas, berkelompok di bawah daun.",
      siklusHidup:
          "Berkembang biak secara partenogenesis (tanpa kawin) dengan sangat cepat.",
      penyebaran: "Meningkat saat kondisi nutrisi tebu tinggi Nitrogen.",
    ),

    // 8. Penggerek Batang Kuning
    HamaInfo(
      namaPopuler: "Penggerek Batang Kuning",
      namaIlmiah: "Scirpophaga incertulas",
      klasifikasi: "Ordo: Lepidoptera | Famili: Pyralidae",
      morfologi:
          "Ngengat kuning dengan bercak hitam pada sayap depan. Larva berwarna kekuningan.",
      siklusHidup: "Larva memakan jaringan bagian dalam batang.",
      penyebaran: "Umumnya menyerang pada fase tebu mendekati panen.",
    ),

    // 9. Kepik Penghisap
    HamaInfo(
      namaPopuler: "Kepik Penghisap",
      namaIlmiah: "Proutista moesta",
      klasifikasi: "Ordo: Hemiptera | Famili: Derbidae",
      morfologi:
          "Serangga dewasa dengan sayap bergaris-garis gelap, tampak rapuh.",
      siklusHidup: "Hidup di bawah permukaan daun yang teduh.",
      penyebaran: "Populasi meningkat di lahan yang rimbun dan minim sanitasi.",
    ),

    // 10. Penggerek Pucuk Kelabu
    HamaInfo(
      namaPopuler: "Penggerek Pucuk Kelabu",
      namaIlmiah: "Sesamia inferens",
      klasifikasi: "Ordo: Lepidoptera | Famili: Noctuidae",
      morfologi:
          "Ngengat berwarna cokelat keabu-abuan. Larva berwarna kemerahan.",
      siklusHidup: "Larva bersifat polifag (banyak inang).",
      penyebaran: "Sering berpindah dari tanaman padi di sekitar lahan tebu.",
    ),

    // 11. Kumbang Penggerek Batang
    HamaInfo(
      namaPopuler: "Kumbang Penggerek Batang",
      namaIlmiah: "Rhabdoscelus obscurus",
      klasifikasi: "Ordo: Coleoptera | Famili: Curculionidae",
      morfologi: "Kumbang moncong berwarna cokelat gelap/hitam.",
      siklusHidup: "Larva melubangi batang tebu dewasa.",
      penyebaran: "Sering menyerang melalui bekas luka fisik pada batang.",
    ),

    // 12. Kutu Tepung
    HamaInfo(
      namaPopuler: "Kutu Tepung",
      namaIlmiah: "Saccharicoccus sacchari",
      klasifikasi: "Ordo: Hemiptera | Famili: Pseudococcidae",
      morfologi:
          "Tubuh oval, lunak, berwarna merah muda tertutup lapisan tepung putih.",
      siklusHidup: "Bersembunyi di balik pelepah daun (daun seludang).",
      penyebaran: "Terbawa melalui bibit tebu yang terinfeksi.",
    ),

    // 13. Tungau Merah
    HamaInfo(
      namaPopuler: "Tungau Merah",
      namaIlmiah: "Oligonychus indicus",
      klasifikasi: "Ordo: Trombidiformes | Famili: Tetranychidae",
      morfologi:
          "Sangat kecil, berwarna merah, hanya terlihat jelas dengan lup.",
      siklusHidup: "Berkembang cepat di permukaan bawah daun.",
      penyebaran: "Sangat cepat pada kondisi panas terik yang berkepanjangan.",
    ),

    // 14. Belalang Kembara
    HamaInfo(
      namaPopuler: "Belalang Kembara",
      namaIlmiah: "Locusta migratoria",
      klasifikasi: "Ordo: Orthoptera | Famili: Acrididae",
      morfologi:
          "Belalang berukuran besar, mampu berpindah dalam kelompok besar.",
      siklusHidup: "Memiliki fase soliter dan fase gregarius (berkelompok).",
      penyebaran: "Migrasi secara masif antar wilayah perkebunan.",
    ),

    // 15. Ulat Grayak
    HamaInfo(
      namaPopuler: "Ulat Grayak",
      namaIlmiah: "Spodoptera frugiperda",
      klasifikasi: "Ordo: Lepidoptera | Famili: Noctuidae",
      morfologi: "Ulat dengan tanda berbentuk Y terbalik di kepala.",
      siklusHidup: "Makan secara berkelompok pada malam hari.",
      penyebaran: "Sangat invasif dan merusak daun tebu muda dengan cepat.",
    ),

    // 16. Kutu Daun Hitam
    HamaInfo(
      namaPopuler: "Kutu Daun Hitam",
      namaIlmiah: "Melanaphis sacchari",
      klasifikasi: "Ordo: Hemiptera | Famili: Aphididae",
      morfologi: "Berwarna hitam mengkilap atau hijau tua.",
      siklusHidup: "Vektor penting untuk penyakit virus mosaik.",
      penyebaran: "Diterbangkan oleh angin ke seluruh area kebun.",
    ),

    // 17. Lalat Penggerek
    HamaInfo(
      namaPopuler: "Lalat Penggerek",
      namaIlmiah: "Sturmiopsis inferens",
      klasifikasi: "Ordo: Diptera | Famili: Tachinidae",
      morfologi: "Lalat berbulu kasar menyerupai lalat rumah.",
      siklusHidup: "Larva lalat memarasit larva penggerek batang.",
      penyebaran: "Tersebar luas mengikuti populasi inang utamanya.",
    ),

    // 18. Kumbang Bubuk
    HamaInfo(
      namaPopuler: "Kumbang Bubuk",
      namaIlmiah: "Dinoderus minutus",
      klasifikasi: "Ordo: Coleoptera | Famili: Bostrichidae",
      morfologi: "Kumbang silindris kecil berwarna cokelat tua.",
      siklusHidup: "Menyerang sisa tanaman tebu atau bibit.",
      penyebaran: "Sering muncul di tumpukan sisa panen tebu.",
    ),

    // 19. Thrips Tebu
    HamaInfo(
      namaPopuler: "Thrips Tebu",
      namaIlmiah: "Fulmekiola serrata",
      klasifikasi: "Ordo: Thysanoptera | Famili: Thripidae",
      morfologi: "Serangga sangat kecil, kurus, berwarna kuning pucat.",
      siklusHidup: "Menghisap cairan daun di dalam gulungan daun muda.",
      penyebaran: "Menyebabkan daun gagal membuka sempurna.",
    ),

    // 20. Ulat Daun
    HamaInfo(
      namaPopuler: "Ulat Daun",
      namaIlmiah: "Rivula atimeta",
      klasifikasi: "Ordo: Lepidoptera | Famili: Erebidae",
      morfologi: "Ulat berwarna hijau pucat dengan garis lateral putih.",
      siklusHidup: "Memakan helai daun mulai dari pinggir.",
      penyebaran: "Populasi meningkat di lahan yang kurang terpapar matahari.",
    ),
  ];

  List<HamaInfo> get filteredList {
    if (searchText.value.isEmpty) {
      return listHama;
    }

    final q = searchText.value.toLowerCase();

    return listHama.where((e) {
      return e.namaPopuler.toLowerCase().contains(q) ||
          e.namaIlmiah.toLowerCase().contains(q) ||
          e.klasifikasi.toLowerCase().contains(q) ||
          e.morfologi.toLowerCase().contains(q) ||
          e.siklusHidup.toLowerCase().contains(q) ||
          e.penyebaran.toLowerCase().contains(q);
    }).toList();
  }
}

class HamaInformasiPage extends StatelessWidget {
  const HamaInformasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HamaInformasiController());

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

  Widget _buildHeader(HamaInformasiController controller) {
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
                "Biologi Hama",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const Spacer(),

              _icon(Icons.bug_report, () {}),
            ],
          ),

          const SizedBox(height: 8),

          const Text(
            "Morfologi, siklus hidup & penyebaran",
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

  Widget _buildCard(HamaInfo data) {
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

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.namaPopuler,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 2),

            Text(
              data.namaIlmiah,
              style: const TextStyle(
                fontSize: 11,
                fontStyle: FontStyle.italic,
                color: Colors.black54,
              ),
            ),
          ],
        ),

        children: [
          _block("Klasifikasi", data.klasifikasi),

          const SizedBox(height: 6),

          _block("Morfologi", data.morfologi),

          const SizedBox(height: 6),

          _block("Siklus Hidup", data.siklusHidup),

          const SizedBox(height: 6),

          _block("Penyebaran", data.penyebaran),
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
