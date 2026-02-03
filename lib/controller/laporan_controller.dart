import 'package:get/get.dart';
import 'irigasi_controller.dart';
import 'pupuk_controller.dart';

class LaporanController extends GetxController {
  final IrigasiController irigasiC = Get.find();
  final PupukController pupukC = Get.find();

  // Filter pilihan lahan (jika user ingin melihat laporan lahan tertentu saja)
  RxString filterLahanId = ''.obs;

  // Fungsi untuk mendapatkan semua aktivitas gabungan (Irigasi + Pupuk)
  // Ini berguna jika kamu ingin membuat "Log Aktivitas" gabungan
  List<dynamic> get semuaAktivitas {
    List<dynamic> gabungan = [];
    gabungan.addAll(irigasiC.irigasiList);
    gabungan.addAll(pupukC.pupukList);
    
    // Urutkan berdasarkan tanggal terbaru
    gabungan.sort((a, b) => b.tanggal.compareTo(a.tanggal));
    
    // Jika ada filter lahan, saring datanya
    if (filterLahanId.value.isNotEmpty) {
      return gabungan.where((item) => item.lahanId == filterLahanId.value).toList();
    }
    
    return gabungan;
  }
}