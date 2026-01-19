import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:mm_textiles_admin/Backendservice/BackendService.dart';
import 'package:mm_textiles_admin/Backendservice/connectionService.dart';
import 'package:mm_textiles_admin/Components/Snackbars.dart';
import 'package:mm_textiles_admin/Controller/SubCategory/SubCategoryListController.dart';

class EditSubCategoryController extends GetxController {
  final RxBool isLoading = false.obs;

  /// PRODUCT & CATEGORY LIST
  final RxList<Map<String, dynamic>> productList = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> categoryList =
      <Map<String, dynamic>>[].obs;

  /// SELECTED IDS
  final RxInt selectedProductId = 0.obs;
  final RxInt selectedCategoryId = 0.obs;

  /// FORM VALUES
  final RxString subCategoryName = "".obs;
  final RxString catA = "0".obs;
  final RxString catB = "".obs;
  final RxString catC = "".obs;

  /// MEDIA
  File? selectedImage;
  File? selectedVideo;
  final RxString imageUrl = "".obs;
  final RxString videoUrl = "".obs;

  /// CURRENT SUBCATEGORY ID
  int subCategoryId = 0;

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

  /// FETCH CATEGORIES BY PRODUCT
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

  /// FETCH SUBCATEGORY DETAILS
  Future<void> fetchSubCategoryDetails(int id) async {
    try {
      isLoading.value = true;
      subCategoryId = id;
      final response = await Backendservice.function(
        {},
        "${ConnectionService.subcategoryEdit}?id=$id",
        "POST",
      );

      if (response['status'] == true) {
        final data = response['subcategory_details'];

        selectedProductId.value = int.parse(data['product_id'].toString());
        selectedCategoryId.value = int.parse(data['category_id'].toString());

        subCategoryName.value = data['subcategory_name'] ?? "";
        catA.value = data['cat_a'] ?? "0";
        catB.value = data['cat_b'] ?? "";
        catC.value = data['cat_c'] ?? "";

        imageUrl.value =
            data['sc_logo'] != null ? data['sc_logo'].toString() : "";

        videoUrl.value =
            data['sc_video'] != null ? data['sc_video'].toString() : "";

        /// Load categories for selected product
        await fetchCategories(selectedProductId.value);
      }
    } catch (e) {
      log("SubCategory Edit API Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// UPDATE SUBCATEGORY (multipart)
  Future<void> updateSubCategory() async {
    if (selectedProductId.value == 0 || selectedCategoryId.value == 0) {
      CustomSnackbar("Error", "Please select a product and category");
      return;
    }

    try {
      isLoading.value = true;

      // Fields matching your cURL example
      final Map<String, String> fields = {
        "subcategory_id": subCategoryId.toString(),
        "product_drop": selectedProductId.value.toString(),
        "cat_drop": selectedCategoryId.value.toString(),
        "subcategory_name": subCategoryName.value,
        "catprice_a": catA.value.isEmpty ? "0" : catA.value,
        "catprice_b": catB.value.isEmpty ? "0" : catB.value,
        "catprice_c": catC.value.isEmpty ? "0" : catC.value,
      };

      // Files
      final Map<String, File> files = {};
      if (selectedImage != null) files["subcategory_logo"] = selectedImage!;
      if (selectedVideo != null) files["subcategory_video"] = selectedVideo!;

      final response = await Backendservice.multipartFunction(
        fields,
        files,
        ConnectionService.subcategoryUpdate,
      );

      if (response['status'] == true) {
        // Refresh subcategory list if controller exists
        if (Get.isRegistered<SubCategoryController>()) {
          Get.find<SubCategoryController>().fetchSubCategories();
        }

        Get.back(); // Go back after success
        CustomSnackbar("Success", "Sub Category updated successfully");
      } else {
        log(response['message'] ?? "Something went wrong");
      }
    } catch (e) {
      log("Update SubCategory Error: $e");
      CustomErrorSnackbar();
    } finally {
      isLoading.value = false;
    }
  }
}
