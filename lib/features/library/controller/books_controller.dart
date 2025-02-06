import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';


import '../../../data/repositories/books/book_repository.dart';
import '../../../utils/loader/loader.dart';
import '../models/book_model.dart';
import '../models/category_model.dart';


class BookController extends GetxController {
  static BookController get instance => Get.find();
  final _bookRepository = Get.put(BookRepository());
  final books = <BookModel>[].obs;
  final categories = <CategoryModel>[].obs;
  final isLoading = false.obs;

  RxList<BookModel> allBooks = <BookModel>[].obs;
  RxList<BookModel> trendingBooks = <BookModel>[].obs;
  RxList<BookModel> featuredBooks = <BookModel>[].obs;
  RxList<BookModel> popularBooks = <BookModel>[].obs;
  RxList<BookModel> getBooksByCategory = <BookModel>[].obs;

// Load category data once
  @override
  void onInit() {
    fetchBooks();

    super.onInit();
  }

  /// -- Initialize Products from the backend
  Future<void> fetchBooks() async {
    try {
      isLoading.value = true;
      //   Fetch books from the data source
      final books = await _bookRepository.getAllBooks();

      // Update books

      allBooks.assignAll(books);
      // Filter trending categories
      trendingBooks.assignAll(
          books.where((book) => book.isTrending == true).take(8).toList());   // Filter trending categories


      // Filter popular books
      popularBooks.assignAll(
          books.where((book) => book.isPopular == true).take(4).toList());
      // Featured books
      featuredBooks.assignAll(
          books.where((book) => book.isFeatured == true).take(8).toList());
    } catch (e) {
      TLoaders.errorSnackBar(title: e.toString(), message: 'Oh snap');
    } finally {
      //   remove loader
      isLoading.value = false;
    }
  }

// List<BookModel> getHistoryBooks() {
//   // Get Featured Brands from your data source
//
//   return TDummyData.books
//       .where((book) => (book.category.toLowerCase() == 'history'))
//       .toList();
// }
//
// List<BookModel> getFinanceBooks() {
//   // Get Featured Brands from your data source
//
//   return TDummyData.books
//       .where((book) => (book.category.toLowerCase() == 'finance'))
//       .toList();
// }
//
// List<BookModel> getScienceBooks() {
//   // Get Featured Brands from your data source
//
//   return TDummyData.books
//       .where((book) => (book.category.toLowerCase() == 'science'))
//       .toList();
// }
//
// List<BookModel> getNewBooks(int take) {
//   // Get Featured Brands from your data source
//   return TDummyData.books
//       .where((book) => (book.category.toLowerCase() == 'history' ||
//           book.category.toLowerCase() == 'science' ||
//           book.category.toLowerCase() == 'finance'))
//       .take(take)
//       .toList();
// }

}
