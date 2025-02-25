import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AdsController extends GetxController {
  RxList<String> adsImages = <String>[].obs;
  RxBool isLoading = false.obs;
  RxBool hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadAdsImages();
  }

  Future<void> loadAdsImages() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('ads')
          .doc('ads_list')
          .get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('akili_brains_ads')) {
          Map<String, dynamic> adsData = data['akili_brains_ads'];
          List<String> images = [];

          for (int i = 1; i <= 5; i++) {
            String key = 'ads_$i';
            if (adsData.containsKey(key) &&
                adsData[key] is String &&
                adsData[key].isNotEmpty) {
              images.add(adsData[key]);
            }
          }
          adsImages.assignAll(images);
        }
      }
    } catch (e) {
      print('Error fetching ads images: $e');
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }
}

class AdsCarousel extends StatelessWidget {
  final AdsController adsController = Get.put(AdsController());
  final RxInt currentIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (adsController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (adsController.hasError.value || adsController.adsImages.isEmpty) {
        return const Center(child: Text("No ads available"));
      }

      final imageUrls = adsController.adsImages;

      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height,
              viewportFraction: 1.0,
              autoPlay: true,
              enlargeCenterPage: false,
              onPageChanged: (index, reason) {
                currentIndex.value = index;
              },
            ),
            items: imageUrls.map((url) {
              return Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: url,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                    const Icon(Icons.error),
                  ),
                ),
              );
            }).toList(),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0), // Reduced bottom padding
            child: AdsIndicator(
                currentIndex: currentIndex.value, totalImages: imageUrls.length),
          ),
        ],
      );
    });
  }
}

class AdsIndicator extends StatelessWidget {
  final int currentIndex;
  final int totalImages;

  const AdsIndicator(
      {super.key, required this.currentIndex, required this.totalImages});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalImages,
            (index) => Container(
          width: 8.0,
          height: 8.0,
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0), // Reduced vertical margin
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentIndex == index ? Colors.blue : Colors.grey,
          ),
        ),
      ),
    );
  }
}