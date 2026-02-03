import 'package:get/get.dart';
import 'irigasi_controller.dart';
import 'pupuk_controller.dart';

class LaporanController extends GetxController {
  final IrigasiController irigasiC = Get.find();
  final PupukController pupukC = Get.find();

  // Filter pilihan lahan
  RxString filterLahanId = ''.obs;

  // Fungsi untuk mendapatkan semua aktivitas gabungan (Timeline)
  List<dynamic> get semuaAktivitas {
    List<dynamic> gabungan = [];
    gabungan.addAll(irigasiC.irigasiList);
    gabungan.addAll(pupukC.pupukList);
    
    // Urutkan berdasarkan tanggal terbaru (descending)
    gabungan.sort((a, b) => b.tanggal.compareTo(a.tanggal));
    
    if (filterLahanId.value.isNotEmpty) {
      return gabungan.where((item) => item.lahanId == filterLahanId.value).toList();
    }
    
    return gabungan;
  }
}