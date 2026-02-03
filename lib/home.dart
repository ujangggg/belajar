import 'package:absen01/views/buku_panduan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:absen01/auth/auth_controller.dart';
import 'package:absen01/controller/pupuk_controller.dart';
import 'package:absen01/controller/irigasi_controller.dart';
import 'package:absen01/controller/lahan_controller.dart';
import 'package:absen01/controller/laporan_controller.dart';
import 'package:absen01/views/pupuk_page.dart';
import 'package:absen01/views/irigasi_page.dart';
import 'package:absen01/views/lahan_page.dart';
import 'package:absen01/views/laporan_page.dart';
import 'package:absen01/views/profil_ui.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  DateTime? _lastPressedAt; // Untuk menyimpan waktu ketukan terakhir

  final AuthController _authController = Get.find<AuthController>();
  final LahanController lahanController = Get.find<LahanController>();
  final IrigasiController irigasiController = Get.find<IrigasiController>();
  final PupukController pupukController = Get.find<PupukController>();
  final LaporanController _laporanController = Get.find<LaporanController>();

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      _buildHomeContent(),
      const PanduanTebuPage(),
      ProfilePage(),
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final now = DateTime.now();
        // Jika ketukan kedua dilakukan dalam kurang dari 2 detik
        if (_lastPressedAt == null ||
            now.difference(_lastPressedAt!) > const Duration(seconds: 2)) {
          _lastPressedAt = now;

          // Munculkan notifikasi hitam (Snackbar bergaya Toast)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Ketuk lagi untuk keluar',
                textAlign: TextAlign.left, // Teks rata kiri
                style: TextStyle(color: Colors.white),
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.black.withOpacity(0.8),
              duration: const Duration(seconds: 2),
              margin: const EdgeInsets.all(
                20,
              ), // Memberi jarak dari pinggir layar agar tidak nempel banget
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  10,
                ), // Radius lebih kecil biar terlihat lebih memanjang dan formal
              ),
              // Properti 'width' dihapus agar SnackBar otomatis memanjang mengikuti lebar layar
            ),
          );
          return;
        }

        // Jika sudah ketukan kedua, tutup aplikasi
        SystemNavigator.pop();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6F5),
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Image.asset('assets/logo_sitebu.jpeg', height: 35),
              const SizedBox(width: 10),
              const Text(
                'SITEBU',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
              ),
            ),
          ),
        ),
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: const Color(0xFF2E7D32),
          unselectedItemColor: Colors.grey,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_stories_outlined),
              label: 'Buku',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    return Stack(
      children: [
        Positioned.fill(
          child: Opacity(
            opacity: 0.1,
            child: Center(
              child: Image.asset('assets/logo_sitebu.jpeg', width: 250),
            ),
          ),
        ),
        SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGreetingCard(),
              const SizedBox(height: 30),
              const Text(
                'Menu Utama',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B5E20),
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _MenuItem(
                    icon: Icons.landscape_rounded,
                    title: 'Lahan Tebu',
                    onTap: () => Get.to(() => LahanPage()),
                  ),
                  _MenuItem(
                    icon: Icons.water_drop_rounded,
                    title: 'Irigasi',
                    onTap: () => Get.to(() => IrigasiPage()),
                  ),
                  _MenuItem(
                    icon: Icons.agriculture_rounded,
                    title: 'Pemupukan',
                    onTap: () => Get.to(() => PemupukanPage()),
                  ),
                  _MenuItem(
                    icon: Icons.description_rounded,
                    title: 'Pelaporan',
                    onTap: () => Get.to(() => LaporanPage()),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGreetingCard() {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _authController.getUserData(),
      builder: (context, snapshot) {
        String name = snapshot.data?['name'] ?? "petani";
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            gradient: const LinearGradient(
              colors: [Color(0xFF1B5E20), Color(0xFF388E3C)],
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Selamat Datang 👋',
                      style: TextStyle(color: Colors.white70),
                    ),
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.eco, color: Color(0xFFDCE775), size: 40),
            ],
          ),
        );
      },
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: const Color(0xFF2E7D32)),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
