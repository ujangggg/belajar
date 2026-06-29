import 'package:absen01/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'budidaya_irigasi.dart';

class BudidayaLahanPage extends StatefulWidget {
  const BudidayaLahanPage({super.key});

  @override
  State<BudidayaLahanPage> createState() => _BudidayaLahanPageState();
}

class _BudidayaLahanPageState extends State<BudidayaLahanPage> {
  late VideoPlayerController _videoController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset('assets/videos/lahan.mp4')
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
        }
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
        // Padding bottom ditambahkan agar tidak tertutup bottomSheet
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
                    "Teknik Membajak Lahan",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildBadge("Tahap Persiapan Lahan"),
                  const SizedBox(height: 25),
                  _buildSectionTitle("Deskripsi Kegiatan"),
                  _buildDescriptionCard(
                    "Pemilihan lahan dilakukan dengan memilih tanah yang subur, memiliki drainase baik, dan tidak tergenang air agar tanaman dapat tumbuh optimal. Setelah itu, lahan dibajak untuk menggemburkan tanah dan membalik lapisan atas agar sisa gulma, hama, serta penyakit terpapar sinar matahari sehingga mati dan proses aerasi tanah menjadi lebih baik.",
                  ),
                  const SizedBox(height: 25),
                  _buildSectionTitle("Kondisi"),
                  _buildDescriptionCard(
                    "Pembajakan umumnya dilakukan menggunakan traktor untuk mempercepat pekerjaan dan menghasilkan olahan tanah yang lebih dalam serta merata, namun jika kondisi ekonomi tidak memungkinkan, pembajakan masih bisa dilakukan secara tradisional menggunakan tenaga sapi sebagai alternatif yang lebih terjangkau meskipun membutuhkan waktu dan tenaga lebih besar.",
                  ),
                  const SizedBox(height: 25),
                  _buildSectionTitle("Langkah-Langkah"),
                  const SizedBox(height: 15),
                  _buildStepItem(
                    "01",
                    "Pengecekan kelembapan tanah (jangan terlalu basah).",
                  ),
                  _buildStepItem(
                    "02",
                    "Gunakan traktor dengan mata bajak sedalam 30 cm.",
                  ),
                  _buildStepItem(
                    "03",
                    "Lakukan pola pembajakan searah jarum jam.",
                  ),
                  _buildStepItem(
                    "04",
                    "Biarkan tanah beristirahat selama 3 hari sebelum tanam.",
                  ),
                  const SizedBox(height: 25),
                  _buildSectionTitle("Informasi Penting"),
                  const SizedBox(height: 12),
                  _buildDescriptionCard(
                    "Lahan harus dipilih yang subur dan tidak tergenang air, lalu pembajakan wajib dilakukan untuk menggemburkan tanah dan meningkatkan aerasi agar akar tanaman bisa tumbuh optimal serta mengurangi hama dan gulma. Pembajakan bisa menggunakan traktor untuk hasil cepat dan maksimal, tetapi jika biaya terbatas dapat menggunakan tenaga sapi sebagai alternatif yang lebih murah meskipun lebih lambat dan membutuhkan tenaga lebih besar.",
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
                        playedColor: Color(0xFF1B5E20),
                        bufferedColor: Colors.grey,
                        backgroundColor: Colors.black26,
                      ),
                    ),
                  ),
                ],
              )
              : const Center(
                child: CircularProgressIndicator(color: Colors.green),
              ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1B5E20).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF1B5E20),
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
        style: const TextStyle(color: Colors.black54, height: 1.5),
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
                  "Langkah 1 dari 4",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  "Persiapan Lahan",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => Get.to(() => const BudidayaIrigasiPage()),
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
