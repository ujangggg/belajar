import 'package:absen01/logo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/lahan_controller.dart';
import '../controller/analisis_controller.dart';

class AddAnalisis extends StatelessWidget {
  AddAnalisis({super.key});

  final AnalisisController analisisC = Get.find();
  final LahanController lahanC = Get.find();

  final RxString selectedLahanId = ''.obs;

  @override
  Widget build(BuildContext context) {
    return UiHelper.buildPageWrapper(
      context: context,
      title: "Proses Analisis Lahan",
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            /// DROPDOWN LAHAN
            Obx(() {
              return DropdownButtonFormField<String>(
                value:
                    selectedLahanId.value.isEmpty
                        ? null
                        : selectedLahanId.value,
                hint: const Text("Pilih Lahan"),
                items:
                    lahanC.lahanList
                        .map(
                          (l) => DropdownMenuItem(
                            value: l.id,
                            child: Text(l.namaLahan),
                          ),
                        )
                        .toList(),
                onChanged: (val) => selectedLahanId.value = val!,
              );
            }),
            const SizedBox(height: 20),

            UiHelper.buildButton(
              text: "Proses Analisis",
              color: Colors.orange.shade800,
              icon: Icons.analytics,
              onPressed: () async {
                if (selectedLahanId.value.isEmpty) {
                  Get.snackbar("Error", "Pilih lahan terlebih dahulu");
                  return;
                }

                final lahan = lahanC.lahanList.firstWhere(
                  (e) => e.id == selectedLahanId.value,
                );

                await analisisC.hitungAnalisis(
                  lahanId: lahan.id,
                  tanggalTanam: lahan.tanggalTanam,
                );

                Get.back();
                Get.snackbar("Sukses", "Analisis berhasil diperbarui");
              },
            ),
          ],
        ),
      ),
    );
  }
}
