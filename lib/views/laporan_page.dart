import 'package:absen01/logo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controller/irigasi_controller.dart';
import '../controller/pupuk_controller.dart';
import '../controller/lahan_controller.dart';

class LaporanPage extends StatelessWidget {
  LaporanPage({super.key});

  // Memanggil controller yang sudah ada
  final LahanController lahanC = Get.find();
  final IrigasiController irigasiC = Get.find();
  final PupukController pupukC = Get.find();

  // Rx variable untuk filter lokal di halaman ini
  final RxString selectedLahanId = ''.obs;

  @override
  Widget build(BuildContext context) {
    // Menggunakan UI Helper wrapper seperti halaman lainnya
    return UiHelper.buildPageWrapper(
      context: context,
      title: "Laporan Aktivitas",
      child: Column(
        children: [
          /// SECTION 1: FILTER (Dropdown)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() => DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Filter Berdasarkan Lahan",
                    prefixIcon: const Icon(Icons.filter_alt, color: Color(0xFF1B5E20)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  value: selectedLahanId.value.isEmpty ? null : selectedLahanId.value,
                  items: [
                    const DropdownMenuItem(value: '', child: Text("Semua Lahan")),
                    ...lahanC.lahanList.map((l) => DropdownMenuItem(
                          value: l.id,
                          child: Text(l.namaLahan),
                        )),
                  ],
                  onChanged: (val) => selectedLahanId.value = val ?? '',
                )),
          ),

          /// SECTION 2: TAB KHUSUS (DefaultTabController ditaruh di dalam child)
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                    labelColor: Color(0xFF1B5E20),
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Color(0xFF1B5E20),
                    tabs: [
                      Tab(text: "Riwayat Irigasi", icon: Icon(Icons.water_drop_rounded)),
                      Tab(text: "Riwayat Pupuk", icon: Icon(Icons.science_rounded)),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildListIrigasi(),
                        _buildListPupuk(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// LIST DATA IRIGASI
  Widget _buildListIrigasi() {
    return Obx(() {
      // Filter data berdasarkan lahan yang dipilih
      var list = irigasiC.irigasiList;
      if (selectedLahanId.value.isNotEmpty) {
        list = list.where((i) => i.lahanId == selectedLahanId.value).toList().obs;
      }

      if (list.isEmpty) return const Center(child: Text("Data irigasi tidak ditemukan"));

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final data = list[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: const Icon(Icons.water_drop, color: Colors.blue),
              title: Text("${data.volumeAir} Liter"),
              subtitle: Text(DateFormat('dd MMM yyyy').format(data.tanggal)),
              trailing: const Icon(Icons.chevron_right),
            ),
          );
        },
      );
    });
  }

  /// LIST DATA PUPUK
  Widget _buildListPupuk() {
    return Obx(() {
      // Filter data berdasarkan lahan yang dipilih
      var list = pupukC.pupukList;
      if (selectedLahanId.value.isNotEmpty) {
        list = list.where((p) => p.lahanId == selectedLahanId.value).toList().obs;
      }

      if (list.isEmpty) return const Center(child: Text("Data pemupukan tidak ditemukan"));

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final data = list[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: const Icon(Icons.science, color: Colors.orange),
              title: Text("${data.jenisPupuk} - ${data.jumlah} Kg"),
              subtitle: Text(DateFormat('dd MMM yyyy').format(data.tanggal)),
              trailing: const Icon(Icons.chevron_right),
            ),
          );
        },
      );
    });
  }
}