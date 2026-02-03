import 'package:absen01/logo.dart';
import 'package:absen01/model/model_irigasi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/lahan_controller.dart';
import '../controller/irigasi_controller.dart';

class AddIrigasi extends StatelessWidget {
  AddIrigasi({super.key});

  final IrigasiController irigasiC = Get.find();
  final LahanController lahanC = Get.find();

  final volCtrl = TextEditingController();
  final durasiCtrl = TextEditingController();
  final catatanCtrl = TextEditingController();

  final RxString selectedLahanId = ''.obs;

  @override
  Widget build(BuildContext context) {
    return UiHelper.buildPageWrapper(
      context: context,
      title: "Catat Irigasi",
      child: SingleChildScrollView(
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
            const SizedBox(height: 16),

            UiHelper.buildInput(
              icon: Icons.water_drop,
              hint: "Volume Air (Liter)",
              ctrl: volCtrl,
              isNumber: true,
            ),
            UiHelper.buildInput(
              icon: Icons.timer,
              hint: "Durasi (Menit)",
              ctrl: durasiCtrl,
              isNumber: true,
            ),
            UiHelper.buildInput(
              icon: Icons.notes,
              hint: "Catatan Kondisi Tanah",
              ctrl: catatanCtrl,
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            UiHelper.buildButton(
              text: "Simpan Data Air",
              color: Colors.blue.shade700,
              icon: Icons.check_circle,
              onPressed: () async {
                if (selectedLahanId.value.isEmpty) {
                  Get.snackbar("Error", "Pilih lahan terlebih dahulu");
                  return;
                }

                final irigasi = IrigasiModel(
                  id: '',
                  lahanId: selectedLahanId.value,
                  tanggal: DateTime.now(),
                  metode: 'Manual',
                  volumeAir: double.parse(volCtrl.text),
                  durasi: int.parse(durasiCtrl.text),
                  kondisiTanah: 'Lembab',
                  catatan: catatanCtrl.text,
                );

                await irigasiC.addIrigasi(irigasi);
                Get.back();
                Get.snackbar("Berhasil", "Data irigasi tersimpan");
              },
            ),
          ],
        ),
      ),
    );
  }
}
