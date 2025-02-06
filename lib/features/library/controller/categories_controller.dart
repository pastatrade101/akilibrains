import 'package:get/get.dart';

import '../../../data/repositories/categories/category_repository.dart';
import '../../../utils/loader/loader.dart';
import '../models/category_model.dart';



class CategoryController extends GetxController {
  static CategoryController get instance => Get.find();
  final _categoryRepository = Get.put(CategoryRepsitory());
  final isLoading = false.obs;
  RxList<CategoryModel> allCategories = <CategoryModel>[].obs;
  RxList<CategoryModel> trendingCategories = <CategoryModel>[].obs;
  RxList<CategoryModel> featuredCategories = <CategoryModel>[].obs;
  RxList<CategoryModel> getByCategory = <CategoryModel>[].obs;

// Load category data once
  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  } // Load category data

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      //   Fetch categories from the data source
      final categories = await _categoryRepository.getAllCategories();

      // Update Categories

      allCategories.assignAll(categories);
      // Filter trending categories


      trendingCategories.assignAll(
          categories.where((category) => category.isTrending).take(8).toList());
      // Featured categories
      featuredCategories.assignAll(
          categories.where((category) => category.isFeatured).take(8).toList());
    } catch (e) {
      TLoaders.errorSnackBar(title: e.toString(), message: 'Oh snap');
    } finally {
      //   remove loader
      isLoading.value = false;
    }
  }


}
