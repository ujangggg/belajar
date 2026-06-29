import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HamaGejala {
  final String title;
  final String description;
  final String solution;

  HamaGejala({
    required this.title,
    required this.description,
    required this.solution,
  });
}

class HamaGejalaController extends GetxController {
  final searchText = ''.obs;

  final List<HamaGejala> listData = [
    // 1. Tanaman Tumbang (Lodging)
    HamaGejala(
      title: "Tanaman Tumbang (Lodging)",
      description:
          "Posisi batang tidak tegak lurus akibat beban tajuk berlebih atau terpaan angin.",
      solution:
          "Lakukan pembumbunan tepat waktu, perbaiki drainase, dan gunakan varietas dengan akar kuat.",
    ),
    // 2. Dead Heart
    HamaGejala(
      title: "Dead Heart (Pucuk Mati)",
      description:
          "Tunas pucuk mati dan kering sementara daun tua tetap hijau, disebabkan larva penggerek.",
      solution:
          "Eradikasi rumpun terserang dan pelepasan parasitoid telur Trichogramma.",
    ),
    // 3. Lubang Guratan Batang
    HamaGejala(
      title: "Lubang Guratan Batang",
      description:
          "Terdapat lubang kecil pada permukaan batang disertai kotoran larva (frass).",
      solution:
          "Pengendalian dengan insektisida sistemik atau penggunaan varietas tahan.",
    ),
    // 4. Daun Bergaris Kuning
    HamaGejala(
      title: "Daun Bergaris Kuning",
      description:
          "Muncul garis klorotik memanjang sejajar tulang daun (gejala virus).",
      solution:
          "Gunakan bibit bersertifikat bebas virus dan kendalikan serangga vektor.",
    ),
    // 5. Daun Terbakar (Leaf Scald)
    HamaGejala(
      title: "Daun Terbakar (Leaf Scald)",
      description:
          "Ujung daun tampak seperti tersiram air panas atau terbakar.",
      solution:
          "Sterilisasi alat tebang dan pilih bibit sehat hasil kultur jaringan.",
    ),
    // 6. Batang Membusuk
    HamaGejala(
      title: "Batang Membusuk",
      description:
          "Jaringan dalam batang lunak, berubah warna, dan mengeluarkan bau asam.",
      solution: "Hindari luka mekanis pada batang dan rotasi tanaman.",
    ),
    // 7. Daun Terpilin
    HamaGejala(
      title: "Daun Terpilin",
      description:
          "Pucuk daun muda tumbuh melintir/terpilin tidak normal (serangan Pokkahbung).",
      solution: "Aplikasi fungisida dan perbaikan sirkulasi udara di kebun.",
    ),
    // 8. Bintil pada Akar
    HamaGejala(
      title: "Bintil pada Akar",
      description:
          "Akar membengkak atau muncul bintil akibat serangan nematoda.",
      solution:
          "Pemberian pupuk organik dan pergiliran dengan tanaman bukan inang.",
    ),
    // 9. Daun Menjadi Sereh
    HamaGejala(
      title: "Tipe Pertumbuhan Sereh",
      description:
          "Tanaman kerdil, bercabang banyak, dan daun menjadi sempit kaku.",
      solution:
          "Musnahkan tanaman sakit dan gunakan bibit dari kebun bebas penyakit.",
    ),
    // 10. Bercak Karat
    HamaGejala(
      title: "Bercak Karat",
      description:
          "Bintil cokelat kemerahan (pustul) yang tersebar pada permukaan daun.",
      solution:
          "Atur jarak tanam agar tidak terlalu rapat dan kurangi pupuk Nitrogen.",
    ),
    // 11. Perubahan Warna Buku Batang
    HamaGejala(
      title: "Diskolorisasi Buku Batang",
      description:
          "Bagian buku batang berwarna merah/oranye saat dibelah (gejala RSD).",
      solution: "Gunakan perlakuan Hot Water Treatment pada bibit.",
    ),
    // 12. Stek Tidak Tumbuh
    HamaGejala(
      title: "Kegagalan Bibit",
      description: "Stek bibit gagal berkecambah dan membusuk di dalam tanah.",
      solution: "Perlakukan bibit dengan fungisida celup sebelum tanam.",
    ),
    // 13. Daun Berlubang-lubang
    HamaGejala(
      title: "Daun Berlubang",
      description:
          "Bekas gigitan ulat pada helai daun, seringkali menyisakan tulang daun saja.",
      solution: "Penyemprotan pestisida hayati seperti Bacillus thuringiensis.",
    ),
    // 14. Pertumbuhan Kerdil
    HamaGejala(
      title: "Stunting (Kerdil)",
      description:
          "Tanaman tumbuh lambat secara kronis meskipun nutrisi tersedia.",
      solution: "Cek kesehatan akar dan riwayat penyakit menular pada lahan.",
    ),
    // 15. Daun Menguning (Klorosis)
    HamaGejala(
      title: "Daun Menguning",
      description: "Seluruh permukaan daun berubah warna menjadi pucat/kuning.",
      solution:
          "Analisis kebutuhan hara tanah atau periksa gejala serangan kutu.",
    ),
    // 16. Bekas Kerokan pada Batang
    HamaGejala(
      title: "Kerokan Kulit Batang",
      description:
          "Kulit batang terkelupas akibat gigitan tikus atau hama pengerat lainnya.",
      solution:
          "Pembersihan semak di sekitar lahan dan pengendalian hama tikus.",
    ),
    // 17. Embun Jelaga
    HamaGejala(
      title: "Embun Jelaga",
      description:
          "Lapisan hitam seperti jelaga menutupi permukaan daun akibat sisa sekresi kutu.",
      solution: "Kendalikan populasi kutu daun sebagai sumber sekresi.",
    ),
    // 18. Batang Bengkok (Leher Angsa)
    HamaGejala(
      title: "Batang Leher Angsa",
      description:
          "Pucuk batang melengkung membentuk sudut menyerupai leher angsa.",
      solution: "Eradikasi dini tanaman yang terinfeksi jamur Fusarium.",
    ),
    // 19. Akar Menghitam
    HamaGejala(
      title: "Akar Hitam",
      description: "Perakaran utama busuk dan berubah warna menjadi hitam.",
      solution: "Perbaiki drainase tanah agar tidak tergenang.",
    ),
    // 20. Daun Menebal dan Kaku
    HamaGejala(
      title: "Daun Menebal",
      description:
          "Helai daun menebal dan kaku akibat bintil/gall pada urat daun.",
      solution: "Eradikasi tanaman sakit dan kendalikan hama vektor wereng.",
    ),
  ];

  List<HamaGejala> get filteredList {
    if (searchText.value.isEmpty) return listData;

    final q = searchText.value.toLowerCase();

    return listData.where((e) {
      return e.title.toLowerCase().contains(q) ||
          e.description.toLowerCase().contains(q) ||
          e.solution.toLowerCase().contains(q);
    }).toList();
  }
}

class HamaGejalaPage extends StatelessWidget {
  const HamaGejalaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HamaGejalaController());

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

  Widget _buildHeader(HamaGejalaController controller) {
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
                "Hama & Gejala",
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
            "Kondisi tanaman & gangguan umum",
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

  Widget _buildCard(HamaGejala data) {
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
