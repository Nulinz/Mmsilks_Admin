import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:mm_textiles_admin/Backendservice/BackendService.dart';
import 'package:mm_textiles_admin/Backendservice/connectionService.dart';
import 'package:mm_textiles_admin/Components/Snackbars.dart';
import 'package:mm_textiles_admin/Controller/SubCategory/SubCategoryListController.dart';

class AddSubCategoryController extends GetxController {
  final RxBool isLoading = false.obs;

  /// PRODUCT & CATEGORY LIST
  final RxList<Map<String, dynamic>> productList = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> categoryList =
      <Map<String, dynamic>>[].obs;

  /// SELECTED IDS
  final RxInt selectedProductId = 0.obs;
  final RxInt selectedCategoryId = 0.obs;

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  /// FETCH PRODUCTS
  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;

      final response = await Backendservice.function(
        {},
        ConnectionService.productList,
        "GET",
      );

      if (response['status'] == true) {
        productList.value =
            List<Map<String, dynamic>>.from(response['product_list']);
      }
    } catch (e) {
      log("Product API Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// FETCH CATEGORIES BY PRODUCT ID
  Future<void> fetchCategories(int productId) async {
    try {
      isLoading.value = true;

      final response = await Backendservice.function(
        {},
        "${ConnectionService.categoryDropList}?product_id=$productId",
        "GET",
      );

      if (response['status'] == "success") {
        categoryList.value =
            List<Map<String, dynamic>>.from(response['category']);
      } else {
        categoryList.clear();
      }
    } catch (e) {
      log("Category API Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// ADD SUB CATEGORY (MATCHES CURL)
  Future<void> addSubCategory({
    required String subCategoryName,
    required String catA,
    required String catB,
    required String catC,
    File? image,
    File? video,
  }) async {
    try {
      isLoading.value = true;

      final Map<String, dynamic> fields = {
        "p_id": selectedProductId.value.toString(),
        "c_id": selectedCategoryId.value.toString(),
        "sc_name": subCategoryName,
        "cat_a": "0",
        "cat_b": catB.isEmpty ? "0" : catB,
        "cat_c": catC.isEmpty ? "0" : catC,
      };

      final Map<String, File> files = {};

      if (image != null) files["sc_logo"] = image;
      if (video != null) files["sc_video"] = video;

      final response = await Backendservice.multipartFunction(
        fields,
        files,
        ConnectionService.addSubCategory,
      );

      if (response['status'] == true) {
        /// REFRESH SUBCATEGORY LIST
        if (Get.isRegistered<SubCategoryController>()) {
          Get.find<SubCategoryController>().fetchSubCategories();
        }

        Get.back();
        CustomSnackbar("Success", "Sub Category added successfully");
      } else {
        log(response['message'] ?? "Something went wrong");
      }
    } catch (e) {
      log("Add SubCategory Error: $e");
      CustomErrorSnackbar();
    } finally {
      isLoading.value = false;
    }
  }
}
