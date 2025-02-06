class MyBookModel {
  final String author;
  final String id;
  final String bookName;
  final String image;
  final String price;
  final String bookUrl;
  final String category;
  final bool? isTrending;
  final bool? isFeatured;
  final bool? isPopular;

  MyBookModel({
    this.isTrending,
    required this.author,
    this.isPopular,
    this.isFeatured,
    required this.id,
    required this.bookName,
    required this.image,
    required this.bookUrl,
    required this.price,
    required this.category,
  });




  factory MyBookModel.fromMap(Map<String, dynamic> map) {
    return MyBookModel(
      image: map['image'] ?? '',
      isTrending: map['IsTrending'] ?? false,
      id: map['BookID'] ?? '',
      bookUrl: map['BookURL'] ?? '',
      price: map['Price'] ?? 0,
      bookName: map['BookName'] ?? '',
      isPopular: map['IsPopular'] ?? false,
      author: map['Author'] ?? '',
      category: map['categoryName'] ?? '',
      isFeatured: map['IsFeatured'] ?? false,
    );
  }
}
