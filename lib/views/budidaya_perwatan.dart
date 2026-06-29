import 'package:absen01/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'budidaya_irigasi.dart';

class PerawatanTebuPage extends StatefulWidget {
  const PerawatanTebuPage({super.key});

  @override
  State<PerawatanTebuPage> createState() => _PerawatanTebuPageState();
}

class _PerawatanTebuPageState extends State<PerawatanTebuPage> {
  late VideoPlayerController _videoController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    _videoController = VideoPlayerController.asset(
        'assets/videos/perawatan.mp4',
      )
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
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
          "Panduan Perawatan",
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
            onPressed: () {
              Get.offAll(() => const HomePage());
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: screenWidth,
              height: videoHeight,
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
                            onTap: () {
                              setState(() {
                                _videoController.value.isPlaying
                                    ? _videoController.pause()
                                    : _videoController.play();
                              });
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: Center(
                                child: AnimatedOpacity(
                                  opacity:
                                      _videoController.value.isPlaying
                                          ? 0.0
                                          : 1.0,
                                  duration: const Duration(milliseconds: 300),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: const BoxDecoration(
                                      color: Colors.black45,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
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
                                playedColor: Color(0xFF2E7D32),
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
            ),

            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Perawatan Tanaman Tebu",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  _buildBadge("Tahap Perawatan Tanaman"),

                  const SizedBox(height: 25),

                  const Text(
                    "Deskripsi Kegiatan",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  _buildDescriptionCard(
                    "Perawatan tanaman tebu merupakan tahap penting setelah penanaman untuk menjaga pertumbuhan batang, kesehatan tanaman, dan produktivitas hasil panen. Perawatan dilakukan melalui pengairan yang cukup, pemupukan berimbang, penyiangan gulma, pembumbunan tanah, serta pengendalian hama dan penyakit secara terpadu.",
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "Tujuan Perawatan",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  _buildDescriptionCard(
                    "Tujuan utama perawatan tebu adalah memastikan tanaman mendapatkan air, unsur hara, cahaya, dan ruang tumbuh yang optimal. Perawatan yang baik dapat membantu meningkatkan jumlah anakan, memperkuat akar, memperbesar batang, serta meningkatkan kadar gula pada tanaman tebu.",
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "Langkah-Langkah Perawatan",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 15),

                  _buildStepItem(
                    "01",
                    "Lakukan penyiraman secara teratur, terutama pada fase awal pertumbuhan tanaman tebu.",
                  ),

                  _buildStepItem(
                    "02",
                    "Berikan pupuk nitrogen, fosfor, dan kalium sesuai kebutuhan tanaman untuk mendukung pertumbuhan batang.",
                  ),

                  _buildStepItem(
                    "03",
                    "Lakukan penyiangan gulma setiap 3 sampai 4 minggu agar tidak terjadi persaingan unsur hara.",
                  ),

                  _buildStepItem(
                    "04",
                    "Lakukan pembumbunan tanah di sekitar rumpun tebu untuk memperkuat akar dan menjaga kelembapan tanah.",
                  ),

                  _buildStepItem(
                    "05",
                    "Pantau keberadaan hama seperti penggerek batang dan lakukan pengendalian secara terpadu.",
                  ),

                  _buildStepItem(
                    "06",
                    "Buang daun kering atau bagian tanaman yang terserang penyakit agar tidak menyebar ke tanaman sehat.",
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "Informasi Penting",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  _buildDescriptionCard(
                    "Perawatan tebu sebaiknya dilakukan secara rutin sejak tanaman berumur muda hingga menjelang masa pemasakan. Kekurangan air, unsur hara, dan serangan gulma dapat menurunkan pertumbuhan batang serta hasil produksi tebu.",
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

  Widget _buildBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF2E7D32).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF2E7D32),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: const Color(0xFF2E7D32),
            child: Text(
              number,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.w500, height: 1.4),
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
                Text(
                  "Perawatan Tebu",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => Get.off(() => const HomePage()),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
            child: const Text(
              "Selesai",
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
