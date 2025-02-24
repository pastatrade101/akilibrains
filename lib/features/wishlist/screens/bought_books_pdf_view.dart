import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pdfx/pdfx.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';


import '../../../common/widgets/appbar/appbar.dart';
import '../../../common/widgets/shimmer/shimmer_effect.dart';
import '../../../home_menu.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../../../utils/loader/loader.dart';
import '../../library/pages/controllers/bought_books_pdf_controller.dart';
import '../../library/pages/controllers/pdf_controller.dart';
import '../../wishlist/payments/payment-page.dart';

class BoughtBooksPdfView extends StatelessWidget {
  final BoughtBooksPdfViewController controller = Get.put(BoughtBooksPdfViewController());
  final PdfViewController downloadController = Get.put(PdfViewController());
  final String pdfUrl;
  final String? title, bookID;
  final String? imageUrl, author, price;

  BoughtBooksPdfView({
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
      controller.isLoading.value = true;
      File? cachedFile = await DefaultCacheManager().getSingleFile(pdfUrl);
      controller.loadPdfFromFile(cachedFile);
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: 'Failed to download PDF');
    } finally {
      controller.isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: false,
        leadingIcon: Icons.arrow_back,
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

      // Floating Action Button (FAB) for Download
      floatingActionButton: Obx(() {
        if (downloadController.isDownloading.value) {
          return FloatingActionButton(
            onPressed: null,
            backgroundColor: Colors.grey,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: downloadController.progress.value,
                  color: Colors.white,
                ),
                Text(
                  "${(downloadController.progress.value * 100).toInt()}%",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        } else {
          return FloatingActionButton(
            onPressed: () {

              downloadController.downloadFile(pdfUrl,title!);
            },
            backgroundColor: Colors.blue,
            child: const Icon(Icons.download, color: Colors.white),
          );
        }
      }),
    );

  }

  Widget _buildUI(BuildContext context) {
    final number = int.tryParse(bookID ?? '');
    final finalResult = number ?? 3;

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
              return Center(
                child: TShimmerEffect(
                  width: THelperFunctions.screenWidth(),
                  height: 800,
                ),
              );
            } else if (controller.pdfControllerPinch != null &&
                controller.currentPage <= finalResult) {
              return PdfViewPinch(
                scrollDirection: Axis.vertical,
                controller: controller.pdfControllerPinch!,
                onPageChanged: (page) {
                  controller.currentPage.value = page;
                  if (page == finalResult) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Buy This Book'),
                          content: Text('Would you like to buy this book $title'),
                          actions: [
                            OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Get.offAll(const HomeMenu());
                              },
                              child: const Text('Cancel'),
                            ),
                            SizedBox(
                              width: 100,
                              child: ElevatedButton(
                                onPressed: () async {

                                  Navigator.of(context).pop();
                                  Get.offAll(PaymentPage(
                                    title: '$title',
                                    bookUrl: '$imageUrl',
                                    author: '$author',
                                    price: '$price',
                                    bookID: '$bookID',
                                    items: [],
                                  ));
                                },
                                child: const Text('Buy Now'),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              );
            } else {
              return Center(
                child: TShimmerEffect(
                  width: THelperFunctions.screenWidth(),
                  height: 800,
                ),
              );
            }
          }),
        ),
      ],
    );
  }
}
