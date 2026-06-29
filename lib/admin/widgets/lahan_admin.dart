import 'package:absen01/model/model_lahan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Tambahkan intl di pubspec.yaml untuk format tanggal
// import 'lahan_model.dart'; // Pastikan path model kamu benar

class AdminLahanPage extends StatefulWidget {
  const AdminLahanPage({super.key});

  @override
  State<AdminLahanPage> createState() => _AdminLahanPageState();
}

class _AdminLahanPageState extends State<AdminLahanPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Monitor Lahan Terintegrasi",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
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
              onChanged:
                  (value) => setState(() => _searchQuery = value.toLowerCase()),
              decoration: InputDecoration(
                hintText: "Cari nama lahan atau varietas...",
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

          // --- LIST DATA LAHAN ---
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('lahan').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("Belum ada data lahan masuk."),
                  );
                }

                // Konversi Firestore Doc ke LahanModel & Filter
                var lahanList =
                    snapshot.data!.docs
                        .map((doc) {
                          return LahanModel.fromMap(
                            doc.id,
                            doc.data() as Map<String, dynamic>,
                          );
                        })
                        .where((lahan) {
                          return lahan.namaLahan.toLowerCase().contains(
                                _searchQuery,
                              ) ||
                              lahan.varietas.toLowerCase().contains(
                                _searchQuery,
                              );
                        })
                        .toList();

                return ListView.builder(
                  padding: const EdgeInsets.all(15),
                  itemCount: lahanList.length,
                  itemBuilder: (context, index) {
                    final lahan = lahanList[index];

                    return FutureBuilder<DocumentSnapshot>(
                      future:
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(lahan.uid)
                              .get(),
                      builder: (context, userSnap) {
                        String ownerName = "Petani";
                        String ownerEmail = "...";

                        if (userSnap.hasData && userSnap.data!.exists) {
                          var uData =
                              userSnap.data!.data() as Map<String, dynamic>;
                          ownerName = uData['name'] ?? "Petani";
                          ownerEmail = uData['email'] ?? "-";
                        }

                        return Card(
                          margin: const EdgeInsets.only(bottom: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 5,
                          child: Column(
                            children: [
                              // Bagian Atas: Info Utama
                              ListTile(
                                contentPadding: const EdgeInsets.all(15),
                                leading: CircleAvatar(
                                  backgroundColor: _getStatusColor(
                                    lahan.status,
                                  ).withOpacity(0.2),
                                  child: Icon(
                                    Icons.eco,
                                    color: _getStatusColor(lahan.status),
                                  ),
                                ),
                                title: Text(
                                  lahan.namaLahan,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                subtitle: Text(
                                  "Pemilik: $ownerName ($ownerEmail)",
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete_sweep,
                                    color: Colors.red,
                                  ),
                                  onPressed:
                                      () => _konfirmasiHapus(
                                        lahan.id,
                                        lahan.namaLahan,
                                      ),
                                ),
                              ),
                              const Divider(height: 1),

                              // Bagian Tengah: Detail Model (Grid)
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Wrap(
                                  spacing: 20,
                                  runSpacing: 15,
                                  alignment: WrapAlignment.spaceBetween,
                                  children: [
                                    _buildInfoItem(
                                      Icons.square_foot,
                                      "${lahan.luas} m²",
                                      "Luas",
                                    ),
                                    _buildInfoItem(
                                      Icons.category,
                                      lahan.varietas,
                                      "Varietas",
                                    ),
                                    _buildInfoItem(
                                      Icons.layers,
                                      lahan.jenisTanah,
                                      "Tanah",
                                    ),
                                    _buildInfoItem(
                                      Icons.calendar_today,
                                      DateFormat(
                                        'dd MMM yyyy',
                                      ).format(lahan.tanggalTanam),
                                      "Tanam",
                                    ),
                                    _buildInfoItem(
                                      Icons.sensors,
                                      lahan.idSensor ?? "-",
                                      "ID Sensor",
                                    ),
                                    _buildInfoItem(
                                      Icons.info_outline,
                                      lahan.status.toUpperCase(),
                                      "Status",
                                    ),
                                  ],
                                ),
                              ),

                              // Tombol Aksi Cepat
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.green[50],
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                ),
                                child: TextButton.icon(
                                  onPressed:
                                      () => _showLocationDialog(lahan.lokasi),
                                  icon: const Icon(
                                    Icons.location_on,
                                    color: Colors.green,
                                  ),
                                  label: const Text(
                                    "Lihat Lokasi Lahan",
                                    style: TextStyle(color: Colors.green),
                                  ),
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

  Widget _buildInfoItem(IconData icon, String value, String label) {
    return SizedBox(
      width: Get.width * 0.25, // Agar pas 3 kolom
      child: Column(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF1B5E20)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          Text(label, style: TextStyle(fontSize: 10)),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'aktif':
        return Colors.green;
      case 'panen':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  void _showLocationDialog(String lokasi) {
    Get.defaultDialog(
      title: "Detail Lokasi",
      content: Text(lokasi),
      textConfirm: "Oke",
      buttonColor: const Color(0xFF1B5E20),
      confirmTextColor: Colors.white,
      onConfirm: () => Get.back(),
    );
  }

  void _konfirmasiHapus(String id, String nama) {
    Get.defaultDialog(
      title: "Hapus Lahan",
      middleText: "Hapus permanen lahan $nama?",
      textConfirm: "Hapus",
      buttonColor: Colors.red,
      confirmTextColor: Colors.white,
      onConfirm: () async {
        await FirebaseFirestore.instance.collection('lahan').doc(id).delete();
        Get.back();
        Get.snackbar("Terhapus", "Data lahan $nama telah dihapus.");
      },
    );
  }
}
