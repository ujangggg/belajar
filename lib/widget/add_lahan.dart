import 'package:absen01/logo.dart';
import 'package:absen01/model/model_lahan.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/lahan_controller.dart';

class AddLahan extends StatefulWidget { // Ubah ke StatefulWidget untuk kelola state tanggal
  AddLahan({super.key});

  @override
  State<AddLahan> createState() => _AddLahanState();
}

class _AddLahanState extends State<AddLahan> {
  final LahanController lahanC = Get.find();

  final nameCtrl = TextEditingController();
  final luasCtrl = TextEditingController();
  final varietasCtrl = TextEditingController();
  final lokasiCtrl = TextEditingController();
  final statusCtrl = TextEditingController(text: "Aktif"); // Default value
  
  DateTime selectedDate = DateTime.now();

  // Fungsi untuk memunculkan kalender
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return UiHelper.buildPageWrapper(
      context: context,
      title: "Daftar Lahan Baru",
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            UiHelper.buildInput(icon: Icons.landscape, hint: "Nama Lahan", ctrl: nameCtrl),
            UiHelper.buildInput(icon: Icons.location_on, hint: "Lokasi Lahan", ctrl: lokasiCtrl),
            UiHelper.buildInput(icon: Icons.square_foot, hint: "Luas (Hektar)", ctrl: luasCtrl, isNumber: true),
            UiHelper.buildInput(icon: Icons.eco, hint: "Varietas Tebu", ctrl: varietasCtrl),
            
            // Input Status
            UiHelper.buildInput(icon: Icons.info_outline, hint: "Status (Contoh: Aktif/Selesai)", ctrl: statusCtrl),

            // Input Tanggal Tanam
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today, color: Colors.green),
              title: Text("Tanggal Tanam: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"),
              trailing: const Icon(Icons.edit),
              onTap: () => _selectDate(context),
            ),

            const SizedBox(height: 20),
            UiHelper.buildButton(
              text: "Simpan Lahan",
              icon: Icons.save,
              onPressed: () async {
                // Validasi sederhana agar tidak crash saat parse double
                if (nameCtrl.text.isEmpty || luasCtrl.text.isEmpty) {
                  Get.snackbar("Peringatan", "Nama dan Luas harus diisi");
                  return;
                }

                final lahan = LahanModel(
                  id: '',
                  namaLahan: nameCtrl.text,
                  lokasi: lokasiCtrl.text,
                  luas: double.tryParse(luasCtrl.text) ?? 0.0,
                  varietas: varietasCtrl.text,
                  tanggalTanam: selectedDate, // Menggunakan tanggal yang dipilih
                  status: statusCtrl.text,    // Menggunakan status dari input
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