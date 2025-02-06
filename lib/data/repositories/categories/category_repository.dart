
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../features/library/models/category_model.dart';
import '../authentication/authentication_repository.dart';
import '../storage/firebase_storage-service.dart';

class CategoryRepsitory extends GetxController {
  static CategoryRepsitory get instance => Get.find();

//   variables
  final _db = FirebaseFirestore.instance;

// Get all categories
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final snapshot = await _db.collection('Categories').get();
      final list =  snapshot.docs.map((document)=>CategoryModel.fromSnapshot(document)).toList();
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

//   Get subcategories

// Upload categories to the cloud firestore

  /// Upload Categories to the Cloud Firebase
  Future<void> uploadDummyData(List<CategoryModel> categories) async {
    try {
      // Upload all the Categories along with their Images
      final storage = Get.put(TFirebaseStorageService());

      // Loop through each category
      for (var category in categories) {
        // Get ImageData link from the local assets
        final file = await storage.getImageDataFromAssets(category.image.toString());

        // Upload Image and Get its URL
        final url = await storage.uploadImageData('Categories', file, category.categoryName);

        // Assign URL to Category.image attribute
        category.image = url;

        // Store Category in Firestore
        await _db.collection("Categories").doc(category.id).set(category.toJason());
      }
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}
