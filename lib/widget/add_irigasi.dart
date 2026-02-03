import 'package:absen01/auth/auth_controller.dart';
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
  final AuthController authC = Get.find(); // Akses Auth

  final volCtrl = TextEditingController();
  final durasiCtrl = TextEditingController();
  final humidCtrl = TextEditingController(); 
  final catatanCtrl = TextEditingController();

  final RxString selectedLahanId = ''.obs;
  final RxString selectedFase = 'Pertumbuhan'.obs;
  final RxString statusOtomatis = '-'.obs;

  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFF1B5E20)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF1B5E20), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return UiHelper.buildPageWrapper(
      context: context,
      title: "Catat Irigasi & Kelembaban",
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => DropdownButtonFormField<String>(
                  isExpanded: true,
                  decoration: _inputStyle("Pilih Lahan", Icons.map),
                  value: selectedLahanId.value.isEmpty ? null : selectedLahanId.value,
                  items: lahanC.lahanList
                      .map((l) => DropdownMenuItem(
                            value: l.id, 
                            child: Text(l.namaLahan, overflow: TextOverflow.ellipsis),
                          ))
                      .toList(),
                  onChanged: (val) => selectedLahanId.value = val!,
                )),
            const SizedBox(height: 16),

            TextField(
              controller: humidCtrl,
              keyboardType: TextInputType.number,
              decoration: _inputStyle("Kelembaban Tanah (%)", Icons.speed),
              onChanged: (val) {
                if (val.isNotEmpty) {
                  double h = double.tryParse(val) ?? 0;
                  statusOtomatis.value = IrigasiModel.hitungKondisi(h);
                }
              },
            ),
            
            Obx(() => Padding(
                  padding: const EdgeInsets.only(left: 4, top: 8, bottom: 16),
                  child: Text(
                    "Kondisi Tanah: ${statusOtomatis.value}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: statusOtomatis.value == "Kering" ? Colors.red : Colors.green[700],
                    ),
                  ),
                )),

            DropdownButtonFormField<String>(
              isExpanded: true,
              decoration: _inputStyle("Fase Penanaman", Icons.history),
              value: selectedFase.value,
              items: ["Awal (0-4 bln)", "Pertumbuhan", "Kemasakan (3 bln sblm panen)"]
                  .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                  .toList(),
              onChanged: (val) => selectedFase.value = val!,
            ),
            const SizedBox(height: 16),

            TextField(
              controller: volCtrl,
              keyboardType: TextInputType.number,
              decoration: _inputStyle("Volume Air (Liter)", Icons.water_drop),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: durasiCtrl,
              keyboardType: TextInputType.number,
              decoration: _inputStyle("Durasi Penyiraman (Menit)", Icons.timer),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: catatanCtrl,
              maxLines: 2,
              decoration: _inputStyle("Catatan Tambahan", Icons.notes),
            ),
            
            const SizedBox(height: 32),

            UiHelper.buildButton(
              text: "Simpan Data Irigasi",
              color: const Color(0xFF1B5E20),
              icon: Icons.save,
              onPressed: () {
                final String? currentUid = authC.firebaseUser.value?.uid;

                if (selectedLahanId.value.isEmpty) {
                  Get.snackbar("Peringatan", "Pilih lahan terlebih dahulu");
                  return;
                }

                if (currentUid != null) {
                  final irigasi = IrigasiModel(
                    id: '',
                    uid: currentUid, // UID DISIMPAN
                    lahanId: selectedLahanId.value,
                    tanggal: DateTime.now(),
                    metode: 'Manual',
                    volumeAir: double.tryParse(volCtrl.text) ?? 0.0,
                    durasi: int.tryParse(durasiCtrl.text) ?? 0,
                    kelembabanTanah: double.tryParse(humidCtrl.text) ?? 0.0,
                    kondisiTanah: statusOtomatis.value,
                    faseTanam: selectedFase.value,
                    catatan: catatanCtrl.text,
                  );

                  irigasiC.addIrigasi(irigasi);
                  Get.back();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}