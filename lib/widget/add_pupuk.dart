import 'package:absen01/logo.dart';
import 'package:absen01/model/model_pupuk.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/lahan_controller.dart';
import '../controller/pupuk_controller.dart';

class AddPemupukan extends StatelessWidget {
  AddPemupukan({super.key});

  final PupukController pupukC = Get.find();
  final LahanController lahanC = Get.find();

  final jumlahCtrl = TextEditingController();
  final catatanCtrl = TextEditingController();

  // 1. Pastikan Nilai Awal ini SAMA PERSIS dengan salah satu item di list bawah
  final RxString selectedLahanId = ''.obs;
  final RxString selectedJenisPupuk = 'Urea'.obs;
  final RxString selectedMetode = 'Tabur'.obs;
  final RxString selectedFase = 'Pertumbuhan'.obs; 

  // Helper Dekorasi Input (Border Standar/Tipis)
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
        borderSide: const BorderSide(color: Color(0xFF1B5E20)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return UiHelper.buildPageWrapper(
      context: context,
      title: "Catat Pemupukan",
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 1. PILIH LAHAN
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

            /// 2. JENIS PUPUK
            DropdownButtonFormField<String>(
              isExpanded: true,
              decoration: _inputStyle("Jenis Pupuk", Icons.science),
              value: selectedJenisPupuk.value,
              items: ["Urea", "ZA", "NPK", "SP-36", "Organik/Kompos"]
                  .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                  .toList(),
              onChanged: (val) => selectedJenisPupuk.value = val!,
            ),
            const SizedBox(height: 16),

            /// 3. DOSIS / JUMLAH
            TextField(
              controller: jumlahCtrl,
              keyboardType: TextInputType.number,
              decoration: _inputStyle("Jumlah Pupuk (Kg)", Icons.scale),
            ),
            const SizedBox(height: 16),

            /// 4. METODE APLIKASI
            DropdownButtonFormField<String>(
              isExpanded: true,
              decoration: _inputStyle("Metode Aplikasi", Icons.format_color_fill),
              value: selectedMetode.value,
              items: ["Tabur", "Kocor (Cair)", "Benam (Tanam)"]
                  .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                  .toList(),
              onChanged: (val) => selectedMetode.value = val!,
            ),
            const SizedBox(height: 16),

            /// 5. FASE TANAM (DI SINI MASALAHNYA TADI)
            DropdownButtonFormField<String>(
              isExpanded: true,
              decoration: _inputStyle("Fase Saat Ini", Icons.psychology),
              value: selectedFase.value,
              // List ini sekarang SAMA PERSIS dengan nilai default di atas
              items: ["Awal", "Pertumbuhan", "Kemasakan"]
                  .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                  .toList(),
              onChanged: (val) => selectedFase.value = val!,
            ),
            const SizedBox(height: 16),

            /// 6. CATATAN
            TextField(
              controller: catatanCtrl,
              maxLines: 2,
              decoration: _inputStyle("Catatan (Misal: Merk Pupuk)", Icons.notes),
            ),
            
            const SizedBox(height: 32),

            /// TOMBOL SIMPAN INSTAN
            UiHelper.buildButton(
              text: "Simpan Data Pupuk",
              color: const Color(0xFF1B5E20),
              icon: Icons.check_circle,
              onPressed: () {
                final pupuk = PupukModel(
                  id: '',
                  lahanId: selectedLahanId.value,
                  tanggal: DateTime.now(),
                  jenisPupuk: selectedJenisPupuk.value,
                  jumlah: double.tryParse(jumlahCtrl.text) ?? 0.0,
                  metode: selectedMetode.value,
                  faseTanam: selectedFase.value,
                  catatan: catatanCtrl.text,
                );

                pupukC.addPupuk(pupuk);
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}