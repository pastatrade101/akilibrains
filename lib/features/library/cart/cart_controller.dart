import 'package:get/get.dart';



import '../../../../utils/local_storage/storage_utility.dart';

import '../../../utils/loader/loader.dart';

import '../models/book_model.dart';
import 'cart_model.dart';


class CartController extends GetxController {
  static CartController get instance => Get.find();

  RxInt noOfCartItems = 0.obs;
  RxDouble totalCartPrice = 0.0.obs;
  RxInt bookQuantityInCart = 1.obs;
  RxList<CartItemModel> cartItems = <CartItemModel>[].obs;


  CartController() {
    loadCartItems();
  }

  /// This function converts a BookModel to a CartItemModel
  CartItemModel convertToCartItem(BookModel book, int quantity) {



    return CartItemModel(
      bookId: book.id,
      title: book.bookName,
      price: double.parse(book.price),
      quantity: quantity,image: book.image, author: book.author




    );
  }

  void addToCart(BookModel book) {
    // Quantity Check
    if (bookQuantityInCart.value < 1) {
      TLoaders.customToast(message: 'Select Quantity');
      return;
    }





    // Convert the ProductModel to a CartItemModel with the given quantity
    final selectedCartItem = convertToCartItem(book, bookQuantityInCart.value);

    // Check if already added in the Cart
    int index = cartItems
        .indexWhere((cartItem) => cartItem.bookId == selectedCartItem.bookId);

    if (index >= 0) {
      // This quantity is already added or Updated/Removed from the design (Cart)(-)
      cartItems[index].quantity = selectedCartItem.quantity;
    } else {
      cartItems.add(selectedCartItem);
    }

    updateCart();
    TLoaders.customToast(message: 'Your Book has been added to the Cart.');
  }

  void addOneToCart(CartItemModel item) {
    int index = cartItems.indexWhere((cartItem) => cartItem.bookId == item.bookId);
if(index>1){cartItems[index].quantity += 0;}else
    if (index <= 0 ) {
      cartItems[index].quantity += 1;

    } else {
      cartItems.add(item);
    }

    updateCart();
  }

  void removeOneFromCart(CartItemModel item) {
    int index = cartItems.indexWhere((cartItem) => cartItem.bookId == item.bookId);

    if (index >= 0) {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity -= 1;
      } else {
        // Show dialog before completely removing
        cartItems[index].quantity == 1 ? removeFromCartDialog(index) : cartItems.removeAt(index);
      }
      updateCart();
    }
  }

  void removeFromCartDialog(int index) {
    Get.defaultDialog(
      title: 'Remove Book',
      middleText: 'Are you sure you want to remove this book?',
      onConfirm: () {
        // Remove the item from the cart
        cartItems.removeAt(index);
        updateCart();
        TLoaders.customToast(message: 'Book removed from the Cart.');
        Get.back();
      },
      onCancel: () => () => Get.back(),
    );
  }

  void updateCart() {
    updateCartTotals();
    saveCartItems();
    cartItems.refresh();
  }

  void loadCartItems() async {
    final cartItemStrings = TLocalStorage.instance().readData<List<dynamic>>('cartItems');
    if (cartItemStrings != null) {
      cartItems.assignAll(cartItemStrings.map((item) => CartItemModel.fromJson(item as Map<String, dynamic>)));
      updateCartTotals();
    }
  }

  void updateCartTotals() {
    double calculatedTotalPrice = 0.0;
    int calculatedNoOfItems = 0;

    for (var item in cartItems) {
      calculatedTotalPrice += (item.price) * item.quantity.toDouble();
      calculatedNoOfItems += item.quantity;
    }

    totalCartPrice.value = calculatedTotalPrice;
    noOfCartItems.value = calculatedNoOfItems;
  }

  void saveCartItems() {
    final cartItemStrings = cartItems.map((item) => item.toJson()).toList();
    TLocalStorage.instance().writeData('cartItems', cartItemStrings);
  }

  /// -- Initialize already added Item's Count in the cart.
  void updateAlreadyAddedProductCount(BookModel book) {
    // If product has no variations then calculate cartEntries and display total number.
    // Else make default entries to 0 and show cartEntries when variation is selected.

      // Get selected Variation if any...


  int getProductQuantityInCart(String productId) {
    final foundItem =
        cartItems.where((item) => item.bookId == productId).fold(0, (previousValue, element) => previousValue + element.quantity);
    return foundItem;
  }



  void clearCart() {
    bookQuantityInCart.value = 0;
    cartItems.clear();
    updateCart();
  }
}}
