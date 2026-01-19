import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mm_textiles_admin/Backendservice/BackendService.dart';
import 'package:mm_textiles_admin/Backendservice/connectionService.dart';

class SubCategoryController extends GetxController {
  final RxBool isLoading = false.obs;

  final RxList<SubCategoryModel> subCategoryList = <SubCategoryModel>[].obs;

  final RxList<SubCategoryModel> filteredList = <SubCategoryModel>[].obs;

  @override
  void onInit() {
    fetchSubCategories();
    super.onInit();
  }

  Future<void> fetchSubCategories() async {
    try {
      isLoading.value = true;

      final response = await Backendservice.function(
        {},
        ConnectionService.subCategoryList,
        "GET",
      );

      log("Subcategory List :$response");

      if (response['status'] == true) {
        final List data = response['subcategory_details'];

        subCategoryList.value =
            data.map((e) => SubCategoryModel.fromJson(e)).toList();

        filteredList.value = subCategoryList;
      }
    } finally {
      isLoading.value = false;
    }
  }

  void onSearch(String value) {
    if (value.isEmpty) {
      filteredList.value = subCategoryList;
    } else {
      final query = value.toLowerCase();

      filteredList.value = subCategoryList.where((item) {
        return item.subCategoryName.toLowerCase().contains(query) || // sc_name
            item.productName.toLowerCase().contains(query) || // p_name
            item.categoryName.toLowerCase().contains(query) || // c_name
            item.status.toLowerCase().contains(query) || // status
            (item.priceA ?? '').toLowerCase().contains(query) || // cat_a
            (item.priceB ?? '').toLowerCase().contains(query) || // cat_b
            (item.priceC ?? '').toLowerCase().contains(query); // cat_c
      }).toList();
    }
  }
}

class SubCategoryModel {
  final int id;
  final String subCategoryName; // sc_name
  final String productName; // p_name
  final String categoryName; // c_name
  final String? image;
  final int itemCount;
  final String? priceA; // cat_a
  final String? priceB; // cat_b
  final String? priceC; // cat_c
  final String status; // subcategory_status

  SubCategoryModel({
    required this.id,
    required this.subCategoryName,
    required this.productName,
    required this.categoryName,
    required this.image,
    required this.itemCount,
    required this.status,
    this.priceA,
    this.priceB,
    this.priceC,
  });

  /// Optional numeric helpers
  int get priceAInt => int.tryParse(priceA ?? '0') ?? 0;
  int get priceBInt => int.tryParse(priceB ?? '0') ?? 0;
  int get priceCInt => int.tryParse(priceC ?? '0') ?? 0;

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['id'],
      subCategoryName: json['sc_name'] ?? '',
      productName: json['product']?['p_name'] ?? '',
      categoryName: json['category']?['c_name'] ?? '',
      image: json['sc_logo'],
      itemCount: json['item_count'] ?? 0,
      status: json['subcategory_status'] ?? '',
      priceA: json['cat_a'],
      priceB: json['cat_b'],
      priceC: json['cat_c'],
    );
  }
}
