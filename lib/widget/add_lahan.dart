import 'package:absen01/auth/auth_controller.dart';
import 'package:absen01/model/model_lahan.dart';
import 'package:absen01/monitoring/lahan_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart'; // Import paket lokasi
import 'package:geocoding/geocoding.dart'; // Import paket alamat
import '../controller/lahan_controller.dart';

class AddLahan extends StatefulWidget {
  const AddLahan({super.key});

  @override
  State<AddLahan> createState() => _AddLahanState();
}

class _AddLahanState extends State<AddLahan> {
  final LahanController lahanC = Get.find();
  final AuthController authC = Get.find();

  final nameCtrl = TextEditingController();
  final lokasiCtrl = TextEditingController();
  final luasCtrl = TextEditingController();
  final varietasCtrl = TextEditingController();

  DateTime selectedDate = DateTime.now();
  final RxString selectedJenisTanah = 'Lempung'.obs;
  final RxString selectedStatus = 'Aktif'.obs;
  final RxBool isLoadingLocation = false.obs; // Loading state untuk GPS

  final Color primaryGreen = const Color(0xFF1B5E20);

  LahanModel? dataEdit;
  bool isEditMode = false;

  @override
  void initState() {
    super.initState();
    // Pengecekan argumen untuk mode edit
    if (Get.arguments != null && Get.arguments is LahanModel) {
      dataEdit = Get.arguments as LahanModel;
      isEditMode = true;

      // Isi data lama ke form pembantu dengan aman
      nameCtrl.text = dataEdit!.namaLahan;
      lokasiCtrl.text = dataEdit!.lokasi;
      luasCtrl.text = dataEdit!.luas.toString();
      varietasCtrl.text = dataEdit!.varietas;
      selectedDate = dataEdit!.tanggalTanam;
      selectedJenisTanah.value = dataEdit!.jenisTanah;
      selectedStatus.value = dataEdit!.status;
    }
  }

  // FUNGSI UNTUK MENGAMBIL LOKASI OTOMATIS VIA GPS
  Future<void> _getCurrentLocation() async {
    isLoadingLocation.value = true;
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar("Error", "GPS Anda belum aktif.");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar("Error", "Izin lokasi ditolak.");
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks[0];

      setState(() {
        lokasiCtrl.text =
            "${place.subLocality}, ${place.locality} (${position.latitude}, ${position.longitude})";
      });

      Get.snackbar("Sukses", "Lokasi berhasil ditemukan!");
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil lokasi: $e");
    } finally {
      isLoadingLocation.value = false;
    }
  }

  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 13),
      prefixIcon: Icon(icon, color: primaryGreen, size: 20),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryGreen, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBF9),
      appBar: AppBar(
        title: Text(
          isEditMode ? "Ubah Data Lahan" : "Registrasi Lahan Baru",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameCtrl,
              decoration: _inputStyle(
                "Nama Lahan (Contoh: Lahan Utara)",
                Icons.landscape_outlined,
              ),
            ),
            const SizedBox(height: 16),

            // LOKASI DENGAN TOMBOL GPS OTOMATIS
            TextField(
              controller: lokasiCtrl,
              decoration: _inputStyle(
                "Lokasi / Koordinat",
                Icons.location_on_outlined,
              ).copyWith(
                suffixIcon: Obx(
                  () =>
                      isLoadingLocation.value
                          ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                          : IconButton(
                            icon: Icon(Icons.my_location, color: primaryGreen),
                            onPressed: _getCurrentLocation,
                          ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: luasCtrl,
                    keyboardType: TextInputType.number,
                    decoration: _inputStyle(
                      "Luas (Ha)",
                      Icons.square_foot_outlined,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: varietasCtrl,
                    decoration: _inputStyle("Varietas", Icons.eco_outlined),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Obx(
              () => DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: _inputStyle("Jenis Tanah", Icons.layers_outlined),
                value: selectedJenisTanah.value,
                items:
                    ["Lempung", "Pasir", "Humus", "Liat"]
                        .map(
                          (t) => DropdownMenuItem(
                            value: t,
                            child: Text(
                              t,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        )
                        .toList(),
                onChanged: (val) => selectedJenisTanah.value = val!,
              ),
            ),
            const SizedBox(height: 16),

            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2101),
                );
                if (picked != null) setState(() => selectedDate = picked);
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      color: primaryGreen,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Tanggal Tanam",
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                        Text(
                          "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Icon(
                      Icons.edit_calendar_outlined,
                      size: 18,
                      color: primaryGreen,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Obx(
              () => DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: _inputStyle("Status Lahan", Icons.info_outline),
                value: selectedStatus.value,
                items:
                    ["Aktif", "Persiapan", "Panen", "Istirahat"]
                        .map(
                          (s) => DropdownMenuItem(
                            value: s,
                            child: Text(
                              s,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        )
                        .toList(),
                onChanged: (val) => selectedStatus.value = val!,
              ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: Obx(
                () => ElevatedButton(
                  onPressed:
                      lahanC.isLoading.value
                          ? null
                          : () async {
                            final String? currentUid =
                                authC.firebaseUser.value?.uid;
                            if (nameCtrl.text.isEmpty ||
                                lokasiCtrl.text.isEmpty) {
                              Get.snackbar(
                                "Peringatan",
                                "Nama dan Lokasi lahan wajib diisi!",
                                snackPosition: SnackPosition.BOTTOM,
                              );
                              return;
                            }

                            if (currentUid != null) {
                              final dataLahan = LahanModel(
                                id: isEditMode ? dataEdit!.id : '',
                                uid: currentUid,
                                namaLahan: nameCtrl.text,
                                lokasi: lokasiCtrl.text,
                                luas: double.tryParse(luasCtrl.text) ?? 0.0,
                                varietas: varietasCtrl.text,
                                tanggalTanam: selectedDate,
                                status: selectedStatus.value,
                                jenisTanah: selectedJenisTanah.value,
                                idSensor:
                                    isEditMode ? dataEdit!.idSensor : null,
                              );

                              bool isSuccess = false;

                              if (isEditMode) {
                                isSuccess = await lahanC.updateLahan(
                                  dataEdit!.id,
                                  dataLahan,
                                );
                              } else {
                                isSuccess = await lahanC.addLahan(dataLahan);
                              }
                              Get.snackbar(
                                "Berhasil",
                                "Data lahan berhasil disimpan",
                                snackPosition: SnackPosition.TOP,
                                backgroundColor: Colors.white,
                                colorText: Colors.black87,
                                borderRadius: 12,
                                margin: const EdgeInsets.all(12),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                boxShadows: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                                icon: const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                                duration: const Duration(seconds: 2),
                                isDismissible: true,
                                forwardAnimationCurve: Curves.easeOutBack,
                              );
                              // ⚡ PERBAIKAN DI SINI:
                              if (isSuccess == true) {
                                // Tutup semua snackbar/dialog aktif agar tidak memblokir rute Get.back()
                                if (Get.isSnackbarOpen) {
                                  await Get.closeCurrentSnackbar();
                                }
                                // Dijamin kembali ke halaman Manajemen Lahan
                                Get.off(() => LahanPage());
                              }
                            }
                          },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child:
                      lahanC.isLoading.value
                          ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                          : Text(
                            isEditMode
                                ? "Perbarui Data Lahan"
                                : "Daftarkan Lahan",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
