import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:absen01/auth/auth_controller.dart';
import 'package:absen01/model/model_irigasi.dart';
import 'package:absen01/controller/lahan_controller.dart';
import 'package:absen01/controller/irigasi_controller.dart';

class AddIrigasi extends StatefulWidget {
  const AddIrigasi({super.key});

  @override
  State<AddIrigasi> createState() => _AddIrigasiState();
}

class _AddIrigasiState extends State<AddIrigasi> {
  final IrigasiController irigasiC = Get.find();
  final LahanController lahanC = Get.find();
  final AuthController authC = Get.find();

  final volCtrl = TextEditingController();
  final durasiCtrl = TextEditingController();
  final catatanCtrl = TextEditingController();

  final RxString selectedLahanId = ''.obs;
  final RxString selectedMetode = 'Manual'.obs;
  final RxString selectedCuaca = 'Cerah'.obs;
  final RxString selectedWaktu = 'Pagi'.obs;
  final RxString selectedFase = 'Pertumbuhan'.obs;
  final RxString selectedKondisiTanah = 'Lembap'.obs;
  final RxString selectedSatuan = 'Menit'.obs;
  DateTime selectedDate = DateTime.now();

  final Color primaryGreen = const Color(0xFF1B5E20);

  // Styling khusus agar dropdown tidak terpotong
  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 13, color: Colors.black54),
      prefixIcon: Icon(icon, color: primaryGreen, size: 20),
      filled: true,
      fillColor: Colors.white,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 14,
      ), // Dikecilkan agar pas
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryGreen, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBF9),
      appBar: AppBar(
        title: const Text(
          "Catat Irigasi",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Lahan
            Obx(
              () => DropdownButtonFormField<String>(
                isExpanded: true,
                menuMaxHeight: 300,
                decoration: _inputStyle("Pilih Lahan", Icons.map_outlined),
                value:
                    selectedLahanId.value.isEmpty
                        ? null
                        : selectedLahanId.value,
                items:
                    lahanC.lahanList
                        .map(
                          (l) => DropdownMenuItem(
                            value: l.id,
                            child: Text(
                              l.namaLahan,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        )
                        .toList(),
                onChanged: (val) => selectedLahanId.value = val!,
              ),
            ),
            const SizedBox(height: 16),

            // Tanggal
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2101),
                );
                if (picked != null) setState(() => selectedDate = picked);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      color: primaryGreen,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Tanggal: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                      style: const TextStyle(fontSize: 14),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.edit_outlined,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Cuaca & Waktu
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => DropdownButtonFormField<String>(
                      isExpanded: true,
                      menuMaxHeight: 300,
                      decoration: _inputStyle("Cuaca", Icons.wb_sunny_outlined),
                      value: selectedCuaca.value,
                      items:
                          ["Cerah", "Mendung", "Hujan"]
                              .map(
                                (c) => DropdownMenuItem(
                                  value: c,
                                  child: Text(
                                    c,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged: (val) {
                        selectedCuaca.value = val!;
                        if (val == 'Hujan') {
                          volCtrl.text = "0";
                          durasiCtrl.text = "0";
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Obx(
                    () => DropdownButtonFormField<String>(
                      isExpanded: true,
                      menuMaxHeight: 300,
                      decoration: _inputStyle("Waktu", Icons.access_time),
                      value: selectedWaktu.value,
                      items:
                          ["Pagi", "Siang", "Sore"]
                              .map(
                                (w) => DropdownMenuItem(
                                  value: w,
                                  child: Text(
                                    w,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged: (val) => selectedWaktu.value = val!,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Volume & Durasi
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: volCtrl,
                      enabled: selectedCuaca.value != 'Hujan',
                      keyboardType: TextInputType.number,
                      decoration: _inputStyle(
                        "Volume (L)",
                        Icons.water_drop_outlined,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: durasiCtrl,
                      enabled: selectedCuaca.value != 'Hujan',
                      keyboardType: TextInputType.number,
                      decoration: _inputStyle(
                        "Durasi",
                        Icons.timer_outlined,
                      ).copyWith(
                        suffix: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedSatuan.value,
                            items:
                                ['Menit', 'Jam']
                                    .map(
                                      (s) => DropdownMenuItem(
                                        value: s,
                                        child: Text(
                                          s,
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      ),
                                    )
                                    .toList(),
                            onChanged:
                                selectedCuaca.value == 'Hujan'
                                    ? null
                                    : (v) => selectedSatuan.value = v!,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Metode & Kondisi
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => DropdownButtonFormField<String>(
                      isExpanded: true,
                      menuMaxHeight: 300,
                      decoration: _inputStyle(
                        "Metode",
                        Icons.handshake_outlined,
                      ),
                      value: selectedMetode.value,
                      items:
                          ["Manual", "Otomatis", "Drop"]
                              .map(
                                (m) => DropdownMenuItem(
                                  value: m,
                                  child: Text(
                                    m,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged: (val) => selectedMetode.value = val!,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Obx(
                    () => DropdownButtonFormField<String>(
                      isExpanded: true,
                      menuMaxHeight: 300,
                      decoration: _inputStyle(
                        "Kondisi",
                        Icons.terrain_outlined,
                      ),
                      value: selectedKondisiTanah.value,
                      items:
                          ["Kering", "Lembap", "Becek"]
                              .map(
                                (k) => DropdownMenuItem(
                                  value: k,
                                  child: Text(
                                    k,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged: (val) => selectedKondisiTanah.value = val!,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Fase & Catatan
            Obx(
              () => DropdownButtonFormField<String>(
                isExpanded: true,
                menuMaxHeight: 300,
                decoration: _inputStyle(
                  "Fase Tanam",
                  Icons.psychology_outlined,
                ),
                value: selectedFase.value,
                items:
                    ["Awal", "Pertumbuhan", "Kemasakan"]
                        .map(
                          (f) => DropdownMenuItem(
                            value: f,
                            child: Text(
                              f,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        )
                        .toList(),
                onChanged: (val) => selectedFase.value = val!,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: catatanCtrl,
              maxLines: 2,
              decoration: _inputStyle("Catatan", Icons.notes_outlined),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _prosesSimpan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(
                    0xFF1B5E20,
                  ), // Warna hijau (sesuai primaryGreen)
                  foregroundColor: Colors.white, // Warna teks putih
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      12,
                    ), // Opsional: agar sudut membulat
                  ),
                ),
                child: const Text(
                  "Simpan Data",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Di dalam class _AddIrigasiState, tambahkan fungsi ini:
  void _prosesSimpan() async {
    if (selectedLahanId.value.isEmpty) {
      Get.snackbar("Error", "Pilih lahan terlebih dahulu");
      return;
    }

    try {
      // 1. Buat object model
      final data = IrigasiModel(
        id: '', // Firestore akan membuat ID otomatis
        uid: authC.firebaseUser.value!.uid,
        lahanId: selectedLahanId.value,
        tanggal: selectedDate,
        metode: selectedMetode.value,
        volumeAir: double.tryParse(volCtrl.text) ?? 0.0,
        durasi: int.tryParse(durasiCtrl.text) ?? 0,
        kondisiTanah: selectedKondisiTanah.value,
        faseTanam: selectedFase.value,
        catatan: catatanCtrl.text,
        cuaca: selectedCuaca.value,
        waktu: selectedWaktu.value,
        // kelembabanTanah: 0.0, // Opsional jika sudah ada default di model
      );

      // 2. Panggil fungsi di controller
      await irigasiC.addIrigasi(data);

      Get.back(); // Kembali ke halaman sebelumnya
      Get.snackbar(
        "Berhasil",
        "Data irigasi berhasil disimpan",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white,
        colorText: Colors.black87,
        borderRadius: 12,
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        boxShadows: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
        icon: const Icon(Icons.check_circle, color: Colors.green),
        duration: const Duration(seconds: 2),
        isDismissible: true,
        forwardAnimationCurve: Curves.easeOutBack,
      );
    } catch (e) {
      // Jika error, tutup loading dialog agar aplikasi tidak freeze
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      debugPrint("Error Firebase Irigasi: $e");
      Get.snackbar(
        "Gagal Menyimpan",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
      );
    }
  }
}
