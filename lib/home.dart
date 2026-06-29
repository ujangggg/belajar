import 'dart:ui';
import 'package:absen01/views/budidaya_irigasi.dart';
import 'package:absen01/views/budidaya_lahan.dart';
import 'package:absen01/views/budidaya_pemupukan.dart';
import 'package:absen01/views/budidaya_perwatan.dart';
import 'package:absen01/views/chatAiPage.dart';
import 'package:absen01/views/riwayat_page.dart';
import 'package:absen01/views/seeALL.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:absen01/auth/auth_controller.dart';
import 'package:absen01/views/monitoring.dart';
import 'package:absen01/views/profil_ui.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  final int initialIndex;

  const HomePage({super.key, this.initialIndex = 0});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _currentIndex;
  DateTime? _lastPressedAt;
  final AuthController _authController = Get.find<AuthController>();
  bool _showFabText = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;

    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) {
        setState(() {
          _showFabText = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      _buildHomeContent(),
      MonitoringMainPage(),
      RiwayatPage(),
      ProfilePage(),
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final now = DateTime.now();
        if (_lastPressedAt == null ||
            now.difference(_lastPressedAt!) > const Duration(seconds: 2)) {
          _lastPressedAt = now;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Ketuk lagi untuk keluar'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.black.withOpacity(0.8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
          return;
        }
        SystemNavigator.pop();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: IndexedStack(index: _currentIndex, children: _pages),

        floatingActionButton:
            _currentIndex == 0
                ? FloatingActionButton.extended(
                  onPressed: () => Get.to(() => const GeminiPage()),
                  backgroundColor: const Color(0xFF8DBE54),
                  icon: const Icon(Icons.auto_awesome, color: Colors.white),
                  label: AnimatedOpacity(
                    opacity: _showFabText ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: const Text(
                      "Tanya AI",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
                : null,

        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  // ================= HOME =================

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageHeader(),
          const SizedBox(height: 14),
          _buildAiBanner(),
          const SizedBox(height: 18),

          // HEADER
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My Fields',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
                GestureDetector(
                  onTap: () => Get.to(() => const SeeAllPage()),
                  child: Text(
                    'See All',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),
          const SizedBox(height: 14),
          _buildMenuGrid(),
          const SizedBox(height: 90),
        ],
      ),
    );
  }

  // ================= HEADER =================

  Widget _buildImageHeader() {
    return Container(
      height: 210,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        image: DecorationImage(
          image: AssetImage('assets/lahan.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(28),
            bottomRight: Radius.circular(28),
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.25),
              Colors.black.withOpacity(0.65),
            ],
          ),
        ),
        padding: const EdgeInsets.fromLTRB(16, 45, 16, 18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTopUserInfo(),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Welcome to SITEBU",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopUserInfo() {
    return StreamBuilder<Map<String, dynamic>?>(
      stream: _authController.getUserStream(),
      builder: (context, snapshot) {
        final data = snapshot.data ?? {};

        final String name = data['name']?.toString() ?? "User";
        final String? photoBase64 = data['photoBase64']?.toString();

        return Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: ClipOval(
                child:
                    (photoBase64 != null && photoBase64.isNotEmpty)
                        ? Image.memory(
                          base64Decode(photoBase64),
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/logo_sitebu.jpeg',
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                        : Image.asset(
                          'assets/logo_sitebu.jpeg',
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      },
    );
  }

  // ================= AI BANNER =================

  Widget _buildAiBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF8DBE54).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Color(0xFF8DBE54),
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Butuh Bantuan?",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                Text(
                  "Tanya AI Pakar Tebu",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => Get.to(() => const GeminiPage()),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B5E20),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: const Text(
              "Coba",
              style: TextStyle(fontSize: 11, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // ================= MENU =================

  Widget _buildMenuGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.78, // 🔥 sebelumnya 0.9 → ini lebih aman
      children: [
        _buildMenuCard(
          "Pemilihan Lahan",
          "Kelola lahan dan kualitas tanah.",
          'assets/lahan.jpg',
          () => Get.to(() => const BudidayaLahanPage()),
        ),
        _buildMenuCard(
          "Irigasi",
          "Optimalkan penggunaan air.",
          'assets/irrigation.jpg',
          () => Get.to(() => const BudidayaIrigasiPage()),
        ),
        _buildMenuCard(
          "Pemupukan",
          "Atur nutrisi tanaman terbaik.",
          'assets/pupuk.jpg',
          () => Get.to(() => const BudidayaPemupukanPage()),
        ),
        _buildMenuCard(
          "Perawatan",
          "Optimalkan penggunaan air.",
          'assets/perawatan.jpg',
          () => Get.to(() => const PerawatanTebuPage()),
        ),
      ],
    );
  }

  Widget _buildMenuCard(
    String title,
    String subtitle,
    String imagePath,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE (FIXED)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
              child: Image.asset(
                imagePath,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            // 🔥 FLEXIBLE CONTENT
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Expanded(
                      // 🔥 ini penting biar gak overflow
                      child: Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Color(0xFF1B5E20),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // ================= BOTTOM NAV =================

  Widget _buildBottomNav() {
    return Container(
      height: 65,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      decoration: BoxDecoration(
        color: const Color(0xFFE8EBE9),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.home_filled, 0),
          _navItem(Icons.auto_stories_outlined, 1),
          _navItem(Icons.assignment_outlined, 2),
          _navItem(Icons.person_outline_rounded, 3),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, int index) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8DBE54) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 22,
          color: isSelected ? Colors.white : Colors.black54,
        ),
      ),
    );
  }
}
