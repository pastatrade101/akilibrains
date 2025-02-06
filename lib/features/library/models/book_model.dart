import 'package:cloud_firestore/cloud_firestore.dart';

class BookModel {
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
  final int? count;

  BookModel({
    this.isTrending,
    required this.author,
    this.isPopular,
    this.isFeatured,
    this.count,
    required this.id,
    required this.bookName,
    required this.image,
    required this.bookUrl,
    required this.price,
    required this.category,
  });

  // Empty helper function
  static BookModel empty() => BookModel(
      category: '',
      id: '',
      isFeatured: false,
      isTrending: false,
      image: '',
      author: '',
      bookName: '',
      price: '',
      isPopular: false,
      bookUrl: '');

//   Convert model to json structure so that you can store data in the firebase
  Map<String, dynamic> toJason() {
    return {
      'categoryName': category,
      'IsFeatured': isFeatured,
      'IsTrending': isTrending,
      'image': image,
      'Price': price,
      'BookName': bookName,
      'BookID': id,
      'Author': author,
      'IsPopular': isPopular,
      'BookURL': bookUrl,
    };
  }

  // Map json oriented document snapshot from firebase to user model
  factory BookModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      // Map json record to the model
      return BookModel(
        category: data['categoryName' ?? ''],
        bookUrl: data['BookURL' ?? ''],
        isPopular: data['IsPopular' ?? false],
        id: document.id,
        isFeatured: data['IsFeatured' ?? false],
        isTrending: data['IsTrending' ?? false],
        image: data['image' ?? ''],
        author: data['Author'] ?? '',
        bookName: data['BookName' ?? ''],
        price: data['Price' ?? ''],
      );
    } else {
      return BookModel.empty();
    }
  }

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'],

      author: json['Author'],
      bookName: json['BookName'],
      category: json['categoryName'],
      bookUrl: json['BookURL'],
      image: json['image'],
      isFeatured: json['IsFeatured'],
      isTrending: json['IsTrending'],
      isPopular: json['IsPopular'],

      price: json['Price'],
      count: json['count'],

    );
  }
}

