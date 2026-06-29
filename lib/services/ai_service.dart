import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiController extends GetxController {
  final String _apiKey =
      '';
  late GenerativeModel _model;

  var responseText = "".obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: _apiKey);
  }

  Future<void> deteksiSistem(String pesan, {Uint8List? imageBytes}) async {
    try {
      isLoading.value = true;
      responseText.value = ""; // Reset teks lama agar user tahu ada proses baru

      final prompt = _buildSystemPrompt(pesan);
      GenerateContentResponse response;

      if (imageBytes != null) {
        // Mode Deteksi Gambar
        response = await _model.generateContent([
          Content.multi([TextPart(prompt), DataPart('image/jpeg', imageBytes)]),
        ]);
      } else {
        // Mode Tanya Jawab Teks
        response = await _model.generateContent([Content.text(prompt)]);
      }

      String result =
          response.text ?? "Maaf, SITEBU AI tidak menemukan jawaban.";
      responseText.value = _cleanText(result);
    } catch (e) {
      responseText.value =
          "Koneksi terganggu atau API Key salah. Silakan coba lagi.";
    } finally {
      isLoading.value = false;
    }
  }

  String _buildSystemPrompt(String pesan) {
    return """
Kamu adalah Pakar Budidaya Tebu (SITEBU AI). 
Tugas: Diagnosa hama/penyakit tebu atau jawab pertanyaan budidaya.
Aturan: 
- Gunakan bahasa Indonesia yang ramah dan teknis namun mudah dipahami.
- JANGAN gunakan sapaan formal seperti "Bapak", "Ibu", "Saudara", atau "Anda".
- Langsung berikan jawaban atau diagnosa ke inti permasalahannya.
- JANGAN gunakan simbol markdown (*, #, -, •).
- Gunakan paragraf singkat.
- Jika ada gambar, analisis secara visual dengan teliti.

Pertanyaan/Gejala: $pesan
""";
  }

  String _cleanText(String text) {
    return text
        .replaceAll('*', '')
        .replaceAll('#', '')
        .replaceAll('•', '')
        .replaceAll('-', '')
        .trim();
  }

  void resetChat() {
    responseText.value = "";
  }
}
