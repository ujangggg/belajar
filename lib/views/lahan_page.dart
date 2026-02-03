import 'package:absen01/logo.dart'; // Pastikan UiHelper ada di sini
import 'package:absen01/widget/add_lahan.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/lahan_controller.dart';

class LahanPage extends StatelessWidget {
  LahanPage({super.key});

  final LahanController lahanC = Get.find<LahanController>();

  @override
  Widget build(BuildContext context) {
    return UiHelper.buildPageWrapper(
      context: context,
      title: "Daftar Lahan",
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1B5E20),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => Get.to(() => AddLahan()),
      ),
      child: RefreshIndicator(
        onRefresh: () async => lahanC.fetchLahan(),
        child: Obx(() {
          // 1. Tampilan Loading
          if (lahanC.isLoading.value && lahanC.lahanList.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Tampilan Jika Kosong
          if (lahanC.lahanList.isEmpty) {
            return ListView(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                const Center(
                  child: Column(
                    children: [
                      Icon(Icons.landscape, size: 80, color: Color(0xFF1B5E20)),
                      SizedBox(height: 10),
                      Text(
                        "Belum ada data lahan",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("Klik tombol + untuk menambah lahan baru"),
                    ],
                  ),
                ),
              ],
            );
          }

          // 3. Tampilan List Data
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: lahanC.lahanList.length,
            itemBuilder: (context, index) {
              final lahan = lahanC.lahanList[index];

              return UiHelper.buildDataCard(
                title: lahan.namaLahan,
                subtitle:
                    "Varietas: ${lahan.varietas} | Tanam: ${lahan.tanggalTanam.day}/${lahan.tanggalTanam.month}/${lahan.tanggalTanam.year}",
                icon: Icons.landscape_rounded,
                trailingText: "${lahan.luas} Ha",
                onTap: () {
                  // Tambahkan detail lahan di sini jika perlu
                },
              );
            },
          );
        }),
      ),
    );
  }
}
