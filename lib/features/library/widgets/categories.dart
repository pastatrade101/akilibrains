import 'package:flutter/material.dart';

import '../models/category_model.dart';

import '../../../utils/constants/sizes.dart';
import 'category_widget.dart';

class THeaderCategories extends StatelessWidget {
  const THeaderCategories({
    super.key,
    required this.categoryList,
  });

  final List<CategoryModel> categoryList;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: TSizes.sm,),
        // -- Categories
        SizedBox(
          height: 45,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: categoryList.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final category = categoryList[index];
              return CategoryWidget(
                categoryName: category.categoryName,

              );
            },
          ),
        ),const SizedBox(height: TSizes.sm,),
      ],
    );
  }
}

// Define a model for category data
