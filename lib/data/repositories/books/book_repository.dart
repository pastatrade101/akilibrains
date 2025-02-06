
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';



import '../../../features/library/models/book_model.dart';
import '../authentication/authentication_repository.dart';


class BookRepository extends GetxController {
  static BookRepository get instance => Get.find();

//   variables
  final _db = FirebaseFirestore.instance;

// Get all Books
  Future<List<BookModel>> getAllBooks() async {
    try {
      final snapshot = await _db.collection('books').get();
      final list =  snapshot.docs.map((document)=>BookModel.fromSnapshot(document)).toList();
      return list;

    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch(e){
      throw TFormatException();
    }

    catch (e) {
      throw e.toString();
    }
  }
  /// Get favorite products based on a list of product IDs.
  Future<List<BookModel>> getFavouriteBooks(List<String> productIds) async {
    try {
      final snapshot = await _db.collection('books').where(FieldPath.documentId, whereIn: productIds).get();
      return snapshot.docs.map((querySnapshot) => BookModel.fromSnapshot(querySnapshot)).toList();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
//   Get subcategories

// Upload categories to the cloud firestore


}
