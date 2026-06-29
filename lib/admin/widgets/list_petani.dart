import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  
  // Variable untuk menyimpan filter yang dipilih
  // 'semua', 'admin', 'user', 'banned'
  String _selectedFilter = "semua";

  @override
  Widget build(BuildContext context) {
    final String? currentAdminUid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Manajemen User", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1B5E20),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // --- SECTION SEARCH BAR ---
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: "Cari nama atau email...",
                prefixIcon: const Icon(Icons.search, color: Color(0xFF1B5E20)),
                suffixIcon: _searchQuery.isNotEmpty 
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() { _searchQuery = ""; });
                      },
                    )
                  : null,
                filled: true,
                fillColor: Colors.green[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          // --- SECTION FILTER CHIPS ---
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Row(
              children: [
                _buildFilterChip("semua", "Semua"),
                _buildFilterChip("admin", "Admin"),
                _buildFilterChip("user", "User"),
                _buildFilterChip("banned", "Banned"),
              ],
            ),
          ),

          const Divider(),

          // --- SECTION LIST USER ---
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("Belum ada user terdaftar"));
                }

                // --- LOGIKA FILTERING GABUNGAN ---
                var users = snapshot.data!.docs.where((doc) {
                  var data = doc.data() as Map<String, dynamic>;
                  String name = (data['name'] ?? "").toString().toLowerCase();
                  String email = (data['email'] ?? "").toString().toLowerCase();
                  String role = data['role'] ?? "user";
                  bool isBanned = data['isBanned'] ?? false;

                  // 1. Cek Pencarian
                  bool matchesSearch = name.contains(_searchQuery) || email.contains(_searchQuery);

                  // 2. Cek Filter Kategori
                  bool matchesFilter = true;
                  if (_selectedFilter == "admin") matchesFilter = (role == "admin");
                  if (_selectedFilter == "user") matchesFilter = (role == "user");
                  if (_selectedFilter == "banned") matchesFilter = (isBanned == true);

                  return matchesSearch && matchesFilter;
                }).toList();

                if (users.isEmpty) {
                  return const Center(child: Text("Data tidak ditemukan"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    var userData = users[index].data() as Map<String, dynamic>;
                    String docId = users[index].id;
                    String name = userData['name'] ?? "No Name";
                    String email = userData['email'] ?? "-";
                    String role = userData['role'] ?? "user";
                    bool isBanned = userData['isBanned'] ?? false;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 3,
                      child: Opacity(
                        opacity: isBanned ? 0.6 : 1.0,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isBanned 
                                ? Colors.grey[300] 
                                : (role == "admin" ? Colors.red[100] : Colors.green[100]),
                            child: Icon(
                              isBanned ? Icons.block : (role == "admin" ? Icons.admin_panel_settings : Icons.person),
                              color: isBanned ? Colors.black54 : (role == "admin" ? Colors.red : Colors.green),
                            ),
                          ),
                          title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(email),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  _buildRoleBadge(role.toUpperCase(), role == "admin" ? Colors.red : Colors.blue),
                                  if (isBanned) ...[
                                    const SizedBox(width: 8),
                                    _buildRoleBadge("BANNED", Colors.black),
                                  ],
                                ],
                              ),
                            ],
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) => _handleAction(value, docId, name, role, email, isBanned, currentAdminUid),
                            itemBuilder: (context) => [
                              const PopupMenuItem(value: "edit", child: Text("Ubah Role")),
                              const PopupMenuItem(value: "reset", child: Text("Reset Password")),
                              PopupMenuItem(
                                value: "toggle_status", 
                                child: Text(isBanned ? "Aktifkan User" : "Banned User"),
                              ),
                              const PopupMenuItem(
                                value: "delete", 
                                child: Text("Hapus User", style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        ),
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

  // Widget untuk Tombol Filter (Filter Chip)
  Widget _buildFilterChip(String filterType, String label) {
    bool isSelected = _selectedFilter == filterType;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool selected) {
          setState(() {
            _selectedFilter = filterType;
          });
        },
        selectedColor: const Color(0xFF1B5E20),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        backgroundColor: Colors.green[50],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  // Widget untuk Badge Role
  Widget _buildRoleBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(5)),
      child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  // --- LOGIKA AKSI ADMIN ---
  void _handleAction(String action, String docId, String name, String currentRole, String email, bool isBanned, String? adminUid) {
    if (docId == adminUid && (action == "delete" || action == "toggle_status")) {
      Get.snackbar("Aksi Ditolak", "Anda tidak bisa mengutak-atik akun sendiri!",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (action == "delete") {
      Get.defaultDialog(
        title: "Hapus User",
        middleText: "Hapus $name secara permanen?",
        textConfirm: "Hapus",
        textCancel: "Batal",
        confirmTextColor: Colors.white,
        buttonColor: Colors.red,
        onConfirm: () async {
          await FirebaseFirestore.instance.collection('users').doc(docId).delete();
          Get.back();
          Get.snackbar("Terhapus", "$name berhasil dihapus.");
        },
      );
    } else if (action == "edit") {
      String newRole = currentRole == "admin" ? "user" : "admin";
      Get.defaultDialog(
        title: "Ubah Role",
        middleText: "Ubah $name menjadi $newRole?",
        textConfirm: "Ya",
        textCancel: "Batal",
        onConfirm: () async {
          await FirebaseFirestore.instance.collection('users').doc(docId).update({'role': newRole});
          Get.back();
        },
      );
    } else if (action == "reset") {
      Get.defaultDialog(
        title: "Reset Password",
        middleText: "Kirim link reset password ke $email?",
        textConfirm: "Kirim",
        onConfirm: () async {
          await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
          Get.back();
          Get.snackbar("Terkirim", "Cek inbox $email");
        },
      );
    } else if (action == "toggle_status") {
      Get.defaultDialog(
        title: isBanned ? "Aktifkan" : "Banned",
        middleText: isBanned ? "Aktifkan $name?" : "Blokir akses untuk $name?",
        textConfirm: "Ya",
        buttonColor: isBanned ? Colors.green : Colors.black,
        onConfirm: () async {
          await FirebaseFirestore.instance.collection('users').doc(docId).update({'isBanned': !isBanned});
          Get.back();
        },
      );
    }
  }
}