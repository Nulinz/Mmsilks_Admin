import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mm_textiles_admin/Backendservice/BackendService.dart';
import 'package:mm_textiles_admin/Backendservice/connectionService.dart';

class CategoryController extends GetxController {
  final RxBool isLoading = false.obs;

  /// LIST
  final RxList<Map<String, dynamic>> categoryList =
      <Map<String, dynamic>>[].obs;

  /// EDIT DATA
  final RxMap<String, dynamic> editCategory = <String, dynamic>{}.obs;
  final RxList<Map<String, dynamic>> productList = <Map<String, dynamic>>[].obs;

  /// ================= LIST =================
  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      final response = await Backendservice.function(
        {},
        ConnectionService.categoryList,
        "GET",
      );

      if (response['status'] == true) {
        categoryList.value =
            List<Map<String, dynamic>>.from(response['category_list']);
      } else {
        categoryList.clear();
      }
    } finally {
      isLoading.value = false;
    }
  }

  // FETCH PRODUCT LIST
  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;

      final response = await Backendservice.function(
        {},
        ConnectionService.productList,
        "GET",
      );

      log("Product list Res :$response");

      if (response['status'] == true) {
        productList.value = (response['product_list'] as List)
            .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
            .toList();
      } else {
        productList.clear();
      }
    } catch (e) {
      debugPrint("Product API Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// ================= ADD CATEGORY =================
  Future<bool> addCategory({
    required String categoryName,
    required int productId,
    File? image,
  }) async {
    try {
      isLoading.value = true;

      // Prepare data for API
      final Map<String, dynamic> data = {
        'p_id': productId.toString(),
        'c_name': categoryName,
      };

      // Attach image if present
      if (image != null) {
        data['c_logo'] = image;
      }

      log("Add Category Data: $data");

      // Send to backend
      final result = await Backendservice.UploadFiles(
        data,
        ConnectionService.categoryStore,
        'POST',
      );

      log("Add Category Response: $result");

      if (result['success'] == true && result['data']?['status'] == true) {
        // Refresh category list
        await fetchCategories();
        return true;
      }

      return false;
    } catch (e) {
      log("Add Category Error: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// FETCH SINGLE CATEGORY FOR EDIT
  Future<void> fetchCategoryById(int id) async {
    try {
      isLoading.value = true;
      editCategory.clear();

      final response = await Backendservice.function(
        {'id': id.toString()},
        ConnectionService.categoryEdit,
        "POST",
      );

      log("Edit Category Response : $response");

      // Backend returns category details using 'category_details' (fallback to 'category')
      final details = response['category_details'] ?? response['category'];
      if (response['status'] == true && details != null) {
        editCategory.value = Map<String, dynamic>.from(details);
      }
    } catch (e) {
      debugPrint("Edit Category API Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Helper to find product id by its display name
  int? getProductIdByName(String? name) {
    if (name == null) return null;
    try {
      final match = productList.firstWhere(
        (e) => e['p_name']?.toString() == name,
        orElse: () => <String, dynamic>{},
      );
      if (match.isEmpty) return null;
      final idVal = match['id'];
      if (idVal is int) return idVal;
      return int.tryParse(idVal?.toString() ?? '');
    } catch (e) {
      return null;
    }
  }

  // / ================= UPDATE =================
  Future<bool> updateCategory({
    required int id,
    required String categoryName,
    required int productId,
    File? image,
  }) async {
    try {
      isLoading.value = true;

      final Map<String, dynamic> data = {
        'category_id': id.toString(),
        'product_drop': productId.toString(),
        'category_name': categoryName,
      };

      // Add image to map if present
      if (image != null) {
        data['category_logo'] = image;
      }

      log("Update Cat Data : $data");

      final result = await Backendservice.UploadFiles(
        data,
        ConnectionService.categoryUpdate,
        'POST',
      );

      log("Update response : $result");

      if (result['success'] == true && result['data']?['status'] == true) {
        await fetchCategories();
        return true;
      }
      return false;
    } catch (e) {
      log("Update error: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
