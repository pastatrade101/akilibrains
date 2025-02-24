import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'features/library/pages/controllers/pdf_controller.dart';

class UpdateController extends GetxController {
  RxString latestVersion = ''.obs;
  RxString downloadUrl = ''.obs;
  RxBool forceUpdate = false.obs;
  RxDouble downloadProgress = 0.0.obs; // Track download progress
  final PdfViewController downloadController = Get.put(PdfViewController());

  @override
  void onInit() {
    super.onInit();
    checkForUpdate();
  }

  Future<void> checkForUpdate() async {
    final packageInfo = await PackageInfo.fromPlatform();
    String currentVersion = packageInfo.version;

    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection("config").doc("app_version").get();

      if (snapshot.exists) {
        final data = snapshot.data();
        latestVersion.value = data?['android']['version'] ?? currentVersion;
        downloadUrl.value = data?['android']['download_url'] ?? '';
        forceUpdate.value = data?['android']['force_update'] ?? false;

        if (latestVersion.value.compareTo(currentVersion) > 0) {
          forceUpdate.value ? showForceUpdateDialog() : showOptionalUpdateDialog();
        }
      }
    } catch (e) {
      print("Error fetching version info: $e");
    }
  }

  void showForceUpdateDialog() {
    Get.defaultDialog(
      title: "Update Required",
      middleText: "A new version is available. Please update to continue.",
      barrierDismissible: false, // Prevent closing
      actions: [
        TextButton(
          onPressed: () => startDownload(),
          child: const Text("Update Now"),
        ),
      ],
    );
  }

  void showOptionalUpdateDialog() {
    Get.defaultDialog(
      title: "Update Available",
      middleText: "A new version is available. Would you like to update?",
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text("Later"),
        ),
        TextButton(
          onPressed: () => startDownload(),
          child: const Text("Update Now"),
        ),
      ],
    );
  }

  Future<void> startDownload() async {
    // Close the current dialog
    Get.back();

    // Show a new dialog with a progress bar
    Get.dialog(
      AlertDialog(
        title: const Text("Downloading Update"),
        content: Obx(() => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LinearProgressIndicator(value: downloadProgress.value),
            const SizedBox(height: 10),
            Text("${(downloadProgress.value * 100).toStringAsFixed(1)}%"),
          ],
        )),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close the dialog
            },
            child: Text("Cancel"),
          ),
        ],
      ),
      barrierDismissible: false, // Prevent closing the dialog
    );

    try {
      await downloadController.downloadApk(
        downloadUrl.value,
        'AkiliBrains',
        onProgress: (received, total) {
          // Update the download progress
          downloadProgress.value = received / total;
        },
      );

      // Close the progress dialog
      Get.back();

      // Show a new dialog with a "Quit App" button
      Get.dialog(
        AlertDialog(
          title: const Text("Download Complete"),
          content: const Text("The update has been downloaded. Please quit the app and install the update."),
          actions: [
            TextButton(
              onPressed: () {
                // Quit the app
                exit(0);
              },
              child: const Text("Quit App"),
            ),
          ],
        ),
        barrierDismissible: false, // Prevent closing the dialog
      );
    } catch (e) {
      // Close the progress dialog
      Get.back();

      // Show error message
      Get.snackbar(
        "Error",
        "Download failed: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> launchUrl(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(url);
    } else {
      print("Could not open $url");
    }
  }
}