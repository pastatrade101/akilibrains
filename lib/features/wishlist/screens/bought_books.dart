
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:trade101/features/library/delay_display.dart';


import '../../../common/widgets/appbar/appbar.dart';
import '../../../common/widgets/layouts/grid_layout.dart';
import '../../../data/repositories/authentication/authentication_repository.dart';
import '../../../home_menu.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/device/device_utility.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../../../utils/loader/animated_loader.dart';

import '../../library/pages/pdf_view.dart';

import '../../library/widgets/vertical_book.dart';
import 'bought_books_pdf_view.dart';

class PaidBooksPage extends StatelessWidget {
  PaidBooksPage({Key? key}) : super(key: key);

  final userId = AuthenticationRepository.instance.getUserID;


  @override
  Widget build(BuildContext context) {
    final axisCount = TDeviceUtils.getScreenWidth(context);
    const Duration initialDelay = Duration(milliseconds: 200);
    return Scaffold(
      backgroundColor: THelperFunctions.isDarkMode(context)?TColors.black:TColors.primaryBackground,
      appBar: TAppBar(color: THelperFunctions.isDarkMode(context)
          ? TColors.black
          : TColors.primaryBackground,
        centerTitle: true,
        title: const Text('My Books'),
        padding: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace - 4),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Users_Order')
                .where('userId', isEqualTo: userId)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const TAnimationLoaderWidget(
                  text: 'Preparing your Books',
                  animation: TImages.loader,
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              if (snapshot.data!.docs.isEmpty) {
                return TAnimationLoaderWidget(
                  text: 'Whoops! No books found...',
                  animation: TImages.noBooks,
                  showAction: false,
                  actionText: 'Let\'s buy some',
                  onActionPressed: () => Get.off(() => const HomeMenu()),
                );
              }
        
              // Extract the list of document snapshots from the snapshot data
              final List<DocumentSnapshot> orderDocuments = snapshot.data!.docs;
        
              // Build the list of future widgets for each document snapshot
              final List<FutureBuilder<DocumentSnapshot>> futureBuilders = orderDocuments.map((orderDocument) {
                final String bookId = orderDocument['bookID'];
                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection('books').doc(bookId).get(),
                  builder: (context, bookSnapshot) {
                    if (bookSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (bookSnapshot.hasError) {
                      return Center(child: Text('Error: ${bookSnapshot.error}'));
                    }
                    if (!bookSnapshot.hasData || !bookSnapshot.data!.exists) {
                      return TAnimationLoaderWidget(
                        text: 'Whoops! No books found...',
                        animation: TImages.noBooks,
                        showAction: true,
                        actionText: 'Let\'s buy some',
                        onActionPressed: () => Get.off(() => const HomeMenu()),
                      );
                    }
                    final Map<String, dynamic> bookData = bookSnapshot.data!.data() as Map<String, dynamic>;
                    final String author = bookData['Author'] ?? 'Unknown Author';
                    final String bookName = bookData['BookName'] ?? 'Unknown Book';
                    final String image = bookData['image'] ?? '';
                    final String price = bookData['Price'] ?? '0';
                    final String bookID = bookData['id'] ?? '';
                    final String bookURL = bookData['BookURL'] ?? '';
        
                    return VerticalBookCard(child: null,
                      onTap: () {
                        Get.to(BoughtBooksPdfView(pdfUrl: bookURL, title: bookName, bookID: '20000'));
                      },
                      author: author,
                      bookName: bookName,
                      image: image,
                      price: price,
                      bookID: bookID,
                    );
                  },
                );
              }).toList();
        
              // Build the grid layout with the future builders
              return DelayedDisplay(
                delay: Duration(milliseconds: initialDelay.inMilliseconds + 400),
                child: TGridLayout(
                  itemCount: futureBuilders.length,
                  itemBuilder: (context, index) => futureBuilders[index], crossAxisCount: (axisCount >420)?4:2,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}


