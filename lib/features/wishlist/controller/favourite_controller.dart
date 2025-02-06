import 'dart:convert';

import 'package:get/get.dart';


import '../../../../utils/local_storage/storage_utility.dart';
import '../../../data/repositories/books/book_repository.dart';
import '../../../utils/loader/loader.dart';
import '../../library/models/book_model.dart';


class FavouritesController extends GetxController {
  static FavouritesController get instance => Get.find();

  /// Variables
  final favorites = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize by fetching the list of already added favorites
    initFavorites();
  }

  // Method to initialize favorites by reading from storage
  void initFavorites()  {
    final json = TLocalStorage.instance().readData('favorites');
    if (json != null) {
      final storedFavorites = jsonDecode(json) as Map<String, dynamic>;
      favorites.assignAll(storedFavorites.map((key, value) => MapEntry(key, value as bool)));
    }
  }

  /// Method to check if a book is selected (favorite)
  bool isFavourite(String bookID) {
    return favorites[bookID] ?? false;
  }

  /// Add Book to Favourites
  void toggleFavoriteBooks(String bookID) {
    // If favorites do not have this product, Add. Else Toggle
    if (!favorites.containsKey(bookID)) {
      favorites[bookID] = true;
      saveFavoritesToStorage();
      TLoaders.customToast(message: 'Book has been added to the Wishlist.');
    } else {
      TLocalStorage.instance().removeData(bookID);
      favorites.remove(bookID);
      saveFavoritesToStorage();
      favorites.refresh();
      TLoaders.customToast(message: 'Book has been removed from the Wishlist.');
    }
  }

// Save the updated favorites to storage
void saveFavoritesToStorage() {
  final encodedFavorites = json.encode(favorites);
  TLocalStorage.instance().saveData('favorites', encodedFavorites);
}

/// Method to get the list of favorite products
  Future<List<BookModel>> favoriteBooks() {
    return BookRepository.instance.getFavouriteBooks(favorites.keys.toList());
  }
}
