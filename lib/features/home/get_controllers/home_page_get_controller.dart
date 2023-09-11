import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dainik_shiv_times/core/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/category_model.dart';

class HomePageGetController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxList<ArticleCategoryModel> categories = <ArticleCategoryModel>[].obs;

  RxInt selectedIndex = 0.obs;

  late TabController tabController;

  Future<void> loadCategories() async {
    await FirebaseFirestore.instance
        .collection(AppConstants.categories)
        .get()
        .then((value) {
      categories.value = value.docs
          .map((e) =>
              ArticleCategoryModel.fromJson(jsonDecode(jsonEncode(e.data()))))
          .toList();
      categories.sort((a, b) => a.categoryNumber.compareTo(b.categoryNumber));
    });
  }

  @override
  void onInit() {
    loadCategories().then((value) {
      tabController = TabController(length: categories.length, vsync: this);
      tabController.addListener(() {
        selectedIndex.value = tabController.index;
      });
    });
    super.onInit();
  }

  Future<void> deleteDuplicateCategories() async {
    await FirebaseFirestore.instance
        .collection(AppConstants.categories)
        .get()
        .then((value) async {
      List<ArticleCategoryModel> allCategories = value.docs
          .map((e) =>
              ArticleCategoryModel.fromJson(jsonDecode(jsonEncode(e.data()))))
          .toList();
      List<ArticleCategoryModel> uniqueCategories = [];
      for (var category in allCategories) {
        int indexWhere = uniqueCategories.indexWhere((uniqueCategory) {
          return uniqueCategory.name == category.name;
        });
        if (indexWhere == -1) {
          uniqueCategories.add(category);
        }
      }
      for (var allCategory in allCategories) {
        await FirebaseFirestore.instance
            .collection(AppConstants.categories)
            .doc(allCategory.id)
            .delete();
      }
      for (var uniqueCategory in uniqueCategories) {
        ArticleCategoryModel newCategory = uniqueCategory.copyWith(
            id: '${uniqueCategories.indexOf(uniqueCategory) + 1}',
            categoryNumber: uniqueCategories.indexOf(uniqueCategory) + 1);
        await FirebaseFirestore.instance
            .collection(AppConstants.categories)
            .doc(newCategory.id)
            .set(newCategory.toJson());
      }
    });
  }

  Future<void> saveCategory() async {
    List<String> categoryNames = [];
/*1. Edit/Opinion
2. EDUCATION
3. Entertainment
4. Healthcare
5. International
6. Jammu
7. Kashmir
8. More
9. National
10. Uncategorized*/
    categoryNames.add("Business");
    categoryNames.add("Edit/Opinion");
    categoryNames.add("EDUCATION");
    categoryNames.add("Entertainment");
    categoryNames.add("Healthcare");
    categoryNames.add("International");
    categoryNames.add("Jammu");
    categoryNames.add("Kashmir");
    categoryNames.add("More");
    categoryNames.add("National");
    categoryNames.add("Uncategorized");

    for (var categoryName in categoryNames) {
      ArticleCategoryModel articleCategoryModel = ArticleCategoryModel(
        id: (categoryNames.indexOf(categoryName) + categories.length + 1)
            .toString(),
        name: categoryName,
        categoryNumber:
            categoryNames.indexOf(categoryName) + categories.length + 1,
      );

      await FirebaseFirestore.instance
          .collection(AppConstants.categories)
          .doc((categoryNames.indexOf(categoryName) + categories.length + 1)
              .toString())
          .set(articleCategoryModel.toJson());
    }
  }
}
