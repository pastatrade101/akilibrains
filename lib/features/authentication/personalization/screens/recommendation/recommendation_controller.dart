
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../library/models/book_model.dart';

class Order {
  final String userId;
  final String bookId;

  Order({required this.userId, required this.bookId});
}


class BookStoreController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxMap<String, List<BookModel>> booksByCategory = <String, List<BookModel>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // Replace 'user123' with the actual user ID
    final userId = AuthenticationRepository.instance.getUserID;
    fetchBooksForUserOrders(userId);
  }

  Future<Map<String, List<BookModel>>> fetchBooksForUserOrders(String userId) async {
    try {
      final userOrders = await fetchUserOrders(userId);

      final Set<String> bookIds = userOrders.map((order) => order.bookId).toSet();

      final List<String> categoryNames = await fetchCategoriesFromBooks(bookIds);

      final Map<String, List<BookModel>> booksByCategory = {};

      for (final categoryName in categoryNames) {
        final booksInCategory = await fetchBooksByCategory(categoryName);
        booksByCategory[categoryName] = booksInCategory;
      }

      return booksByCategory;
    } catch (error) {
      print('Error fetching books for user orders: $error');
      // If an error occurs, return an empty map instead of null
      return {};
    }
  }


  Future<List<String>> fetchCategoriesFromBooks(Set<String> bookIds) async {
    final List<String> categoryNames = [];
    for (final bookId in bookIds) {
      final docSnapshot = await _firestore.collection('books').doc(bookId).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        final categoryName = data['categoryName'] as String;
        if (!categoryNames.contains(categoryName)) {
          categoryNames.add(categoryName);
        }
      }
    }
    return categoryNames;
  }
  Future<List<BookModel>> fetchBooksByCategory(String categoryName) async {
    final querySnapshot = await _firestore
        .collection('books')
        .where('categoryName', isEqualTo: categoryName)
        .get();
    return querySnapshot.docs
        .map((doc) => BookModel(
      id: doc.id,
      bookName: doc['BookName'],
      category: doc['categoryName'],
      bookUrl: doc['BookURL'],
      image: doc['image'],
      author: doc['Author'],
      price: doc['Price'],
    ))
        .toList();
  }

  Future<List<Order>> fetchUserOrders(String userId) async {
    final querySnapshot = await _firestore
        .collection('Users_Order')
        .where('userId', isEqualTo: userId)
        .get();
    return querySnapshot.docs
        .map((doc) => Order(
      userId: doc['userId'],
      bookId: doc['bookID'],
    ))
        .toList();
  }


}