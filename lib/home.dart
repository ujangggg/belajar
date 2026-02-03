import 'package:absen01/controller/analisis_controller.dart';
import 'package:absen01/controller/irigasi_controller.dart';
import 'package:absen01/controller/lahan_controller.dart';
import 'package:absen01/views/analisis_page.dart';
import 'package:absen01/views/irigasi_page.dart';
import 'package:absen01/views/lahan_page.dart';
import 'package:absen01/views/profil_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:absen01/auth/auth_controller.dart';
// Import halaman list yang sudah dibuat

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final AuthController _authController = Get.find<AuthController>();
  final LahanController lahanController = Get.put(LahanController());
  final IrigasiController irigasiController = Get.put(IrigasiController());
  final AnalisisController analisisController = Get.put(AnalisisController());

  @override
  Widget build(BuildContext context) {
    // List halaman untuk navigasi bottom bar
    final List<Widget> _pages = [
      _buildHomeContent(),
      const Center(child: Text("Halaman Buku / Pelaporan PDF")),
      ProfilePage(),
    ];

    return Scaffold(
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
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
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
        showUnselectedLabels: true,
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
    );
  }

  Widget _buildHomeContent() {
    return Stack(
      children: [
        // Background Watermark SITEBU
        Positioned.fill(
          child: Opacity(
            opacity: 0.1,
            child: Center(
              child: Image.asset(
                'assets/logo_sitebu.jpeg',
                width: MediaQuery.of(context).size.width * 0.8,
              ),
            ),
          ),
        ),

        SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting Card
              _buildGreetingCard(),

              const SizedBox(height: 30),
              const Text(
                'Menu Utama SITEBU',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B5E20),
                ),
              ),
              const SizedBox(height: 16),

              // GRID MENU UTAMA
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _MenuItem(
                    icon: Icons.map_rounded,
                    title: 'Lahan Tebu',
                      onTap: () => Get.to(() => LahanPage()),
                    
                  ),
                  _MenuItem(
                    icon: Icons.water_drop_rounded,
                    title: 'Irigasi',
                    // Karena Irigasi butuh ID Lahan, kita arahkan dulu ke List Lahan untuk pilih lahan
                   onTap: () => Get.to(() => IrigasiPage()),
                  ),
                  _MenuItem(
                    icon: Icons.analytics_rounded,
                    title: 'Analisis Panen',
                    onTap: () => Get.to(() => AnalisisPage()),
                  ),
                  _MenuItem(
                    icon: Icons.history_edu_rounded,
                    title: 'Pelaporan',
                    onTap:
                        () => setState(
                          () => _currentIndex = 1,
                        ), // Pindah ke tab Buku
                  ),
                ],
              ),

              const SizedBox(height: 30),
              const Text(
                'Info Agritech',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const _NewsCard(
                title: 'Tips Rendemen Tinggi',
                subtitle: 'Cara mengatur irigasi agar gula tebu maksimal.',
                icon: Icons.lightbulb,
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
        String name = snapshot.data?['name'] ?? "Petani SITEBU";
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            gradient: const LinearGradient(
              colors: [Color(0xFF1B5E20), Color(0xFF388E3C)],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Selamat Datang 👋',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 6),
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: const Color(0xFF2E7D32)),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _NewsCard({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 10),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE8F5E9),
          child: Icon(icon, color: const Color(0xFF2E7D32)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
