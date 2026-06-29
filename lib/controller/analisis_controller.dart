import 'package:get/get.dart';
import '../controller/lahan_controller.dart';
import '../controller/irigasi_controller.dart';
import '../controller/pupuk_controller.dart';
import '../model/model_lahan.dart';

class AnalisisController extends GetxController {
  final LahanController lahanC = Get.find();
  final IrigasiController irigasiC = Get.find();
  final PupukController pupukC = Get.find();

  final selectedLahan = Rxn<LahanModel>();

  @override
  void onInit() {
    super.onInit();

    ever(irigasiC.irigasiList, (_) {
      update();
    });

    ever(pupukC.pupukList, (_) {
      update();
    });
  }

  // =========================
  // PILIH LAHAN
  // =========================

  void pilihLahan(LahanModel lahan) {
    selectedLahan.value = lahan;

    irigasiC.fetchIrigasiByLahan(lahan.id);
    pupukC.fetchPupukByLahan(lahan.id);

    update();
  }

  // =========================
  // DATA DASAR
  // =========================

  int get umurTanaman {
    if (selectedLahan.value == null) return 0;

    return DateTime.now().difference(selectedLahan.value!.tanggalTanam).inDays;
  }

  int get sisaHariPanen {
    return (330 - umurTanaman).clamp(0, 330);
  }

  String get faseTanaman {
    final umur = umurTanaman;

    if (umur <= 30) {
      return "Awal Tanam";
    }

    if (umur <= 120) {
      return "Pertumbuhan";
    }

    if (umur <= 330) {
      return "Kemasakan";
    }

    return "Siap Panen";
  }

  // =========================
  // IRIGASI
  // =========================

  int get totalIrigasi {
    return irigasiC.irigasiList.length;
  }

  double get totalAir {
    return irigasiC.irigasiList.fold(0.0, (sum, item) => sum + item.volumeAir);
  }

  double get rataAir {
    if (totalIrigasi == 0) return 0;

    return totalAir / totalIrigasi;
  }

  // =========================
  // PEMUPUKAN
  // =========================

  int get totalPemupukan {
    return pupukC.pupukList.length;
  }

  double get totalPupuk {
    return pupukC.pupukList.fold(0.0, (sum, item) => sum + item.jumlah);
  }

  // =========================
  // TARGET FASE
  // =========================

  int get targetIrigasi {
    final umur = umurTanaman;

    if (umur <= 30) {
      return 2;
    }

    if (umur <= 120) {
      return 3;
    }

    if (umur <= 330) {
      return 3;
    }

    return 12;
  }

  int get targetPemupukan {
    final umur = umurTanaman;

    if (umur <= 30) {
      return 1;
    }

    if (umur <= 120) {
      return 2;
    }

    if (umur <= 330) {
      return 1;
    }

    return 4;
  }

  // =========================
  // CAPAIAN TARGET
  // =========================

  double get capaianIrigasi {
    if (targetIrigasi == 0) return 0;

    return ((totalIrigasi / targetIrigasi) * 100).clamp(0, 100);
  }

  double get capaianPemupukan {
    if (targetPemupukan == 0) return 0;

    return ((totalPemupukan / targetPemupukan) * 100).clamp(0, 100);
  }

  

  // =========================
  // PROGRESS PANEN
  // =========================

  double get progressPanen {
    return (umurTanaman / 330).clamp(0.0, 1.0);
  }

  // =========================
  // SKOR KESEHATAN
  // =========================
  // Irigasi     = 50 poin
  // Pemupukan   = 50 poin
  // Total       = 100 poin

  int get skorKesehatan {
    double skor = 0;

    skor += (capaianIrigasi / 100) * 50;
    skor += (capaianPemupukan / 100) * 50;

    return skor.round().clamp(0, 100);
  }

  // =========================
  // STATUS KESEHATAN
  // =========================

  String get statusKesehatan {
    final skor = skorKesehatan;

    if (skor >= 85) {
      return "Sangat Baik";
    }

    if (skor >= 70) {
      return "Baik";
    }

    if (skor >= 50) {
      return "Cukup";
    }

    return "Perlu Perhatian";
  }

  // =========================
  // REKOMENDASI
  // =========================

  String get rekomendasi {
    final kurangIrigasi = (targetIrigasi - totalIrigasi).clamp(0, 999);

    final kurangPupuk = (targetPemupukan - totalPemupukan).clamp(0, 999);

    if (kurangIrigasi == 0 && kurangPupuk == 0) {
      return "Perawatan tanaman sudah sesuai dengan kebutuhan fase saat ini.";
    }

    if (kurangIrigasi > 0 && kurangPupuk > 0) {
      return "Tambahkan $kurangIrigasi kali irigasi dan "
          "$kurangPupuk kali pemupukan agar sesuai target fase $faseTanaman.";
    }

    if (kurangIrigasi > 0) {
      return "Tambahkan $kurangIrigasi kali irigasi agar kebutuhan air tanaman terpenuhi.";
    }

    return "Tambahkan $kurangPupuk kali pemupukan untuk mendukung pertumbuhan tanaman.";
  }

  // =========================
  // BADGE WARNA STATUS
  // =========================

  String get kategoriWarnaStatus {
    final skor = skorKesehatan;

    if (skor >= 85) {
      return "green";
    }

    if (skor >= 70) {
      return "lightGreen";
    }

    if (skor >= 50) {
      return "orange";
    }

    return "red";
  }

  // =========================
  // RINGKASAN
  // =========================

  String get ringkasanAnalisis {
    return """
Fase saat ini: $faseTanaman

Target Irigasi : $targetIrigasi kali
Realisasi      : $totalIrigasi kali

Target Pupuk   : $targetPemupukan kali
Realisasi      : $totalPemupukan kali

Status         : $statusKesehatan
""";
  }
}
