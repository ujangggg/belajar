import 'package:absen01/logo.dart';
import 'package:absen01/widget/add_analisis.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/analisis_controller.dart';
import '../controller/lahan_controller.dart';

class AnalisisPage extends StatelessWidget {
  AnalisisPage({super.key});

  final AnalisisController analisisC = Get.find();
  final LahanController lahanC = Get.find();

  final RxString selectedLahanId = ''.obs;

  @override
  Widget build(BuildContext context) {
    return UiHelper.buildPageWrapper(
      context: context,
      title: "Hasil Analisis",
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange.shade800,
        child: const Icon(Icons.analytics_rounded, color: Colors.white),
        onPressed: () {
          Get.to(() => AddAnalisis());
        },
      ),
      child: Column(
        children: [
          /// DROPDOWN PILIH LAHAN
          Padding(
            padding: const EdgeInsets.all(16),
            child: Obx(() {
              return DropdownButtonFormField<String>(
                hint: const Text("Pilih Lahan"),
                value:
                    selectedLahanId.value.isEmpty
                        ? null
                        : selectedLahanId.value,
                items:
                    lahanC.lahanList
                        .map(
                          (l) => DropdownMenuItem(
                            value: l.id,
                            child: Text(l.namaLahan),
                          ),
                        )
                        .toList(),
                onChanged: (val) {
                  selectedLahanId.value = val!;
                  analisisC.fetchAnalisis(val);
                },
              );
            }),
          ),

          /// HASIL ANALISIS
          Expanded(
            child: Obx(() {
              final data = analisisC.analisis.value;

              if (data == null) {
                return const Center(child: Text("Belum ada data analisis"));
              }

              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  UiHelper.buildDataCard(
                    title: "Status Tanaman",
                    subtitle: data.statusTanaman,
                    icon: Icons.health_and_safety,
                    iconColor: Colors.orange,
                    trailingText: "${data.totalAir} L",
                    onTap: () {},
                  ),
                  UiHelper.buildDataCard(
                    title: "Umur Tanam",
                    subtitle: "${data.umurTanamHari} hari",
                    icon: Icons.calendar_today,
                    iconColor: Colors.green,
                    onTap: () {},
                  ),
                  UiHelper.buildDataCard(
                    title: "Rekomendasi",
                    subtitle: data.rekomendasi,
                    icon: Icons.lightbulb,
                    iconColor: Colors.amber,
                    onTap: () {},
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
