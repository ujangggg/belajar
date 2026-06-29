import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MusuhAlami {
  final String nama;
  final String jenis;
  final String target;
  final String caraKerja;
  final String aplikasi;

  MusuhAlami({
    required this.nama,
    required this.jenis,
    required this.target,
    required this.caraKerja,
    required this.aplikasi,
  });
}

class MusuhAlamiController extends GetxController {
  final searchText = ''.obs;

  final List<MusuhAlami> listMusuhAlami = [
    // 1. Trichogramma sp.
    MusuhAlami(
      nama: "Trichogramma sp.",
      jenis: "Parasitoid Telur",
      target: "Hama Penggerek Pucuk & Batang",
      caraKerja:
          "Meletakkan telur di dalam telur hama, larvanya memakan isi telur tersebut.",
      aplikasi: "Pelepasan melalui kartu pias (20rb–50rb individu/hektar).",
    ),
    // 2. Beauveria bassiana
    MusuhAlami(
      nama: "Beauveria bassiana",
      jenis: "Jamur Entomopatogen",
      target: "Penggerek Batang & Wereng",
      caraKerja:
          "Spora jamur menempel di kulit serangga, berkecambah, dan menembus tubuh hama.",
      aplikasi: "Disemprotkan dalam bentuk suspensi spora pada populasi hama.",
    ),
    // 3. Epiricania melanoleuca
    MusuhAlami(
      nama: "Epiricania melanoleuca",
      jenis: "Parasitoid Eksternal",
      target: "Wereng Daun",
      caraKerja:
          "Larva menempel pada tubuh wereng dan menyerap cairan tubuh hingga inang mati.",
      aplikasi: "Pelepasan kepompong di titik populasi wereng tinggi.",
    ),
    // 4. Metarhizium anisopliae
    MusuhAlami(
      nama: "Metarhizium anisopliae",
      jenis: "Jamur Entomopatogen",
      target: "Uret (Penggerek Akar)",
      caraKerja:
          "Menginfeksi tubuh uret melalui kutikula dan mengeluarkan racun (destruxin).",
      aplikasi:
          "Pencampuran dengan tanah atau penyemprotan pada area perakaran.",
    ),
    // 5. Chrysoperla carnea
    MusuhAlami(
      nama: "Chrysoperla carnea",
      jenis: "Predator (Lacewing)",
      target: "Kutu Daun & Kutu Perisai",
      caraKerja:
          "Larva memangsa kutu dengan menusukkan rahang tajam dan menyedot cairan tubuh.",
      aplikasi: "Pelepasan larva di area yang terinfeksi koloni kutu.",
    ),
    // 6. Coccinella transversalis
    MusuhAlami(
      nama: "Coccinella transversalis",
      jenis: "Predator (Kepik)",
      target: "Kutu Daun",
      caraKerja:
          "Baik larva maupun dewasa memangsa kutu dalam jumlah besar setiap harinya.",
      aplikasi:
          "Konservasi habitat agar predator ini berkembang alami di sekitar kebun.",
    ),
    // 7. Tetrastichus schoenobii
    MusuhAlami(
      nama: "Tetrastichus schoenobii",
      jenis: "Parasitoid Telur",
      target: "Penggerek Batang",
      caraKerja: "Menyuntikkan telur ke dalam kelompok telur penggerek batang.",
      aplikasi: "Pelepasan imago dewasa saat fase bertelur hama puncak.",
    ),
    // 8. Sycanus annulicornis
    MusuhAlami(
      nama: "Sycanus annulicornis",
      jenis: "Predator (Kepik)",
      target: "Ulat & Larva Penggerek",
      caraKerja:
          "Menusuk tubuh larva penggerek dengan probosis dan menyedot cairan dalamnya.",
      aplikasi: "Pelepasan di lahan saat populasi penggerek mulai muncul.",
    ),
    // 9. Paederus fuscipes
    MusuhAlami(
      nama: "Paederus fuscipes",
      jenis: "Predator",
      target: "Wereng & Hama kecil",
      caraKerja:
          "Memangsa hama dengan aktif di permukaan tanah dan tajuk tanaman.",
      aplikasi: "Menjaga tanaman penutup tanah untuk sarang predator ini.",
    ),
    // 10. Apanteles sp.
    MusuhAlami(
      nama: "Apanteles sp.",
      jenis: "Parasitoid Larva",
      target: "Ulat Daun",
      caraKerja:
          "Meletakkan telur ke dalam tubuh ulat, larva parasitoid akan keluar dan menjadi kepompong.",
      aplikasi: "Konservasi lingkungan agar parasitoid ini dapat bereproduksi.",
    ),
    // 11. Verticillium lecanii
    MusuhAlami(
      nama: "Verticillium lecanii",
      jenis: "Jamur Entomopatogen",
      target: "Kutu Putih",
      caraKerja:
          "Menginfeksi kutu putih hingga tubuhnya mengeras dan tertutup miselium.",
      aplikasi: "Penyemprotan fungisida hayati pada kondisi kelembapan tinggi.",
    ),
    // 12. Menochilus sexmaculatus
    MusuhAlami(
      nama: "Menochilus sexmaculatus",
      jenis: "Predator (Kepik)",
      target: "Kutu-kutuan",
      caraKerja:
          "Predator rakus yang mengonsumsi koloni kutu di permukaan daun.",
      aplikasi:
          "Pengurangan penggunaan pestisida kimia untuk menjaga populasinya.",
    ),
    // 13. Xanthopimpla sp.
    MusuhAlami(
      nama: "Xanthopimpla sp.",
      jenis: "Parasitoid Pupa",
      target: "Penggerek Pucuk",
      caraKerja:
          "Menyuntikkan telur ke dalam pupa penggerek yang ada di dalam batang.",
      aplikasi:
          "Pelepasan di area yang memiliki riwayat serangan penggerek tinggi.",
    ),
    // 14. Forficula auricularia
    MusuhAlami(
      nama: "Forficula auricularia",
      jenis: "Predator (Cewig)",
      target: "Telur & Larva Hama",
      caraKerja:
          "Memangsa telur hama yang diletakkan di celah batang atau tanah.",
      aplikasi: "Menyediakan mulsa sebagai tempat perlindungan.",
    ),
    // 15. Bracon chinensis
    MusuhAlami(
      nama: "Bracon chinensis",
      jenis: "Parasitoid Larva",
      target: "Penggerek Batang",
      caraKerja:
          "Melumpuhkan larva penggerek sebelum meletakkan telur pada inang.",
      aplikasi: "Pelepasan di sepanjang barisan tebu.",
    ),
    // 16. Spalangia sp.
    MusuhAlami(
      nama: "Spalangia sp.",
      jenis: "Parasitoid Pupa",
      target: "Lalat Hama",
      caraKerja: "Memarasit pupa lalat hama di dalam tanah atau sisa tanaman.",
      aplikasi: "Pelepasan massal di lahan yang terinfeksi lalat penggerek.",
    ),
    // 17. Formicidae (Semut Hitam)
    MusuhAlami(
      nama: "Dolichoderus thoracicus",
      jenis: "Predator (Semut)",
      target: "Kutu & Penggerek Muda",
      caraKerja:
          "Mengganggu aktivitas hama dan memangsa larva kecil pada pucuk.",
      aplikasi: "Penggunaan semut dalam program pengendalian hama terpadu.",
    ),
    // 18. Orius insidiosus
    MusuhAlami(
      nama: "Orius insidiosus",
      jenis: "Predator (Kepik)",
      target: "Thrips & Kutu",
      caraKerja:
          "Menusuk hama dengan jarum mulutnya dan menghisap cairan tubuhnya.",
      aplikasi: "Pelepasan pada tanaman muda saat serangan thrips dimulai.",
    ),
    // 19. Bacillus thuringiensis
    MusuhAlami(
      nama: "Bacillus thuringiensis",
      jenis: "Bakteri Entomopatogen",
      target: "Ulat Penggerek",
      caraKerja:
          "Menghasilkan kristal protein beracun yang merusak saluran pencernaan larva.",
      aplikasi: "Aplikasi semprotan pada daun yang dimakan larva.",
    ),
    // 20. Tachinidae (Lalat Parasit)
    MusuhAlami(
      nama: "Tachinidae sp.",
      jenis: "Parasitoid Larva",
      target: "Ulat Penggerek",
      caraKerja:
          "Meletakkan telur pada kulit larva, yang kemudian menetas dan memakan inang dari dalam.",
      aplikasi:
          "Konservasi bunga-bungaan di sekitar kebun untuk sumber nutrisi imago.",
    ),
  ];

