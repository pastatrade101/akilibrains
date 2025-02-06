import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdfx/pdfx.dart';import 'package:http/http.dart' as http;

import '../../../../utils/loader/loader.dart';



class BoughtBooksPdfViewController extends GetxController {
  PdfControllerPinch? pdfControllerPinch;
  var totalPageCount = 0.obs;
  var currentPage = 1.obs;
  var isLoading = false.obs; // Loading state

  Future<void> loadPdfFromUrl(String pdfUrl) async {
    try {
      isLoading.value = true; // Set loading state
      final Uint8List pdfBytes = await _getPdfBytes(pdfUrl);
      pdfControllerPinch = PdfControllerPinch(document: PdfDocument.openData(pdfBytes));






    } catch (error) {
      TLoaders.warningSnackBar(title: '$error');
      debugPrint('Error loading PDF: $error');
      // Set default value on error
    } finally {

      isLoading.value = false; // Clear loading state
    }
  }

  void loadPdfFromFile(File file) {
    pdfControllerPinch = PdfControllerPinch(
      document: PdfDocument.openData(file.readAsBytesSync()),
    );
    isLoading.value = false;
  }

  Future<Uint8List> _getPdfBytes(String pdfUrl) async {
    final http.Response response = await http.get(Uri.parse(pdfUrl));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load PDF from URL');
    }
  }

  void nextPage() {
    pdfControllerPinch?. nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.linear,
    );
  }

  void previousPage() {
    pdfControllerPinch?.previousPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.linear,
    );
  }

  void previewPayingPage(){


  }
}
