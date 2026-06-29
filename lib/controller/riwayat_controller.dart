import 'package:get/get.dart';
import '../controller/irigasi_controller.dart';
import '../controller/pupuk_controller.dart';
import '../model/model_irigasi.dart';
import '../model/model_lahan.dart';
import '../model/model_pupuk.dart';

class RiwayatController extends GetxController {
  final IrigasiController irigasiC = Get.find();
  final PupukController pupukC = Get.find();

  final selectedLahan = Rxn<LahanModel>();

  @override
  void onInit() {
    super.onInit();

    ever(irigasiC.irigasiList, (_) => update());
    ever(pupukC.pupukList, (_) => update());
  }

  void pilihLahan(LahanModel lahan) {
    selectedLahan.value = lahan;

    irigasiC.fetchIrigasiByLahan(lahan.id);
    pupukC.fetchPupukByLahan(lahan.id);

    update();
  }

  List<dynamic> get semuaRiwayat {
    final List<dynamic> data = [...irigasiC.irigasiList, ...pupukC.pupukList];

    data.sort((a, b) {
      DateTime tanggalA;
      DateTime tanggalB;

      if (a is IrigasiModel) {
        tanggalA = a.tanggal;
      } else if (a is PupukModel) {
        tanggalA = a.tanggal;
      } else {
        tanggalA = DateTime.now();
      }

      if (b is IrigasiModel) {
        tanggalB = b.tanggal;
      } else if (b is PupukModel) {
        tanggalB = b.tanggal;
      } else {
        tanggalB = DateTime.now();
      }

      return tanggalB.compareTo(tanggalA);
    });

    return data;
  }
}
