import 'package:absen01/logo.dart';
import 'package:absen01/widget/add_irigasi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/irigasi_controller.dart';
import '../controller/lahan_controller.dart';

class IrigasiPage extends StatelessWidget {
  IrigasiPage({super.key});

  final IrigasiController irigasiC = Get.find();
  final LahanController lahanC = Get.find();

  final RxString selectedLahanId = ''.obs;

  @override
  Widget build(BuildContext context) {
    return UiHelper.buildPageWrapper(
      context: context,
      title: "Data Irigasi",
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade800,
        child: const Icon(Icons.water_drop, color: Colors.white),
        onPressed: () {
          Get.to(() => AddIrigasi());
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
                  irigasiC.fetchIrigasiByLahan(val);
                },
              );
            }),
          ),

          /// LIST IRIGASI
          Expanded(
            child: Obx(() {
              if (irigasiC.irigasiList.isEmpty) {
                return const Center(child: Text("Belum ada data irigasi"));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: irigasiC.irigasiList.length,
                itemBuilder: (context, index) {
                  final irigasi = irigasiC.irigasiList[index];

                  return UiHelper.buildDataCard(
                    title: "Irigasi ${index + 1}",
                    subtitle:
                        "Volume: ${irigasi.volumeAir} L | Durasi: ${irigasi.durasi} menit",
                    icon: Icons.waves_rounded,
                    iconColor: Colors.blue,
                    onTap: () {},
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
