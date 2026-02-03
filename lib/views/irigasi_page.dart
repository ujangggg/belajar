import 'package:absen01/logo.dart';
import 'package:absen01/widget/add_irigasi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
        backgroundColor: const Color(0xFF1B5E20),
        child: const Icon(Icons.water_drop, color: Colors.white),
        onPressed: () => Get.to(() => AddIrigasi()),
      ),
      child: Column(
        children: [
          _buildLahanDropdown(),
          Expanded(
            child: Obx(() {
              if (selectedLahanId.value.isEmpty) {
                return const Center(child: Text("Silahkan pilih lahan terlebih dahulu"));
              }
              if (irigasiC.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (irigasiC.irigasiList.isEmpty) {
                return const Center(child: Text("Belum ada data irigasi di lahan ini"));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: irigasiC.irigasiList.length,
                itemBuilder: (context, index) {
                  final irigasi = irigasiC.irigasiList[index];
                  return _buildIrigasiCard(irigasi);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildLahanDropdown() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Obx(() => DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: "Pilih Lahan",
              prefixIcon: const Icon(Icons.map, color: Color(0xFF1B5E20)),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            value: selectedLahanId.value.isEmpty ? null : selectedLahanId.value,
            items: lahanC.lahanList.map((l) => DropdownMenuItem(value: l.id, child: Text(l.namaLahan))).toList(),
            onChanged: (val) {
              selectedLahanId.value = val!;
              irigasiC.fetchIrigasiByLahan(val);
            },
          )),
    );
  }

  Widget _buildIrigasiCard(irigasi) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade50,
          child: const Icon(Icons.waves_rounded, color: Colors.blue),
        ),
        title: Text("${irigasi.volumeAir} Liter", style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("Durasi: ${irigasi.durasi} Menit\nTanah: ${irigasi.kondisiTanah} (${irigasi.kelembabanTanah}%)\n${DateFormat('dd MMM, HH:mm').format(irigasi.tanggal)}"),
        isThreeLine: true,
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () => _confirmDelete(irigasi.id),
        ),
      ),
    );
  }

  void _confirmDelete(String id) {
    Get.defaultDialog(
      title: "Hapus Data",
      middleText: "Hapus riwayat irigasi ini?",
      textConfirm: "Ya",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      onConfirm: () {
        irigasiC.deleteIrigasi(id);
        Get.back();
      },
    );
  }
}