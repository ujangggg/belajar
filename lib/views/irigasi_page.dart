import 'package:absen01/logo.dart';
import 'package:absen01/widget/add_irigasi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Untuk format tanggal
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
        backgroundColor: const Color(0xFF1B5E20), // Samakan hijau dengan tema
        child: const Icon(Icons.water_drop, color: Colors.white),
        onPressed: () {
          Get.to(() => AddIrigasi());
        },
      ),
      child: Column(
        children: [
          /// DROPDOWN PILIH LAHAN (Disamakan dengan PemupukanPage)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Obx(() {
              return DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.map, color: Color(0xFF1B5E20)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                ),
                hint: const Text("Pilih Lahan"),
                value:
                    selectedLahanId.value.isEmpty
                        ? null
                        : selectedLahanId.value,
                items:
                    lahanC.lahanList.map((l) {
                      return DropdownMenuItem(
                        value: l.id,
                        child: Text(l.namaLahan),
                      );
                    }).toList(),
                onChanged: (val) {
                  selectedLahanId.value = val!;
                  irigasiC.fetchIrigasiByLahan(val);
                },
              );
            }),
          ),

          /// LIST RIWAYAT IRIGASI
          Expanded(
            child: Obx(() {
              // Jika belum pilih lahan
              if (selectedLahanId.value.isEmpty) {
                return const Center(
                  child: Text("Silahkan pilih lahan terlebih dahulu"),
                );
              }

              // Jika sedang loading
              if (irigasiC.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              // Jika data kosong
              if (irigasiC.irigasiList.isEmpty) {
                return const Center(
                  child: Text("Belum ada data irigasi di lahan ini"),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: irigasiC.irigasiList.length,
                itemBuilder: (context, index) {
                  final irigasi = irigasiC.irigasiList[index];

                  // Format tanggal dari Firebase
                  String tgl = DateFormat(
                    'dd MMM yyyy, HH:mm',
                  ).format(irigasi.tanggal);

                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade50,
                        child: const Icon(
                          Icons.waves_rounded,
                          color: Colors.blue,
                        ),
                      ),
                      title: Text(
                        "${irigasi.volumeAir} Liter",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Durasi: ${irigasi.durasi} Menit"),
                          Text(
                            "Tanah: ${irigasi.kondisiTanah} (${irigasi.kelembabanTanah}%)",
                          ),
                          Text(
                            tgl,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        // Aksi saat item diklik jika diperlukan
                      },
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
