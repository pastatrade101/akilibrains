class CartItemModel {
  String bookId;
  String title;
  String author;
  double price;
  String? image;
  int quantity;

  /// Constructor
  CartItemModel({
    required this.bookId,
    required this.author,
    required this.quantity,
    this.image,
    this.price = 0.0,
    this.title = '',
  });

  /// Empty Cart
  static CartItemModel empty() =>
      CartItemModel(bookId: '', quantity: 0, author: '');

  /// Convert a CartItem to a JSON Map
  Map<String, dynamic> toJson() {
    return {
      'bookID': bookId,
      'title': title,
      'price': price,
      'image': image,
      'quantity': quantity,
    };
  }

  /// Create a CartItem from a JSON Map
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      bookId: json['bookId'],
      title: json['title'],
      price: json['price']?.toDouble(),
      image: json['image'],
      quantity: json['quantity'],
      author: json['author'],
    );
  }
}
