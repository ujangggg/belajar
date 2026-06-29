import 'package:absen01/home.dart';
import 'package:absen01/views/budidaya_pemupukan.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class BudidayaIrigasiPage extends StatefulWidget {
  const BudidayaIrigasiPage({super.key});

  @override
  State<BudidayaIrigasiPage> createState() => _BudidayaIrigasiPageState();
}

class _BudidayaIrigasiPageState extends State<BudidayaIrigasiPage> {
  late VideoPlayerController _videoController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset('assets/videos/irigasi.mp4')
      ..initialize().then((_) {
        if (mounted) setState(() => _isInitialized = true);
      });
    _videoController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double videoHeight = screenWidth * (9 / 16);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Panduan Budidaya",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black, size: 26),
            onPressed: () => Get.offAll(() => const HomePage()),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildVideoPlayer(screenWidth, videoHeight),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Sistem Pengairan Efektif",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildBadge("Tahap Pemeliharaan"),

                  const SizedBox(height: 25),
                  const Text(
                    "Deskripsi Kegiatan",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildDescriptionCard(
                    "Pengairan yang terjadwal sangat penting untuk menjaga kadar air dalam tanah. Tanaman tebu yang cukup air akan memiliki batang yang lebih tinggi dan rendemen gula yang lebih baik.",
                  ),

                  const SizedBox(height: 25),
                  const Text(
                    "Tujuan",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildDescriptionCard(
                    "Memastikan ketersediaan air di fase vegetatif guna mendukung pertumbuhan batang secara maksimal dan meningkatkan kualitas nira.",
                  ),

                  const SizedBox(height: 25),
                  const Text(
                    "Langkah-Langkah",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  _buildStepItem(
                    "01",
                    "Cek kondisi parit irigasi agar tidak ada genangan.",
                  ),
                  _buildStepItem(
                    "02",
                    "Buka pintu air utama sesuai kebutuhan petak lahan.",
                  ),
                  _buildStepItem(
                    "03",
                    "Pastikan air meresap hingga ke zona perakaran tebu.",
                  ),
                  _buildStepItem(
                    "04",
                    "Tutup kembali pintu air setelah tanah lembap merata.",
                  ),

                  const SizedBox(height: 25),
                  const Text(
                    "Informasi Penting",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildDescriptionCard(
                    "Pastikan debit air yang dialirkan tidak terlalu deras guna menghindari erosi pada bedengan tanam. Selain itu, periksa secara berkala kebersihan saluran irigasi dari sampah atau endapan lumpur yang dapat menghambat aliran air.",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: _buildBottomAction(),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildVideoPlayer(double width, double height) {
    return Container(
      width: width,
      height: height,
      color: Colors.black,
      child:
          _isInitialized
              ? Stack(
                alignment: Alignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: VideoPlayer(_videoController),
                  ),
                  GestureDetector(
                    onTap:
                        () => setState(
                          () =>
                              _videoController.value.isPlaying
                                  ? _videoController.pause()
                                  : _videoController.play(),
                        ),
                    child: Container(
                      color: Colors.transparent,
                      child: Center(
                        child: AnimatedOpacity(
                          opacity: _videoController.value.isPlaying ? 0.0 : 1.0,
                          duration: const Duration(milliseconds: 300),
                          child: const CircleAvatar(
                            backgroundColor: Colors.black45,
                            radius: 30,
                            child: Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: VideoProgressIndicator(
                      _videoController,
                      allowScrubbing: true,
                      colors: const VideoProgressColors(
                        playedColor: Color(0xFF2196F3),
                      ),
                    ),
                  ),
                ],
              )
              : const Center(
                child: CircularProgressIndicator(color: Colors.blue),
              ),
    );
  }

  Widget _buildBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF2196F3).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF1976D2),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildDescriptionCard(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black54,
          height: 1.5,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _buildStepItem(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: Colors.black,
            child: Text(
              number,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction() {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 100,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Langkah 2 dari 4",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text("Irigasi", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => Get.to(() => const BudidayaPemupukanPage()),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
            child: const Text(
              "Lanjut",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