  List<MusuhAlami> get filteredList {
    if (searchText.value.isEmpty) {
      return listMusuhAlami;
    }

    final q = searchText.value.toLowerCase();

    return listMusuhAlami.where((e) {
      return e.nama.toLowerCase().contains(q) ||
          e.jenis.toLowerCase().contains(q) ||
          e.target.toLowerCase().contains(q) ||
          e.caraKerja.toLowerCase().contains(q) ||
          e.aplikasi.toLowerCase().contains(q);
    }).toList();
  }
}

class HamaMusuhAlamiPage extends StatelessWidget {
  const HamaMusuhAlamiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MusuhAlamiController());

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

  Widget _buildHeader(MusuhAlamiController controller) {
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
                "Musuh Alami Hama",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const Spacer(),

              _icon(Icons.bug_report_outlined, () {}),
            ],
          ),

          const SizedBox(height: 8),

          const Text(
            "Pengendalian hayati ramah lingkungan",
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

  Widget _buildCard(MusuhAlami data) {
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

        subtitle: Text(
          data.jenis,
          style: const TextStyle(fontSize: 11.5, color: Colors.black54),
        ),

        children: [
          _block("Target Hama", data.target),

          const SizedBox(height: 6),

          _block("Cara Kerja", data.caraKerja),

          const SizedBox(height: 6),

          _block("Metode Aplikasi", data.aplikasi),
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
