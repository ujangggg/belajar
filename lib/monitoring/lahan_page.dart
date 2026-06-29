import 'package:absen01/home.dart';
import 'package:absen01/widget/add_lahan.dart';
import 'package:absen01/model/model_lahan.dart'; // 🌟 Pastikan model lahan di-import
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/lahan_controller.dart';

class LahanPage extends StatelessWidget {
  LahanPage({super.key});

  final LahanController lahanC = Get.find<LahanController>();

  // Palet warna konsisten SITEBU
  final Color primaryGreen = const Color(0xFF1B5E20);
  final Color bgLight = const Color(0xFFF9FBF9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      appBar: AppBar(
        title: const Text(
          "Manajemen Lahan",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
        centerTitle: true,

        leading: IconButton(
          onPressed: () {
            Get.offAll(() => const HomePage(initialIndex: 1));
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryGreen,
        elevation: 4,
        icon: const Icon(
          Icons.agriculture_outlined,
          color: Colors.white,
          size: 22,
        ),
        label: const Text(
          "Lahan Baru",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        // 🌟 Berikan 'arguments: null' untuk memastikan form bersih saat buat lahan baru
        onPressed: () => Get.to(() => const AddLahan(), arguments: null),
      ),
      body: RefreshIndicator(
        color: primaryGreen,
        onRefresh: () async => lahanC.fetchLahan(),
        child: Obx(() {
          if (lahanC.isLoading.value && lahanC.lahanList.isEmpty) {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(primaryGreen),
              ),
            );
          }

          if (lahanC.lahanList.isEmpty) {
            return _buildEmptyState(context);
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            itemCount: lahanC.lahanList.length,
            itemBuilder: (context, index) {
              final lahan = lahanC.lahanList[index];
              return _buildLahanCard(lahan);
            },
          );
        }),
      ),
    );
  }

  // 🌟 Ubah tipe parameter dari dynamic menjadi LahanModel agar lebih aman (type-safe)
  Widget _buildLahanCard(LahanModel lahan) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {}, // Detail Lahan jika diperlukan
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
              child: Row(
                children: [
                  // Icon Lahan
                  Container(
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(
                      color: primaryGreen.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.eco_rounded,
                      color: primaryGreen,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Info Tengah
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lahan.namaLahan,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Color(0xFF2D312E),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.category_outlined,
                              size: 12,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              lahan.varietas,
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 12,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${lahan.tanggalTanam.day}/${lahan.tanggalTanam.month}/${lahan.tanggalTanam.year}",
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Badge Luas
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "${lahan.luas}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: primaryGreen,
                        ),
                      ),
                      Text(
                        "Hektar",
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  // Menu Aksi (Edit & Hapus)
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert_rounded,
                      color: Colors.grey[400],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onSelected: (value) {
                      if (value == 'edit') {
                        Get.to(() => const AddLahan(), arguments: lahan);
                      } else if (value == 'delete') {
                        _confirmDelete(lahan.id);
                      }
                    },
                    itemBuilder:
                        (BuildContext context) => [
                          PopupMenuItem<String>(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.edit_outlined,
                                  size: 18,
                                  color: Colors.blue[700],
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Ubah Lahan',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete_outline_rounded,
                                  size: 18,
                                  color: Colors.red[600],
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Hapus',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.red[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.agriculture_outlined,
                size: 70,
                color: primaryGreen,
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              "Belum Ada Data Lahan",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Data lahan akan muncul otomatis setelah Anda menambahkan lahan baru",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(String id) {
    Get.defaultDialog(
      title: "Hapus Lahan?",
      titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      middleText:
          "Menghapus lahan juga berpotensi menghapus data aktivitas di dalamnya.",
      textConfirm: "Hapus",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red[600],
      cancelTextColor: primaryGreen,
      radius: 14,
      onConfirm: () {
        lahanC.deleteLahan(id);
        Get.back();
      },
    );
  }
}
