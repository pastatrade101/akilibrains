import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryModel {
  final String categoryName, id;
  final bool isFeatured;

  final bool isTrending;
  String? image;

  CategoryModel(
      {required this.categoryName,


      required this.isTrending,this.image,
      required this.id,
      required this.isFeatured});

  // Empty helper function
  static CategoryModel empty() =>
      CategoryModel(categoryName: '', id: '', isFeatured: false, isTrending: false,image: '');

//   Convert model to json structure so that you can store data in the firebase
  Map<String, dynamic> toJason() {
    return {
      'Category': categoryName,
      'IsFeatured': isFeatured,

      'IsTrending': isTrending,
      'Image': image,
    };
  }

// Map json oriented document snapshot from firebase to user model
  factory CategoryModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      // Map json record to the model
      return CategoryModel(
          categoryName: data['Category'??''],
          id: document.id,
          isFeatured: data['IsFeatured'??false],

          isTrending: data['IsTrending'??false],
          image: data[Image??''],
      );
    }else{
      return CategoryModel.empty();
    }
  }
}
