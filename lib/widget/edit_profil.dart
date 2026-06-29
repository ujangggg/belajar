import 'package:absen01/controller/edit_controller.dart';
import 'package:absen01/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';

class EditProfilPage extends StatelessWidget {
  const EditProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final EditProfilController controller = Get.put(EditProfilController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Edit Profil',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),

        // 🔥 INI FIX NYA
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAll(() => const HomePage(initialIndex: 3));
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            children: [
              Obx(
                () => Center(
                  child: GestureDetector(
                    onTap:
                        controller.isUploadingPhoto.value
                            ? null
                            : controller.uploadPhoto,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 118,
                          height: 118,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF8DBE54),
                              width: 2,
                            ),
                            color: Colors.white,
                          ),
                          child: ClipOval(
                            child:
                                controller.photoBase64.value != null &&
                                        controller.photoBase64.value!.isNotEmpty
                                    ? Image.memory(
                                      base64Decode(
                                        controller.photoBase64.value!,
                                      ),
                                      width: 110,
                                      height: 110,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) {
                                        return Image.asset(
                                          'assets/logo_sitebu.jpeg',
                                          width: 110,
                                          height: 110,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    )
                                    : Image.asset(
                                      'assets/logo_sitebu.jpeg',
                                      width: 110,
                                      height: 110,
                                      fit: BoxFit.cover,
                                    ),
                          ),
                        ),
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            child:
                                controller.isUploadingPhoto.value
                                    ? const Padding(
                                      padding: EdgeInsets.all(8),
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : const Icon(
                                      Icons.camera_alt_rounded,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Obx(
                () => Text(
                  controller.isUploadingPhoto.value
                      ? 'Sedang upload foto...'
                      : 'Tap foto untuk mengganti',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ),

              const SizedBox(height: 34),

              _buildLabel('Full Name'),
              const SizedBox(height: 8),

              Obx(
                () => TextField(
                  controller: controller.nameController,
                  enabled: !controller.isSavingProfile.value,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  decoration: _buildInputDecoration(
                    hint: 'Enter your name',
                    icon: Icons.person_outline_rounded,
                  ),
                ),
              ),

              const SizedBox(height: 22),

              _buildLabel('Email Address'),
              const SizedBox(height: 8),

              Obx(
                () => TextField(
                  enabled: false,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: _buildInputDecoration(
                    hint:
                        controller.email.value.isEmpty
                            ? 'Email'
                            : controller.email.value,
                    icon: Icons.email_outlined,
                    isDark: false,
                  ).copyWith(fillColor: Colors.grey.shade200),
                ),
              ),

              const SizedBox(height: 46),

              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      disabledBackgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    onPressed:
                        controller.isSavingProfile.value
                            ? null
                            : controller.saveProfile,
                    child:
                        controller.isSavingProfile.value
                            ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : const Text(
                              'Save Changes',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  static InputDecoration _buildInputDecoration({
    required String hint,
    required IconData icon,
    bool isDark = true,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: isDark ? Colors.black : Colors.grey),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 17, horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFF8DBE54), width: 2),
      ),
    );
  }
}
