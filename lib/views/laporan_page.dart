import 'package:absen01/logo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controller/irigasi_controller.dart';
import '../controller/pupuk_controller.dart';
import '../controller/lahan_controller.dart';

class LaporanPage extends StatelessWidget {
  LaporanPage({super.key});

  final LahanController lahanC = Get.find();
  final IrigasiController irigasiC = Get.find();
  final PupukController pupukC = Get.find();
  final RxString selectedLahanId = ''.obs;

  @override
  Widget build(BuildContext context) {
    return UiHelper.buildPageWrapper(
      context: context,
      title: "Laporan Aktivitas",
      child: Column(
        children: [
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
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                    labelColor: Color(0xFF1B5E20),
                    indicatorColor: Color(0xFF1B5E20),
                    tabs: [
                      Tab(text: "Irigasi", icon: Icon(Icons.water_drop)),
                      Tab(text: "Pupuk", icon: Icon(Icons.science)),
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

  Widget _buildListIrigasi() {
    return Obx(() {
      var list = irigasiC.irigasiList;
      if (selectedLahanId.value.isNotEmpty) {
        list = list.where((i) => i.lahanId == selectedLahanId.value).toList().obs;
      }
      if (list.isEmpty) return const Center(child: Text("Belum ada data irigasi"));

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final data = list[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(Icons.water_drop, color: Colors.blue),
              title: Text("${data.volumeAir} L | ${data.durasi} Menit"),
              subtitle: Text("${DateFormat('dd MMM yyyy').format(data.tanggal)}\nTanah: ${data.kondisiTanah}"),
              isThreeLine: true,
            ),
          );
        },
      );
    });
  }

  Widget _buildListPupuk() {
    return Obx(() {
      var list = pupukC.pupukList;
      if (selectedLahanId.value.isNotEmpty) {
        list = list.where((p) => p.lahanId == selectedLahanId.value).toList().obs;
      }
      if (list.isEmpty) return const Center(child: Text("Belum ada data pupuk"));

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final data = list[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(Icons.science, color: Colors.orange),
              title: Text("${data.jenisPupuk} - ${data.jumlah} Kg"),
              subtitle: Text("${DateFormat('dd MMM yyyy').format(data.tanggal)}\nFase: ${data.faseTanam}"),
              isThreeLine: true,
            ),
          );
        },
      );
    });
  }
}