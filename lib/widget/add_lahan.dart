import 'package:absen01/auth/auth_controller.dart';
import 'package:absen01/logo.dart'; // Asumsi ini file UI Helper kamu
import 'package:absen01/model/model_lahan.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/lahan_controller.dart';

class AddLahan extends StatefulWidget {
  const AddLahan({super.key});

  @override
  State<AddLahan> createState() => _AddLahanState();
}

class _AddLahanState extends State<AddLahan> {
  final LahanController lahanC = Get.find();
  final AuthController authC = Get.find(); // Tambahkan akses ke AuthController

  final nameCtrl = TextEditingController();
  final luasCtrl = TextEditingController();
  final varietasCtrl = TextEditingController();
  final lokasiCtrl = TextEditingController();
  final sensorCtrl = TextEditingController();

  DateTime selectedDate = DateTime.now();
  String selectedJenisTanah = 'Lempung';
  String selectedStatus = 'Aktif';

  // Desain input field
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF1B5E20)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return UiHelper.buildPageWrapper(
      context: context,
      title: "Tambah Lahan Baru",
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Informasi Lahan",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            TextField(controller: nameCtrl, decoration: _inputStyle("Nama Lahan", Icons.landscape)),
            const SizedBox(height: 16),
            
            TextField(controller: lokasiCtrl, decoration: _inputStyle("Lokasi Lahan", Icons.location_on)),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: luasCtrl, 
                    keyboardType: TextInputType.number, 
                    decoration: _inputStyle("Luas (Ha)", Icons.square_foot),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: varietasCtrl, 
                    decoration: _inputStyle("Varietas", Icons.eco),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            DropdownButtonFormField<String>(
              isExpanded: true,
              decoration: _inputStyle("Jenis Tanah", Icons.layers),
              value: selectedJenisTanah,
              items: ["Lempung", "Pasir", "Tanah Hitam/Humus", "Liat"]
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (val) => setState(() => selectedJenisTanah = val!),
            ),
            const SizedBox(height: 16),
            
            TextField(
              controller: sensorCtrl, 
              decoration: _inputStyle("ID Sensor (Opsional)", Icons.developer_board),
            ),
            const SizedBox(height: 16),
            
            InkWell(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_month, color: Color(0xFF1B5E20)),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Tanggal Tanam", style: TextStyle(fontSize: 12, color: Colors.grey)),
                        Text(
                          "${selectedDate.day} - ${selectedDate.month} - ${selectedDate.year}", 
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Icon(Icons.edit, size: 20, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // TOMBOL SIMPAN
            UiHelper.buildButton(
              text: "Simpan Lahan",
              color: const Color(0xFF1B5E20),
              icon: Icons.save,
              onPressed: () {
                // VALIDASI SEDERHANA
                if (nameCtrl.text.isEmpty || lokasiCtrl.text.isEmpty) {
                  Get.snackbar("Peringatan", "Nama dan Lokasi wajib diisi",
                      backgroundColor: Colors.orange, colorText: Colors.white);
                  return;
                }

                // AMBIL UID DARI AUTH CONTROLLER
                final String? currentUid = authC.firebaseUser.value?.uid;

                if (currentUid != null) {
                  // BUAT MODEL DENGAN UID USER
                  final lahan = LahanModel(
                    id: '', // Diisi otomatis oleh Firestore add()
                    uid: currentUid, // ID pemilik data
                    namaLahan: nameCtrl.text,
                    lokasi: lokasiCtrl.text,
                    luas: double.tryParse(luasCtrl.text) ?? 0.0,
                    varietas: varietasCtrl.text,
                    tanggalTanam: selectedDate,
                    status: selectedStatus,
                    jenisTanah: selectedJenisTanah,
                    idSensor: sensorCtrl.text.isEmpty ? null : sensorCtrl.text,
                  );

                  // JALANKAN PROSES SIMPAN
                  lahanC.addLahan(lahan);

                  // KEMBALI KE HALAMAN SEBELUMNYA
                  Get.back();
                } else {
                  Get.snackbar("Error", "Sesi login tidak ditemukan",
                      backgroundColor: Colors.red, colorText: Colors.white);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}