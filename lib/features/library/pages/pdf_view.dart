import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdfx/pdfx.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:trade101/features/library/delay_display.dart';

import '../../../common/widgets/appbar/appbar.dart';
import '../../../common/widgets/shimmer/shimmer_effect.dart';
import '../../../home_menu.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../../../utils/loader/loader.dart';
import '../../wishlist/payments/payment-page.dart';
import 'controllers/pdf_controller.dart';

class PdfView extends StatelessWidget {
  final PdfViewController controller = Get.put(PdfViewController());
  final String pdfUrl;
  final String? title, bookID;
  final String? imageUrl, author, price;

  PdfView({
    Key? key,
    required this.pdfUrl,
    this.title,
    this.bookID,
    this.imageUrl,
    this.author,
    this.price,
  }) : super(key: key) {
    _downloadAndCachePdf();
  }

  Future<void> _downloadAndCachePdf() async {
    try {
      // Set isLoading to true before starting the download
      controller.isLoading.value = true;

      File? cachedFile = await DefaultCacheManager().getSingleFile(pdfUrl);
      if (cachedFile != null) {
        print('Cached PDF file path: ${cachedFile.path}');
        controller.loadPdfFromFile(cachedFile);
      } else {
        TLoaders.errorSnackBar(title: 'Error', message: 'Failed to download PDF');
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: 'Failed to download PDF:');
    } finally {
      // Set isLoading to false when download finishes (whether successful or not)
      controller.isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: false,
        leadingIcon: Icons.arrow_left,
        leadingOnPressed: () {
          Get.back();
          controller.currentPage.value = 1;
        },
        color: THelperFunctions.isDarkMode(context) ? TColors.black : TColors.primary,
        title: Text(
          title.toString(),
          style: TextStyle(
            color: THelperFunctions.isDarkMode(context) ? TColors.primaryBackground : TColors.light,
          ),
        ),
        padding: 0,
      ),
      body: _buildUI(context),
    );
  }

  Widget _buildUI(BuildContext context) {
    final number = int.tryParse(bookID ?? '');
    final finalResult = number ?? 3;
    const Duration initialDelay = Duration(milliseconds: 500);
    return Column(
      children: [
        Obx(() => Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [



            Obx(() => controller.isLoading.value ||
                controller.pdfControllerPinch?.pagesCount == null
                ? const Text('Getting pages...')
                : Text(
              "Total Pages: ${(controller.pdfControllerPinch?.pagesCount)}",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: TColors.accent),
            )),
            IconButton(
              onPressed: controller.previousPage,
              icon: const Icon(Icons.arrow_back),
            ),
            Text("Current Page: ${controller.currentPage}"),
            IconButton(
              onPressed: controller.nextPage,
              icon: const Icon(Icons.arrow_forward),
            ),
          ],
        )),
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              // Show shimmer effect while loading
              return Center(
                child: TShimmerEffect(
                  width: THelperFunctions.screenWidth(),
                  height: 800,
                ),
              );
            } else if (controller.pdfControllerPinch != null &&
                controller.currentPage <= finalResult) {
              // Show PDF viewer when loaded
              return DelayedDisplay(
                delay: Duration(milliseconds: initialDelay.inMilliseconds + 200),
                child: PdfViewPinch(
                  scrollDirection: Axis.vertical,
                  controller: controller.pdfControllerPinch!,
                  onPageChanged: (page) {
                    controller.currentPage.value = page;
                    // Check if the user has reached the final page
                    if (page == finalResult) {
                      // Show dialog to prompt user to buy the book
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DelayedDisplay(delay: Duration(milliseconds: initialDelay.inMilliseconds + 50),
                            child: AlertDialog(
                              title: const Text('Buy This Book'),
                              content: Text('Would you like to buy this book $title'),
                              actions: [
                                OutlinedButton(
                                  onPressed: () {
                                    // Close the dialog
                                    Navigator.of(context).pop();
                                    controller.currentPage.value = 0;
                                    Get.offAll(const HomeMenu());
                                  },
                                  child: const Text('Cancel'),
                                ),
                                SizedBox(
                                  width: 100,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      // Implement your buy logic here
                                      // For example, show a confirmation message

                                      // Close the dialog
                                      Navigator.of(context).pop();controller.isLoading.value = !controller.isLoading.value;
                                      Get.to(PaymentPage(
                                        title: '$title',
                                        bookUrl: '$imageUrl',
                                        author: '$author',
                                        price: '$price',
                                        bookID: '$bookID',
                                        items: [],
                                      ));

                                      // Use the access token as needed
                                    },
                                    child: const Text('Buy Now'),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              );
            } else {
              // Return button to go back to home while PDF is not loading
              return Center(
                child: TextButton(
                  onPressed: () {
                    Get.to(const HomeMenu());
                    controller.currentPage.value = 1;
                    controller.isLoading.value = !controller.isLoading.value;
                  },
                  child: const Text('Back to Home'),
                ),
              );
            }
          }),
        ),
      ],
    );
  }
}
