import 'package:absen01/auth/auth_controller.dart';
import 'package:absen01/model/model_pupuk.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/lahan_controller.dart';
import '../controller/pupuk_controller.dart';

class AddPemupukan extends StatefulWidget {
  const AddPemupukan({super.key});

  @override
  State<AddPemupukan> createState() => _AddPemupukanState();
}

class _AddPemupukanState extends State<AddPemupukan> {
  final PupukController pupukC = Get.find();
  final LahanController lahanC = Get.find();
  final AuthController authC = Get.find();

  final jumlahCtrl = TextEditingController();
  final catatanCtrl = TextEditingController();

  final RxString selectedLahanId = ''.obs;
  final RxString selectedJenis = 'Urea'.obs;
  final RxString selectedMetode = 'Tabur'.obs;
  final RxString selectedFase = 'Pertumbuhan'.obs;
  final RxString selectedKondisiTanah = 'Lembap'.obs;
  DateTime selectedDate = DateTime.now();

  final Color primaryGreen = const Color(0xFF1B5E20);

  @override
  void dispose() {
    jumlahCtrl.dispose();
    catatanCtrl.dispose();
    super.dispose();
  }

  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 13),
      prefixIcon: Icon(icon, color: primaryGreen, size: 20),
      filled: true,
      fillColor: Colors.white,
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }

  // --- LOGIKA SIMPAN DATA (SUDAH DIPERBAIKI) ---
  void _simpanData() async {
    final String? currentUid = authC.firebaseUser.value?.uid;

    if (currentUid == null) {
      Get.snackbar(
        "Gagal",
        "User belum login!",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (selectedLahanId.value.isEmpty) {
      Get.snackbar(
        "Peringatan",
        "Lahan wajib dipilih!",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (jumlahCtrl.text.isEmpty) {
      Get.snackbar(
        "Peringatan",
        "Jumlah pupuk (Kg) wajib diisi!",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      // 1. Tampilkan loading overlay
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1B5E20)),
          ),
        ),
        barrierDismissible: false,
      );

      final dataPupuk = PupukModel(
        id: '',
        uid: currentUid,
        lahanId: selectedLahanId.value,
        tanggal: selectedDate,
        jenisPupuk: selectedJenis.value,
        jumlah: double.tryParse(jumlahCtrl.text) ?? 0.0,
        metode: selectedMetode.value,
        faseTanam: selectedFase.value,
        catatan: catatanCtrl.text,
        kondisiTanah: selectedKondisiTanah.value,
      );

      // 2. WAJIB menggunakan await agar Flutter menunggu Firebase selesai memproses data
      await pupukC.addPupuk(dataPupuk);

      // 3. Tutup Loading Dialog
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      // 4. Kembali ke halaman utama (Pasti Berhasil)
      Get.back();

      // 5. Snack sukses
      Get.snackbar(
        "Berhasil",
        "Data pupuk berhasil disimpan",
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
      debugPrint("Error Firebase Pupuk: $e");
      Get.snackbar(
        "Gagal Menyimpan",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBF9),
      appBar: AppBar(
        title: const Text(
          "Catat Pemupukan",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pilih Lahan
            Obx(
              () => DropdownButtonFormField<String>(
                isExpanded: true,
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

            // Pilih Tanggal
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
                padding: const EdgeInsets.all(14),
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

            // Jenis Pupuk & Jumlah
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Obx(
                    () => DropdownButtonFormField<String>(
                      isExpanded: true,
                      decoration: _inputStyle("Jenis", Icons.science_outlined),
                      value: selectedJenis.value,
                      items:
                          ["Urea", "ZA", "NPK", "SP-36", "Organik"]
                              .map(
                                (j) => DropdownMenuItem(
                                  value: j,
                                  child: Text(
                                    j,
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged: (val) => selectedJenis.value = val!,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: jumlahCtrl,
                    keyboardType: TextInputType.number,
                    decoration: _inputStyle("Kg", Icons.scale_outlined),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Metode & Kondisi Tanah
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => DropdownButtonFormField<String>(
                      isExpanded: true,
                      decoration: _inputStyle(
                        "Metode",
                        Icons.handshake_outlined,
                      ),
                      value: selectedMetode.value,
                      items:
                          ["Tabur", "Kocor", "Benam"]
                              .map(
                                (m) => DropdownMenuItem(
                                  value: m,
                                  child: Text(
                                    m,
                                    style: const TextStyle(fontSize: 13),
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
                                    style: const TextStyle(fontSize: 13),
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

            // Fase Tanam
            Obx(
              () => DropdownButtonFormField<String>(
                isExpanded: true,
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

            // Catatan
            TextField(
              controller: catatanCtrl,
              maxLines: 2,
              decoration: _inputStyle("Catatan Tambahan", Icons.notes_outlined),
            ),
            const SizedBox(height: 32),

            // Tombol Simpan
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _simpanData, // Tinggal panggil fungsi terpisah
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Simpan Data Pemupukan",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
