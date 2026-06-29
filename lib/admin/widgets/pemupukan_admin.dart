import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminPemupukanPage extends StatefulWidget {
  const AdminPemupukanPage({super.key});

  @override
  State<AdminPemupukanPage> createState() => _AdminPemupukanPageState();
}

class _AdminPemupukanPageState extends State<AdminPemupukanPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Monitor Lahan Petani", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                hintText: "Cari nama lahan atau pemilik...",
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
              stream: FirebaseFirestore.instance.collection('lahan').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("Belum ada data lahan masuk."));
                }

                // Filter berdasarkan pencarian nama lahan atau pemilik
                var filteredLahan = snapshot.data!.docs.where((doc) {
                  var data = doc.data() as Map<String, dynamic>;
                  String namaLahan = (data['namaLahan'] ?? "").toString().toLowerCase();
                  String pemilik = (data['namaPemilik'] ?? "Petani").toString().toLowerCase();
                  return namaLahan.contains(_searchQuery) || pemilik.contains(_searchQuery);
                }).toList();

                return ListView.builder(
                  padding: const EdgeInsets.all(15),
                  itemCount: filteredLahan.length,
                  itemBuilder: (context, index) {
                    var data = filteredLahan[index].data() as Map<String, dynamic>;
                    String docId = filteredLahan[index].id;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 4,
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.landscape, color: Colors.green, size: 30),
                            ),
                            title: Text(
                              data['namaLahan'] ?? "Lahan Tanpa Nama",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            subtitle: Text("Pemilik: ${data['namaPemilik'] ?? 'User'}"),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                              onPressed: () => _konfirmasiHapus(docId, data['namaLahan']),
                            ),
                          ),
                          const Divider(height: 1),
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildInfoItem(Icons.square_foot, "${data['luasLahan']} m²", "Luas"),
                                _buildInfoItem(Icons.calendar_month, "Padi", "Komoditas"), // Misal default padi
                                _buildInfoItem(Icons.location_on, "Lokasi", "Peta"),
                              ],
                            ),
                          ),
                        ],
                      ),
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

  // Widget kecil untuk info di bawah card
  Widget _buildInfoItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
      ],
    );
  }

  // Fungsi Hapus Data Lahan
  void _konfirmasiHapus(String docId, String? nama) {
    Get.defaultDialog(
      title: "Hapus Lahan",
      middleText: "Apakah Anda yakin ingin menghapus data lahan $nama?",
      textConfirm: "Ya, Hapus",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        await FirebaseFirestore.instance.collection('lahan').doc(docId).delete();
        Get.back();
        Get.snackbar("Sukses", "Data lahan berhasil dihapus", 
            backgroundColor: Colors.orange, colorText: Colors.white);
      },
    );
  }
}