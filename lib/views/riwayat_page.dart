import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controller/lahan_controller.dart';
import '../controller/riwayat_controller.dart';
import '../model/model_irigasi.dart';

class RiwayatPage extends StatelessWidget {
  RiwayatPage({super.key});

  final RiwayatController riwayatC = Get.put(RiwayatController());
  final LahanController lahanC = Get.find<LahanController>();

  static const Color primaryGreen = Color(0xFF1B4332);
  static const Color accentGreen = Color(0xFF40916C);
  static const Color bgGrey = Color(0xFFF8F9FA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGrey,
      appBar: AppBar(
        title: const Text(
          "Riwayat Aktivitas",
          style: TextStyle(
            color: primaryGreen,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: primaryGreen),
      ),
      body: Column(
        children: [
          _buildFilterLahan(),
          Expanded(
            child: GetBuilder<RiwayatController>(
              builder: (_) {
                if (riwayatC.selectedLahan.value == null) {
                  return _buildSelectLahanState();
                }
                if (riwayatC.semuaRiwayat.isEmpty) {
                  return _buildEmptyState();
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
                  itemCount: riwayatC.semuaRiwayat.length,
                  itemBuilder: (context, index) {
                    final data = riwayatC.semuaRiwayat[index];
                    return _buildRiwayatCard(data);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterLahan() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Obx(
        () => DropdownButtonFormField<dynamic>(
          isExpanded: true,
          menuMaxHeight: 300,
          value: riwayatC.selectedLahan.value,
          decoration: InputDecoration(
            labelText: "Pilih Lahan",
            filled: true,
            fillColor: bgGrey,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            prefixIcon: const Icon(Icons.agriculture, color: accentGreen),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
          items:
              lahanC.lahanList.map((lahan) {
                return DropdownMenuItem(
                  value: lahan,
                  // Cukup gunakan widget Text langsung, isExpanded: true di atas
                  // sudah otomatis menangani responsivitas lebar dropdown.
                  child: Text(
                    lahan.namaLahan,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      // Menambahkan baseline atau tinggi yang pas agar ekor huruf aman
                      height: 1.2,
                    ),
                  ),
                );
              }).toList(),
          onChanged: (value) => riwayatC.pilihLahan(value),
        ),
      ),
    );
  }

  Widget _buildRiwayatCard(dynamic data) {
    final bool isIrigasi = data is IrigasiModel;
    String namaLahan = "-";
    try {
      namaLahan =
          lahanC.lahanList.firstWhere((l) => l.id == data.lahanId).namaLahan;
    } catch (_) {}

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: (isIrigasi ? Colors.blue : Colors.green)
                          .withOpacity(.1),
                      child: Icon(
                        isIrigasi
                            ? Icons.water_drop_rounded
                            : Icons.science_rounded,
                        color:
                            isIrigasi
                                ? Colors.blue.shade700
                                : Colors.green.shade700,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isIrigasi ? "Irigasi" : "Pemupukan",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            namaLahan,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: (isIrigasi ? Colors.blue : Colors.green)
                            .withOpacity(.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        data.faseTanam,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color:
                              isIrigasi
                                  ? Colors.blue.shade700
                                  : Colors.green.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  children: [
                    _metric(
                      "Jumlah/Vol",
                      isIrigasi
                          ? "${data.volumeAir.toStringAsFixed(0)} L"
                          : "${data.jumlah.toStringAsFixed(0)} Kg",
                    ),
                    _metric(
                      isIrigasi ? "Kelembapan" : "Metode",
                      isIrigasi
                          ? "${data.kelembabanTanah.toStringAsFixed(0)}%"
                          : data.metode,
                    ),
                    _metric(
                      "Kondisi",
                      isIrigasi
                          ? data.kondisiTanah
                          : (data.kondisiTanah ?? "-"),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: bgGrey,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(18),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.schedule, size: 14, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  DateFormat('dd MMM yyyy • HH:mm').format(data.tanggal),
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _metric(String title, String value) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectLahanState() => Center(
    child: Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Lingkaran dekoratif di belakang ikon
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.agriculture_outlined,
              size: 70, // Sedikit diperkecil karena sudah dibantu Container
              color: accentGreen, // Menggunakan warna accentGreen Anda
            ),
          ),
          const SizedBox(height: 24),
          // Teks Utama lebih tegas
          const Text(
            "Pilih Lahan Terlebih Dahulu",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryGreen, // Menggunakan primaryGreen Anda
            ),
          ),
          const SizedBox(height: 8),
          // Sub-teks informatif
          Text(
            "Silakan tentukan lahan pada menu dropdown di atas untuk memuat riwayat aktivitas irigasi dan pemupukan.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade500,
              height: 1.4,
            ),
          ),
        ],
      ),
    ),
  );  

  Widget _buildEmptyState() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.history_toggle_off_rounded,
          size: 80,
          color: Colors.grey.shade300,
        ),
        const SizedBox(height: 16),
        Text(
          "Belum ada riwayat aktivitas",
          style: TextStyle(
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}
