import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../services/ai_service.dart';

class GeminiPage extends StatefulWidget {
  const GeminiPage({super.key});

  @override
  State<GeminiPage> createState() => _GeminiPageState();
}

class _GeminiPageState extends State<GeminiPage> {
  final controller = Get.put(GeminiController());
  final TextEditingController textController = TextEditingController();
  final ImagePicker picker = ImagePicker();

  // Color Palette Segar & Profesional (Tema Agrotech Modern)
  static const Color primaryGreen = Color(0xFF1B5E20);
  static const Color secondaryGreen = Color(0xFF2E7D32);
  static const Color bgLight = Color(0xFFF4F9F5);
  static const Color accentOrange = Color(0xFFE65100);
  static const Color accentBlue = Color(0xFF1565C0);

  Future<void> _handleImage(ImageSource source) async {
    final XFile? image = await picker.pickImage(
      source: source,
      imageQuality: 35,
      maxWidth: 1024,
      maxHeight: 1024,
    );

    if (image != null) {
      final Uint8List bytes = await image.readAsBytes();
      controller.deteksiSistem("Analisis foto tebu ini", imageBytes: bytes);
    }
  }

  void _sendText() {
    final text = textController.text.trim();

    if (text.isEmpty || controller.isLoading.value) return;

    controller.deteksiSistem(text);
    textController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Pakar SITEBU AI",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 2),
            Text(
              "Asisten Budidaya Tebu",
              style: TextStyle(
                fontSize: 12,
                color: Colors.white70,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        actions: [
          IconButton(
            onPressed: () => controller.resetChat(),
            icon: const Icon(Icons.delete_sweep_rounded, size: 26),
            tooltip: "Bersihkan Chat",
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                final response = controller.responseText.value;
                final isLoading = controller.isLoading.value;

                return SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  child: Column(
                    children: [
                      // Avatar Status AI
                      Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  isLoading ? primaryGreen : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 36,
                            backgroundColor: Colors.white,
                            child:
                                isLoading
                                    ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: primaryGreen,
                                        strokeWidth: 3,
                                      ),
                                    )
                                    : const Icon(
                                      Icons.spa_rounded,
                                      color: secondaryGreen,
                                      size: 36,
                                    ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Chat Bubble / Response Container
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: SelectableText(
                          response.isEmpty
                              ? "Selamat datang di SITEBU AI! 🌱\n\nSaya siap membantu mendeteksi hama dari foto atau menjawab pertanyaan seputar budidaya tebu.\n\nGunakan kamera, galeri, atau ketik pertanyaan Anda di bawah ini."
                              : response,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            color: Colors.grey.shade800,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, bottomPadding > 0 ? 12 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Attachment Actions dalam grup terpadu
          _inputActionButton(
            icon: Icons.camera_alt_rounded,
            color: accentOrange,
            onTap: () => _handleImage(ImageSource.camera),
          ),
          const SizedBox(width: 6),
          _inputActionButton(
            icon: Icons.photo_library_rounded,
            color: accentBlue,
            onTap: () => _handleImage(ImageSource.gallery),
          ),
          const SizedBox(width: 10),

          // Text Input Field
          Expanded(
            child: TextField(
              controller: textController,
              minLines: 1,
              maxLines: 4,
              textInputAction: TextInputAction.newline,
              style: const TextStyle(fontSize: 15),
              decoration: InputDecoration(
                hintText: "Tanya Pakar AI...",
                hintStyle: TextStyle(color: Colors.grey.shade400),
                filled: true,
                fillColor: bgLight,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Send Button
          Obx(() {
            final loading = controller.isLoading.value;

            return Material(
              color: loading ? Colors.grey.shade300 : primaryGreen,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                onTap: loading ? null : _sendText,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 46,
                  height: 46,
                  alignment: Alignment.center,
                  child: Icon(
                    loading
                        ? Icons.hourglass_empty_rounded
                        : Icons.send_rounded,
                    color: loading ? Colors.grey.shade600 : Colors.white,
                    size: 20,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _inputActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color.withOpacity(0.08),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: color, size: 21),
        ),
      ),
    );
  }
}
