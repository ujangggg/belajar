import 'package:absen01/home.dart';
import 'package:absen01/views/budidaya_perwatan.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class BudidayaPemupukanPage extends StatefulWidget {
  const BudidayaPemupukanPage({super.key});

  @override
  State<BudidayaPemupukanPage> createState() => _BudidayaPemupukanPageState();
}

class _BudidayaPemupukanPageState extends State<BudidayaPemupukanPage> {
  late VideoPlayerController _videoController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset('assets/videos/pupuk.mp4')
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
                    "Nutrisi Tanaman Tebu",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildBadge("Tahap Nutrisi & Hara"),

                  const SizedBox(height: 25),
                  const Text(
                    "Deskripsi Kegiatan",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildDescriptionCard(
                    "Pemupukan yang tepat dosis dan tepat waktu sangat menentukan hasil rendemen tebu. Pemberian unsur Nitrogen, Fosfor, dan Kalium (NPK) harus disesuaikan dengan umur tanaman.",
                  ),

                  const SizedBox(height: 25),
                  const Text(
                    "Langkah-Langkah",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  _buildStepItem(
                    "01",
                    "Gunakan campuran pupuk Urea, TSP, dan KCl sesuai dosis.",
                  ),
                  _buildStepItem(
                    "02",
                    "Buat lubang atau parit kecil di samping rumpun tebu.",
                  ),
                  _buildStepItem(
                    "03",
                    "Taburkan pupuk secara merata dan tutup kembali dengan tanah.",
                  ),
                  _buildStepItem(
                    "04",
                    "Lakukan pemupukan susulan pada usia 3 bulan.",
                  ),

                  const SizedBox(height: 25),
                  const Text(
                    "Informasi Penting",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildDescriptionCard(
                    "Pastikan tanah dalam kondisi lembap saat pemupukan agar unsur hara cepat diserap oleh akar. Hindari pemberian pupuk terlalu dekat dengan batang utama untuk mencegah risiko terbakar pada tanaman.",
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
                        playedColor: Colors.orange,
                      ),
                    ),
                  ),
                ],
              )
              : const Center(
                child: CircularProgressIndicator(color: Colors.orange),
              ),
    );
  }

  Widget _buildBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.orange,
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
            backgroundColor: Colors.orange.shade800,
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
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
                  "Tahap 3 dari 4",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  "Pemupukan",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => Get.to(() => const PerawatanTebuPage()),
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
