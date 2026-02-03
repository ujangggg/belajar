import 'package:absen01/logo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/laporan_controller.dart';

class LaporanPage extends StatelessWidget {
  LaporanPage({super.key});

  final LaporanController laporanC = Get.find();

  @override
  Widget build(BuildContext context) {
    return UiHelper.buildPageWrapper(
      context: context,
      title: "Laporan Lahan",
      child: Obx(() {
        if (laporanC.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (laporanC.laporanList.isEmpty) {
          return const Center(child: Text("Belum ada data laporan"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: laporanC.laporanList.length,
          itemBuilder: (context, index) {
            final data = laporanC.laporanList[index];

            return UiHelper.buildDataCard(
              title: data['namaLahan'],
              subtitle:
                  "Luas: ${data['luas']} Ha | Air: ${data['totalAir']} L",
              icon: Icons.description_rounded,
              trailingText: data['status'],
              onTap: () {
                Get.dialog(
                  AlertDialog(
                    title: const Text("Detail Laporan"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Varietas: ${data['varietas']}"),
                        Text("Umur Tanam: ${data['umur']} hari"),
                        Text("Status: ${data['status']}"),
                        const SizedBox(height: 8),
                        Text("Rekomendasi:"),
                        Text(data['rekomendasi']),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text("Tutup"),
                      )
                    ],
                  ),
                );
              },
            );
          },
        );
      }),
    );
  }
}
