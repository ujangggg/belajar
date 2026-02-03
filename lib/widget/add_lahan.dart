import 'package:absen01/logo.dart';
import 'package:absen01/model/model_lahan.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/lahan_controller.dart';

class AddLahan extends StatelessWidget {
  AddLahan({super.key});

  final LahanController lahanC = Get.find();

  final nameCtrl = TextEditingController();
  final luasCtrl = TextEditingController();
  final varietasCtrl = TextEditingController();
  final lokasiCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return UiHelper.buildPageWrapper(
      context: context,
      title: "Daftar Lahan Baru",
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            UiHelper.buildInput(
              icon: Icons.landscape,
              hint: "Nama Lahan",
              ctrl: nameCtrl,
            ),
            UiHelper.buildInput(
              icon: Icons.location_on,
              hint: "Lokasi Lahan",
              ctrl: lokasiCtrl,
            ),
            UiHelper.buildInput(
              icon: Icons.square_foot,
              hint: "Luas (Hektar)",
              ctrl: luasCtrl,
              isNumber: true,
            ),
            UiHelper.buildInput(
              icon: Icons.eco,
              hint: "Varietas Tebu",
              ctrl: varietasCtrl,
            ),
            const SizedBox(height: 20),
            UiHelper.buildButton(
              text: "Simpan Lahan",
              icon: Icons.save,
              onPressed: () async {
                final lahan = LahanModel(
                  id: '',
                  namaLahan: nameCtrl.text,
                  lokasi: lokasiCtrl.text,
                  luas: double.parse(luasCtrl.text),
                  varietas: varietasCtrl.text,
                  tanggalTanam: DateTime.now(),
                  status: 'aktif',
                );

                await lahanC.addLahan(lahan);
                Get.back();
                Get.snackbar("Berhasil", "Lahan berhasil disimpan");
              },
            ),
          ],
        ),
      ),
    );
  }
}
