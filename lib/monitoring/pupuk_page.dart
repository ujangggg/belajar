import 'package:absen01/widget/add_pupuk.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Import intl untuk format tanggal

import '../controller/pupuk_controller.dart';
import '../controller/lahan_controller.dart';

class PemupukanPage extends StatelessWidget {
  PemupukanPage({super.key});

  final PupukController pupukC = Get.find();
  final LahanController lahanC = Get.find();

  final RxString selectedLahanId = ''.obs;

  final Color primaryGreen = const Color(0xFF1B5E20);
  final Color accentOrange = const Color(0xFFE65100);
  final Color bgLight = const Color(0xFFF9FBF9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      appBar: AppBar(
        title: const Text(
          "Riwayat Pemupukan",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryGreen,
        elevation: 2,
        icon: const Icon(Icons.science_rounded, color: Colors.white, size: 18),
        label: const Text(
          "Catat Pupuk",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        onPressed: () => Get.to(() => AddPemupukan()),
      ),
      body: Column(
        children: [
          _buildLahanDropdown(),
          _buildInfoTargetPupuk(),
          Expanded(
            child: Obx(() {
              if (selectedLahanId.value.isEmpty) {
                return _buildPlaceholder(
                  "Pilih Lahan",
                  "Pilih salah satu lahan untuk melihat riwayat pemupukan.",
                );
              }
              if (pupukC.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(color: primaryGreen),
                );
              }
              if (pupukC.pupukList.isEmpty) {
                return _buildEmptyState(
                  icon: Icons.science_outlined,
                  message: "Belum ada riwayat pemupukan\ndi lahan ini",
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                itemCount: pupukC.pupukList.length,
                itemBuilder:
                    (context, index) =>
                        _buildPupukCard(pupukC.pupukList[index]),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(String title, String subtitle) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.science_rounded,
              size: 40,
              color: primaryGreen.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLahanDropdown() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            decoration: const InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(Icons.location_on_outlined, size: 18),
            ),
            hint: const Text(
              "Pilih Lokasi Lahan",
              style: TextStyle(fontSize: 14),
            ),
            value: selectedLahanId.value.isEmpty ? null : selectedLahanId.value,
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
            onChanged: (val) {
              if (val == null) return;
              selectedLahanId.value = val;
              pupukC.fetchPupukByLahan(val);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPupukCard(dynamic data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryGreen.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.science_rounded, color: primaryGreen, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.jenisPupuk,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _buildChipInfo(Icons.auto_graph_rounded, data.faseTanam),
                    const SizedBox(width: 8),
                    _buildChipInfo(Icons.settings_outlined, data.metode),
                  ],
                ),
                Text(
                  DateFormat('dd MMM yyyy, HH:mm').format(data.tanggal),
                  style: TextStyle(color: Colors.grey[400], fontSize: 10),
                ),
              ],
            ),
          ),
          Text(
            "${data.jumlah} Kg",
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: accentOrange,
              fontSize: 14,
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: Icon(
              Icons.delete_outline_rounded,
              color: Colors.red[300],
              size: 18,
            ),
            onPressed: () => _confirmDelete(data.id),
          ),
        ],
      ),
    );
  }

  Widget _buildChipInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 12, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTargetPupuk() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.green.shade100),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: primaryGreen, size: 18),
              const SizedBox(width: 8),
              const Text(
                "Target Pemupukan",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
          const Divider(height: 20),
          _targetRow("Awal Tanam", "0-30 Hari", "1x", Colors.orange),
          const SizedBox(height: 8),
          _targetRow("Pertumbuhan", "31-120 Hari", "2x", Colors.blue),
          const SizedBox(height: 8),
          _targetRow("Kemasakan", "121-330 Hari", "1x", Colors.green),
        ],
      ),
    );
  }

  Widget _targetRow(String fase, String umur, String target, Color color) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            fase,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            umur,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            target,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState({required IconData icon, required String message}) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 50, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(String id) {
    Get.defaultDialog(
      title: "Hapus Data?",
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      middleText:
          "Data ini akan dihapus secara permanen dari riwayat. Apakah Anda yakin?",
      middleTextStyle: const TextStyle(fontSize: 14, color: Colors.grey),
      radius: 15,
      // Tombol Aksi
      textConfirm: "Hapus",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red[600], // Warna merah untuk aksi kritis
      cancelTextColor: Colors.grey[700],
      onConfirm: () {
        // Ganti dengan (pupukC.deletePupuk(id)) jika di file Pupuk
        pupukC.deletePupuk(id).then((_) => Get.back());
      },
      // Opsional: Jika ingin tombol batal berwarna hijau
      // cancel: OutlinedButton(onPressed: () => Get.back(), child: const Text("Batal")),
    );
  }
}
