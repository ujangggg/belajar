import 'package:absen01/logo.dart';
import 'package:absen01/widget/add_pupuk.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controller/pupuk_controller.dart';
import '../controller/lahan_controller.dart';

class PemupukanPage extends StatelessWidget {
  PemupukanPage({super.key});

  final PupukController pupukC = Get.find();
  final LahanController lahanC = Get.find();
  final RxString selectedLahanId = ''.obs;

  @override
  Widget build(BuildContext context) {
    return UiHelper.buildPageWrapper(
      context: context,
      title: "Riwayat Pemupukan",
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1B5E20),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => Get.to(() => AddPemupukan()),
      ),
      child: Column(
        children: [
          _buildLahanDropdown(),
          Expanded(
            child: Obx(() {
              if (selectedLahanId.value.isEmpty) {
                return const Center(child: Text("Silahkan pilih lahan terlebih dahulu"));
              }
              if (pupukC.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (pupukC.pupukList.isEmpty) {
                return const Center(child: Text("Belum ada data pemupukan di lahan ini"));
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: pupukC.pupukList.length,
                itemBuilder: (context, index) {
                  final data = pupukC.pupukList[index];
                  return _buildPupukCard(data);
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
              pupukC.fetchPupukByLahan(val);
            },
          )),
    );
  }

  Widget _buildPupukCard(data) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.shade100,
          child: const Icon(Icons.science, color: Color(0xFF1B5E20)),
        ),
        title: Text("${data.jenisPupuk} - ${data.jumlah} Kg", style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("Metode: ${data.metode}\nFase: ${data.faseTanam}\n${DateFormat('dd MMM yyyy').format(data.tanggal)}"),
        isThreeLine: true,
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () => _confirmDelete(data.id),
        ),
      ),
    );
  }

  void _confirmDelete(String id) {
    Get.defaultDialog(
      title: "Hapus Data",
      middleText: "Yakin ingin menghapus riwayat ini?",
      textConfirm: "Ya",
      textCancel: "Tidak",
      confirmTextColor: Colors.white,
      onConfirm: () {
        pupukC.deletePupuk(id);
        Get.back();
      },
    );
  }
}


