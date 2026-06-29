import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/analisis_controller.dart';
import '../controller/lahan_controller.dart';

class AnalisisPage extends StatelessWidget {
  AnalisisPage({super.key});

  final AnalisisController analisisC = Get.put(AnalisisController());
  final LahanController lahanC = Get.find<LahanController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F6),
      appBar: AppBar(
        title: const Text(
          "Analisis Tebu",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: Column(
        children: [
          // ================= DROPDOWN =================
          Container(
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(.03), blurRadius: 8),
              ],
            ),
            child: Obx(
              () => DropdownButtonFormField<dynamic>(
                value: analisisC.selectedLahan.value,
                isExpanded: true,
                alignment: Alignment.centerLeft,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.agriculture),
                  hintText: "Pilih Lahan",
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 14,
                  ),
                ),
                items:
                    lahanC.lahanList.map((lahan) {
                      return DropdownMenuItem(
                        value: lahan,
                        child: SizedBox(
                          // Kita batasi lebar agar tidak melampaui layar
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Text(
                            lahan.namaLahan,
                            overflow:
                                TextOverflow
                                    .ellipsis, // Menambahkan titik-titik jika teks terlalu panjang
                            maxLines: 1, // Memastikan teks tidak turun ke bawah
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      );
                    }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    analisisC.pilihLahan(value);
                  }
                },
              ),
            ),
          ),

          Expanded(
            child: GetBuilder<AnalisisController>(
              builder: (controller) {
                final lahan = controller.selectedLahan.value;

                if (lahan == null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.agriculture_outlined,
                          size: 70,
                          color: Colors.green.shade200,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Pilih Lahan Terlebih Dahulu",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Analisis tanaman akan tampil di sini",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  );
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  child: Column(
                    children: [
                      // ================= HEADER =================
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF2E7D32), Color(0xFF43A047)],
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 24,
                                  backgroundColor: Colors.white24,
                                  child: Icon(Icons.eco, color: Colors.white),
                                ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        lahan.namaLahan,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),

                                      const SizedBox(height: 2),

                                      Text(
                                        controller.faseTanaman,
                                        style: const TextStyle(
                                          color: Colors.white70,
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
                                    color: Colors.white24,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    "${controller.skorKesehatan}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            LinearProgressIndicator(
                              value: controller.skorKesehatan / 100,
                              minHeight: 8,
                              borderRadius: BorderRadius.circular(20),
                              backgroundColor: Colors.white24,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  controller.statusKesehatan,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                Text(
                                  "${(controller.progressPanen * 100).toStringAsFixed(1)}% Panen",
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      // ================= GRID =================
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: 1.65,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        children: [
                          _statCard(
                            "Umur",
                            "${controller.umurTanaman} Hari",
                            Icons.schedule,
                            Colors.blue,
                          ),

                          _statCard(
                            "Sisa Panen",
                            "${controller.sisaHariPanen} Hari",
                            Icons.flag,
                            Colors.red,
                          ),

                          _statCard(
                            "Irigasi",
                            "${controller.totalIrigasi}/${controller.targetIrigasi}",
                            Icons.water_drop,
                            Colors.lightBlue,
                          ),

                          _statCard(
                            "Pemupukan",
                            "${controller.totalPemupukan}/${controller.targetPemupukan}",
                            Icons.spa,
                            Colors.orange,
                          ),

                          _statCard(
                            "Total Air",
                            "${controller.totalAir.toStringAsFixed(0)} L",
                            Icons.opacity,
                            Colors.cyan,
                          ),

                          _statCard(
                            "Total Pupuk",
                            "${controller.totalPupuk.toStringAsFixed(0)} Kg",
                            Icons.inventory_2,
                            Colors.deepOrange,
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // ================= ANALISIS =================
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.03),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.analytics_outlined,
                                  size: 18,
                                  color: Color(0xFF2E7D32),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Analisis Tanaman",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            _detailRow(
                              "Target Irigasi",
                              "${controller.targetIrigasi} Kali",
                            ),

                            _detailRow(
                              "Capaian Irigasi",
                              "${controller.capaianIrigasi.toStringAsFixed(0)}%",
                            ),

                            const Divider(),

                            _detailRow(
                              "Target Pemupukan",
                              "${controller.targetPemupukan} Kali",
                            ),

                            _detailRow(
                              "Capaian Pemupukan",
                              "${controller.capaianPemupukan.toStringAsFixed(0)}%",
                            ),

                            const Divider(),

                            _detailRow(
                              "Rata-rata Air",
                              "${controller.rataAir.toStringAsFixed(0)} Liter",
                            ),

                            _detailRow("Status", controller.statusKesehatan),

                            const Divider(),

                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4F8F4),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.lightbulb_outline,
                                    color: Color(0xFF2E7D32),
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      controller.rekomendasi,
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 13,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.03), blurRadius: 6),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color.withOpacity(.12),
            child: Icon(icon, size: 18, color: color),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),

                const SizedBox(height: 2),

                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
