import 'package:absen01/logo.dart';
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

  final nameCtrl = TextEditingController();
  final luasCtrl = TextEditingController();
  final varietasCtrl = TextEditingController();
  final lokasiCtrl = TextEditingController();
  final sensorCtrl = TextEditingController();

  DateTime selectedDate = DateTime.now();
  String selectedJenisTanah = 'Lempung';
  String selectedStatus = 'Aktif';

  // Helper desain dengan garis border standar (tipis)
  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFF1B5E20)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade400), // Garis standar
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF1B5E20)),
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
            /// INPUT FIELD
            TextField(controller: nameCtrl, decoration: _inputStyle("Nama Lahan", Icons.landscape)),
            const SizedBox(height: 16),
            TextField(controller: lokasiCtrl, decoration: _inputStyle("Lokasi Lahan", Icons.location_on)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: TextField(controller: luasCtrl, keyboardType: TextInputType.number, decoration: _inputStyle("Luas (Ha)", Icons.square_foot))),
                const SizedBox(width: 10),
                Expanded(child: TextField(controller: varietasCtrl, decoration: _inputStyle("Varietas", Icons.eco))),
              ],
            ),
            const SizedBox(height: 16),
            
            /// JENIS TANAH
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
            
            /// ID SENSOR
            TextField(controller: sensorCtrl, decoration: _inputStyle("ID Sensor (Opsional)", Icons.developer_board)),
            const SizedBox(height: 16),
            
            /// TANGGAL TANAM
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
                        Text("${selectedDate.day} - ${selectedDate.month} - ${selectedDate.year}", 
                             style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Spacer(),
                    const Icon(Icons.edit, size: 20, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            /// TOMBOL SIMPAN INSTAN
            UiHelper.buildButton(
              text: "Simpan Lahan",
              color: const Color(0xFF1B5E20),
              icon: Icons.save,
              onPressed: () {
                // Buat Model
                final lahan = LahanModel(
                  id: '',
                  namaLahan: nameCtrl.text,
                  lokasi: lokasiCtrl.text,
                  luas: double.tryParse(luasCtrl.text) ?? 0.0,
                  varietas: varietasCtrl.text,
                  tanggalTanam: selectedDate,
                  status: selectedStatus,
                  jenisTanah: selectedJenisTanah,
                  idSensor: sensorCtrl.text.isEmpty ? null : sensorCtrl.text,
                );

                // Jalankan simpan di background (tanpa await)
                lahanC.addLahan(lahan);

                // Langsung kembali ke halaman sebelumnya
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}