import 'package:absen01/information/gulma/Halaman_utama.dart';
import 'package:absen01/information/penyakit/halaman_Utama.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:absen01/information/hama/halaman_utama.dart';
import 'package:absen01/information/umum/informasiumum.dart';

// --- MODEL DATA ---
class PanduanModel {
  final String title;
  final String desc;
  final String image;
  final Widget? targetPage;

  PanduanModel({
    required this.title,
    required this.desc,
    required this.image,
    this.targetPage,
  });
}

class SeeAllPage extends StatefulWidget {
  const SeeAllPage({super.key});

  @override
  State<SeeAllPage> createState() => _SeeAllPageState();
}

class _SeeAllPageState extends State<SeeAllPage> {
  final List<PanduanModel> listPanduan = [
    PanduanModel(
      title: "Informasi Umum",
      desc:
          "Kondisi fisik tebu seperti roboh, siwilan, mati puser, dan lainnya.",
      image: "assets/lahan.jpg",
      targetPage: const InformasiTebuPage(),
    ),
    PanduanModel(
      title: "Hama Tebu",
      desc: "Identifikasi gejala, database hama, dan musuh alami.",
      image: "assets/pupuk.jpg",
      targetPage: const HamaMainPage(),
    ),
    PanduanModel(
      title: "Penyakit",
      desc: "Mengenal penyakit tanaman tebu dan cara penanganannya.",
      image: "assets/login.png",
      targetPage: const PenyakitMainPage(),
    ),
    PanduanModel(
      title: "Gulma",
      desc: "Manajemen tanaman pengganggu di lahan tebu.",
      image: "assets/lahan.jpg",
      targetPage: const GulmaMainPage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8F4),
      appBar: AppBar(
        title: const Text(
          "Pusat Panduan",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1B5E20),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildHeader(),
          // _buildSearchBar() dihapus
          const SizedBox(
            height: 16,
          ), // Memberi sedikit jarak sebagai pengganti search bar
          _buildResultInfo(),
          _buildResultList(listPanduan), // Langsung pakai listPanduan asli
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 26),
      decoration: const BoxDecoration(
        color: Color(0xFF1B5E20),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: const Column(
        children: [
          Icon(Icons.eco_rounded, color: Colors.white, size: 38),
          SizedBox(height: 8),
          Text(
            "Pusat Panduan Tebu",
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            "Pilih kategori informasi yang Anda butuhkan",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.3),
          ),
        ],
      ),
    );
  }

  Widget _buildResultInfo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 4),
      child: Row(
        children: [
          const Text(
            "Daftar Panduan",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B5E20),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "${listPanduan.length} item",
              style: TextStyle(
                fontSize: 11,
                color: Colors.green.shade800,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultList(List<PanduanModel> items) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          // Ukuran tetap sama: Card dengan dekorasi, image 82x82, dll
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(19),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(19),
              onTap:
                  () =>
                      item.targetPage != null
                          ? Get.to(() => item.targetPage!)
                          : null,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        item.image,
                        width: 82,
                        height: 82,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item.desc,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 9),
                          Row(
                            children: [
                              Icon(
                                Icons.touch_app_rounded,
                                size: 14,
                                color: Colors.green.shade700,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "Buka panduan",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: const Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xFF1B5E20),
                        size: 23,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
