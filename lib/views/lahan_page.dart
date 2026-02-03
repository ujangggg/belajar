import 'package:absen01/logo.dart';
import 'package:absen01/widget/add_lahan.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/lahan_controller.dart';

class LahanPage extends StatelessWidget {
  LahanPage({super.key});

  final LahanController lahanC = Get.find();

  @override
  Widget build(BuildContext context) {
    return UiHelper.buildPageWrapper(
      context: context,
      title: "Daftar Lahan",
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1B5E20),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Get.to(() => AddLahan());
        },
      ),
      child: Obx(() {
        if (lahanC.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (lahanC.lahanList.isEmpty) {
          return const Center(child: Text("Belum ada data lahan"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: lahanC.lahanList.length,
          itemBuilder: (context, index) {
            final lahan = lahanC.lahanList[index];

            return UiHelper.buildDataCard(
              title: lahan.namaLahan,
              subtitle:
                  "Varietas: ${lahan.varietas} | Tanam: ${lahan.tanggalTanam.day}/${lahan.tanggalTanam.month}",
              icon: Icons.landscape_rounded,
              trailingText: "${lahan.luas} Ha",
              onTap: () {
                // nanti bisa ke detail lahan
              },
            );
          },
        );
      }),
    );
  }
}
