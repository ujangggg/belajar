import 'package:absen01/model/model_irigasi.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// Pastikan file IrigasiModel sudah diimport jika dipisah filenya
// import 'package:your_project/models/irigasi_model.dart'; 

class AdminIrigasiPage extends StatefulWidget {
  const AdminIrigasiPage({super.key});

  @override
  State<AdminIrigasiPage> createState() => _AdminIrigasiPageState();
}

class _AdminIrigasiPageState extends State<AdminIrigasiPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Monitor Irigasi Air", 
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1B5E20),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Column(
        children: [
          // --- HEADER & SEARCH BAR ---
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFF1B5E20),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
              decoration: InputDecoration(
                hintText: "Cari metode atau fase tanam...",
                prefixIcon: const Icon(Icons.search, color: Color(0xFF1B5E20)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // --- SECTION RINGKASAN ANALITIK (STREAMEBUILDER 1) ---
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('irigasi').snapshots(),
            builder: (context, snapshot) {
              double totalVolume = 0;
              double rataKelembaban = 0;
              int jumlahData = 0;

              if (snapshot.hasData) {
                for (var doc in snapshot.data!.docs) {
                  var data = doc.data() as Map<String, dynamic>;
                  totalVolume += (data['volumeAir'] ?? 0).toDouble();
                  rataKelembaban += (data['kelembabanTanah'] ?? 0).toDouble();
                  jumlahData++;
                }
                if (jumlahData > 0) rataKelembaban /= jumlahData;
              }

              return Container(
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSummaryItem(Icons.waves, "${totalVolume.toStringAsFixed(1)} L", "Total Air", Colors.blue),
                    Container(width: 1, height: 40, color: Colors.grey[200]),
                    _buildSummaryItem(Icons.thermostat, "${rataKelembaban.toStringAsFixed(1)}%", "Rata Kelembaban", Colors.orange),
                    Container(width: 1, height: 40, color: Colors.grey[200]),
                    _buildSummaryItem(Icons.assignment_turned_in, "$jumlahData", "Aktivitas", Colors.green),
                  ],
                ),
              );
            },
          ),

          // --- LIST DATA AKTIVITAS (STREAMBUILDER 2) ---
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('irigasi').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("Belum ada aktivitas irigasi."));
                }

                // Filter & Mapping menggunakan Model
                var irigasiList = snapshot.data!.docs.map((doc) {
                  return IrigasiModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
                }).where((item) {
                  return item.metode.toLowerCase().contains(_searchQuery) || 
                         item.faseTanam.toLowerCase().contains(_searchQuery);
                }).toList();

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: irigasiList.length,
                  itemBuilder: (context, index) {
                    final irigasi = irigasiList[index];

                    // Mengambil Nama Lahan & Nama Pemilik
                    return FutureBuilder(
                      future: Future.wait([
                        FirebaseFirestore.instance.collection('lahan').doc(irigasi.lahanId).get(),
                        FirebaseFirestore.instance.collection('users').doc(irigasi.uid).get(),
                      ]),
                      builder: (context, AsyncSnapshot<List<DocumentSnapshot>> multiSnap) {
                        String namaLahan = "Memuat Lahan...";
                        String namaPemilik = "Petani";

                        if (multiSnap.hasData) {
                          var lahanDoc = multiSnap.data![0];
                          var userDoc = multiSnap.data![1];
                          if (lahanDoc.exists) namaLahan = lahanDoc['namaLahan'] ?? "Lahan";
                          if (userDoc.exists) namaPemilik = userDoc['name'] ?? "User";
                        }

                        return Card(
                          margin: const EdgeInsets.only(bottom: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          elevation: 3,
                          child: Column(
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: _getMoistureColor(irigasi.kelembabanTanah).withOpacity(0.2),
                                  child: Icon(Icons.water_drop, color: _getMoistureColor(irigasi.kelembabanTanah)),
                                ),
                                title: Text(namaLahan, style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text("Oleh: $namaPemilik • ${DateFormat('dd MMM, HH:mm').format(irigasi.tanggal)}"),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                                  onPressed: () => _confirmDelete(irigasi.id),
                                ),
                              ),
                              const Divider(height: 1),
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  alignment: WrapAlignment.spaceBetween,
                                  children: [
                                    _buildInfoItem(Icons.settings_suggest, irigasi.metode, "Metode"),
                                    _buildInfoItem(Icons.opacity, "${irigasi.volumeAir}L", "Volume"),
                                    _buildInfoItem(Icons.timer, "${irigasi.durasi}m", "Durasi"),
                                    _buildInfoItem(Icons.waves, "${irigasi.kelembabanTanah}%", irigasi.kondisiTanah),
                                    _buildInfoItem(Icons.trending_up, irigasi.faseTanam, "Fase"),
                                  ],
                                ),
                              ),
                              if (irigasi.catatan != null && irigasi.catatan!.isNotEmpty)
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                                  decoration: BoxDecoration(
                                    color: Colors.amber[50],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    "Catatan: ${irigasi.catatan}",
                                    style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildSummaryItem(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String value, String label) {
    return SizedBox(
      width: Get.width * 0.17, // Menyesuaikan agar pas 5 item
      child: Column(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF2E7D32)),
          const SizedBox(height: 4),
          Text(value, 
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11), 
              textAlign: TextAlign.center, 
              overflow: TextOverflow.ellipsis),
          Text(label, 
              style: const TextStyle(color: Colors.grey, fontSize: 9), 
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Color _getMoistureColor(double m) {
    if (m < 16) return Colors.red;
    if (m >= 70 && m <= 80) return Colors.blue;
    return Colors.orange;
  }

  void _confirmDelete(String id) {
    Get.defaultDialog(
      title: "Hapus Riwayat",
      middleText: "Hapus data aktivitas irigasi ini secara permanen?",
      textConfirm: "Hapus",
      textCancel: "Batal",
      buttonColor: Colors.red,
      confirmTextColor: Colors.white,
      onConfirm: () async {
        await FirebaseFirestore.instance.collection('irigasi').doc(id).delete();
        Get.back();
        Get.snackbar("Terhapus", "Data berhasil dibersihkan",
            backgroundColor: Colors.black87, colorText: Colors.white);
      },
    );
  }
}