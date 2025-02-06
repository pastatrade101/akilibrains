import 'dart:typed_data';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dt;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:pdfx/pdfx.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart' as sf;

import '../../../../utils/constants/colors.dart';
import '../../../../utils/loader/loader.dart';

class PdfViewController extends GetxController {
  PdfControllerPinch? pdfControllerPinch;
  var totalPageCount = 0.obs;
  var currentPage = 1.obs;
  var isLoading = false.obs; // Loading state
  var isDownloading = false.obs;
  var progress = 0.0.obs;

  // Function to request storage permission
  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      int sdkInt = androidInfo.version.sdkInt;

      if (sdkInt < 30) {
        // For Android 10 (API 29) and below, request regular storage permission.
        var status = await Permission.storage.request();
        return status.isGranted;
      } else {
        // For Android 11 (API 30+) and above, request Manage External Storage permission.
        var status = await Permission.manageExternalStorage.request();
        if (!status.isGranted) {
          // You should show a dialog or a message asking the user to enable the permission from settings.
          print("Storage permission not granted");
        }
        return status.isGranted;
      }
    }
    return true; // For non-Android platforms.
  }


  // Function to load PDF from URL
  Future<void> loadPdfFromUrl(String pdfUrl) async {
    try {
      isLoading.value = true; // Set loading state
      final Uint8List pdfBytes = await _getPdfBytes(pdfUrl);
      pdfControllerPinch = PdfControllerPinch(document: PdfDocument.openData(pdfBytes));
    } catch (error) {
      TLoaders.warningSnackBar(title: '$error');
      debugPrint('Error loading PDF: $error');
    } finally {
      isLoading.value = false; // Clear loading state
    }
  }

  // Function to load PDF from file
  void loadPdfFromFile(File file) {
    pdfControllerPinch = PdfControllerPinch(
      document: PdfDocument.openData(file.readAsBytesSync()),
    );
    isLoading.value = false;
  }

  // Helper function to get PDF bytes from URL
  Future<Uint8List> _getPdfBytes(String pdfUrl) async {
    final http.Response response = await http.get(Uri.parse(pdfUrl));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load PDF from URL');
    }
  }

  // Function to go to the next page in PDF
  void nextPage() {
    pdfControllerPinch?.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.linear,
    );
  }

  // Function to go to the previous page in PDF
  void previousPage() {
    pdfControllerPinch?.previousPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.linear,
    );
  }

  // Function to preview paying page (empty placeholder for now)
  void previewPayingPage() {}



  Future<void> downloadFile(String url, String fileName) async {
    // Ensure file has .pdf extension
    if (!fileName.toLowerCase().endsWith('.pdf')) {
      fileName += '.pdf';
    }

    // Check and request storage permission
    if (Platform.isAndroid) {
      bool permissionGranted = await requestStoragePermission();
      if (!permissionGranted) {
        throw Exception('Storage permission not granted');
      }
    }

    // Get the Downloads directory
    Directory? directory;
    if (Platform.isAndroid) {
      directory = Directory('/storage/emulated/0/Download');
      if (!await directory.exists()) {
        directory = await getExternalStorageDirectory();
      }
    } else if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    }

    if (directory == null) {
      throw Exception('Could not get Downloads directory');
    }

    // Define the file path
    String filePath = '${directory.path}/$fileName';

    // Start downloading
    isDownloading.value = true;
    progress.value = 0;

    try {
      Dio dio = Dio();
      await dio.download(
        url,
        filePath,
        onReceiveProgress: (receivedBytes, totalBytes) {
          progress.value = receivedBytes / totalBytes;
        },
      );

      // Get Firebase user's name
      String userName = FirebaseAuth.instance.currentUser?.displayName ?? "User";

      // Load the downloaded PDF
      File pdfFile = File(filePath);
      List<int> pdfBytes = await pdfFile.readAsBytes();

      // Add watermark using Syncfusion PDF library
      sf.PdfDocument document = sf.PdfDocument(inputBytes: pdfBytes);

      // Iterate through all pages and add watermark
      for (int i = 0; i < document.pages.count; i++) {
        sf.PdfPage page = document.pages[i];
        sf.PdfGraphics graphics = page.graphics;
        sf.PdfFont font = sf.PdfStandardFont(sf.PdfFontFamily.helvetica, 100, style: sf.PdfFontStyle.bold);

        // Get page size
        Size pageSize = page.getClientSize();

        // Save graphics state before transformations
        graphics.save();

        // Set transparency for watermark
        graphics.setTransparency(0.15); // 15% opacity (very subtle)

        // Move origin to the center of the page before rotating
        graphics.translateTransform(pageSize.width / 2, pageSize.height / 2);

        // Rotate text for a diagonal effect
        graphics.rotateTransform(-45);

        // Draw watermark text centered
        graphics.drawString(
          userName,
          font,
          brush: sf.PdfBrushes.gray, // Gray color
          format: sf.PdfStringFormat(alignment: sf.PdfTextAlignment.center),
          bounds: Rect.fromLTWH(-pageSize.width / 3, -50, pageSize.width, 200), // Adjusted for full visibility
        );

        // Restore graphics state after transformations
        graphics.restore();
      }

      // Save the modified PDF
      List<int> modifiedBytes = document.saveSync();
      document.dispose();

      // Write the modified PDF back to the file
      await pdfFile.writeAsBytes(modifiedBytes, flush: true);

      isDownloading.value = false;
      Get.snackbar(
        'Success',
        'File downloaded to $filePath',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      isDownloading.value = false;
      Get.snackbar(
        'Error',
        'Failed to download or modify file: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }





// Future<void> downloadFile(String url, String fileName) async {
//   // Ensure file has .pdf extension
//   if (!fileName.toLowerCase().endsWith('.pdf')) {
//     fileName += '.pdf';
//   }
//
//   // Check and request storage permission
//   if (Platform.isAndroid) {
//     bool permissionGranted = await requestStoragePermission();
//     if (!permissionGranted) {
//       throw Exception('Storage permission not granted');
//     }
//   }
//
//   // Get the Downloads directory
//   Directory? directory;
//   if (Platform.isAndroid) {
//     directory = Directory('/storage/emulated/0/Download');
//     if (!await directory.exists()) {
//       directory = await getExternalStorageDirectory();
//     }
//   } else if (Platform.isIOS) {
//     directory = await getApplicationDocumentsDirectory();
//   }
//
//   if (directory == null) {
//     throw Exception('Could not get Downloads directory');
//   }
//
//   // Define the file path
//   String filePath = '${directory.path}/$fileName';
//
//   // Start downloading
//   isDownloading.value = true;
//   progress.value = 0;
//
//   try {
//     Dio dio = Dio();
//     await dio.download(
//       url,
//       filePath,
//       onReceiveProgress: (receivedBytes, totalBytes) {
//         progress.value = receivedBytes / totalBytes;
//       },
//     );
//
//     // Get Firebase user's name
//     String userName = FirebaseAuth.instance.currentUser?.displayName ?? "User";
//
//     // Load the downloaded PDF
//     File pdfFile = File(filePath);
//     List<int> pdfBytes = await pdfFile.readAsBytes();
//
//     // Add watermark using Syncfusion library
//     sf.PdfDocument document = sf.PdfDocument(inputBytes: pdfBytes);
//
//     // Iterate through all pages and add watermark
//     for (int i = 0; i < document.pages.count; i++) {
//       sf.PdfPage page = document.pages[i];
//       sf.PdfGraphics graphics = page.graphics;
//       sf.PdfFont font = sf.PdfStandardFont(sf.PdfFontFamily.helvetica, 40);
//
//       // Draw watermark text
//       graphics.drawString(
//         userName,
//         font,
//         brush: sf.PdfBrushes.red,
//         bounds: Rect.fromLTWH(100, 100, 300, 50), // Adjust position & size as needed
//       );
//     }
//
//     // Save the modified PDF
//     List<int> modifiedBytes = document.saveSync();
//     document.dispose();
//
//     // Write the modified PDF back to the file
//     await pdfFile.writeAsBytes(modifiedBytes, flush: true);
//
//     isDownloading.value = false;
//     Get.snackbar(
//       'Success',
//       'File downloaded to $filePath',
//       backgroundColor: Colors.green,
//       colorText: Colors.white,
//       snackPosition: SnackPosition.BOTTOM,
//     );
//   } catch (e) {
//     isDownloading.value = false;
//     Get.snackbar(
//       'Error',
//       'Failed to download or modify file: $e',
//       backgroundColor: Colors.red,
//       colorText: Colors.white,
//       snackPosition: SnackPosition.BOTTOM,
//     );
//   }
// }

}

// Function to download file from URL
//   Future<void> downloadFile(String url, String fileName) async {
//     // Request storage permission if needed
//     if (Platform.isAndroid) {
//       bool permissionGranted = await requestStoragePermission();
//       if (!permissionGranted) {
//         throw Exception('Storage permission not granted');
//       }
//     }
//
//     // Ensure file has the correct extension
//     if (!fileName.contains('.')) {
//       fileName += '.pdf'; // Default to PDF if no extension is given
//     }
//
//     // Get the Downloads directory
//     Directory? directory;
//     if (Platform.isAndroid) {
//       directory = Directory('/storage/emulated/0/Download');
//       if (!await directory.exists()) {
//         directory = await getExternalStorageDirectory();
//       }
//     } else if (Platform.isIOS) {
//       directory = await getApplicationDocumentsDirectory();
//     }
//
//     if (directory == null) {
//       throw Exception('Could not get Downloads directory');
//     }
//
//     // Define the full file path
//     String filePath = '${directory.path}/$fileName';
//
//     // Start the download process
//     isDownloading.value = true;
//     progress.value = 0;
//
//     try {
//       Dio dio = Dio();
//
//       // Ensure the file is downloaded as binary
//       Options options = Options(
//         responseType: ResponseType.bytes, // This ensures binary file download
//         headers: {
//           'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)',
//           'Accept': '*/*',
//         },
//       );
//
//       dt.Response<List<int>> response = await dio.get<List<int>>(
//         url,
//         options: options,
//         onReceiveProgress: (receivedBytes, totalBytes) {
//           if (totalBytes > 0) {
//             progress.value = receivedBytes / totalBytes;
//           }
//         },
//       );
//
//       // Write the file properly as a binary file
//       File file = File(filePath);
//       await file.writeAsBytes(response.data!, flush: true);
//
//       isDownloading.value = false;
//
//       // Verify if the file exists
//       if (await file.exists()) {
//         Get.snackbar(
//           'Success',
//           'File downloaded successfully: $filePath',
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//           snackPosition: SnackPosition.BOTTOM,
//         );
//       } else {
//         throw Exception('File download failed.');
//       }
//     } catch (e) {
//       isDownloading.value = false;
//       Get.snackbar(
//         'Error',
//         'Failed to download file: $e',
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     }
//   }
// }
//
//
//
