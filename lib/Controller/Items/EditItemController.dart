import 'dart:io';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mm_textiles_admin/Backendservice/BackendService.dart';
import 'package:mm_textiles_admin/Backendservice/connectionService.dart';
import 'package:mm_textiles_admin/Components/Snackbars.dart';
import 'package:mm_textiles_admin/Controller/Items/AddItemsController.dart';
import 'package:mm_textiles_admin/Controller/Items/ItemsListController.dart';

class EditItemController extends GetxController {
  final int itemId;

  EditItemController(this.itemId);

  /// ----------------------------
  /// LOADING STATES
  /// ----------------------------
  RxBool isLoading = false.obs;
  RxBool isUpdating = false.obs;

  /// ----------------------------
  /// FORM FIELDS
  /// ----------------------------
  final codeController = ''.obs;
  final subCategory = ''.obs;
  final selectedColor = ''.obs;
  final status = ''.obs;
  Rx<File?> selectedImage = Rx<File?>(null);
  RxString apiImageUrl = ''.obs;

  /// ----------------------------
  /// DROPDOWN OPTIONS (from AddItemsController)
  /// ----------------------------
  final AddItemsController addController = Get.find<AddItemsController>();
  RxList<Map<String, dynamic>> subCategories = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> colors = <Map<String, dynamic>>[].obs;

  final ImagePicker _picker = ImagePicker();

  /// ----------------------------
  /// INIT
  /// ----------------------------
  @override
  void onInit() {
    super.onInit();

    // Use AddItemsController dropdown data
    subCategories.value = addController.subCategories;
    colors.value = addController.colors;

    fetchItemDetails();
  }

  /// ----------------------------
  /// FETCH ITEM DETAILS
  /// ----------------------------
  Future<void> fetchItemDetails() async {
    try {
      isLoading.value = true;

      final response = await Backendservice.function(
        {'id': itemId},
        ConnectionService.editItem,
        'POST',
      );

      log("Item Edit Response: $response");

      if (response['status'] == true && response['item_details'] != null) {
        final item = response['item_details'];

        codeController.value = item['code']?.toString() ?? '';
        subCategory.value = item['subcategory_name'] ?? '';
        selectedColor.value = item['color_name'] ?? '';

        final String apiType = item['types'] ?? 'ready';
        status.value = apiType == 'ready' ? 'Ready' : 'Not Finished';

        /// ----------------------------
        /// IMAGE HANDLING
        /// ----------------------------
        final String imageUrl = item['i_logo']?.toString() ?? '';

        if (imageUrl.isNotEmpty &&
            !imageUrl.toLowerCase().contains('default.png')) {
          // Valid image from API
          apiImageUrl.value = imageUrl;
        } else {
          // default.png OR empty → treat as no image
          apiImageUrl.value = '';
        }

        // User-picked image always starts as null
        selectedImage.value = null;
      } else {
        CustomSnackbar("Error", "Failed to fetch item details");
      }
    } catch (e) {
      log("Error fetching item: $e");
      CustomErrorSnackbar();
    } finally {
      isLoading.value = false;
    }
  }

  /// ----------------------------
  /// HELPERS (NAME → ID)
  /// ----------------------------
  int? getSubCategoryId(String name) {
    try {
      return subCategories.firstWhere((e) => e['sc_name'] == name)['id'];
    } catch (_) {
      return null;
    }
  }

  int? getColorId(String name) {
    try {
      return colors.firstWhere((e) => e['co_name'] == name)['id'];
    } catch (_) {
      return null;
    }
  }

  /// ----------------------------
  /// IMAGE PICKER
  /// ----------------------------
  Future<void> pickImageFromCamera() async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (image != null) selectedImage.value = File(image.path);
  }

  Future<void> pickImageFromGallery() async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (image != null) selectedImage.value = File(image.path);
  }

  /// ----------------------------
  /// UPDATE ITEM (MULTIPART)
  /// ----------------------------
  Future<void> updateItem() async {
    try {
      isUpdating.value = true;

      final int? subId = getSubCategoryId(subCategory.value);
      final int? colorId = getColorId(selectedColor.value);

      if (subId == null || colorId == null) {
        CustomSnackbar("Error", "Invalid subcategory or color");
        return;
      }

      final Map<String, dynamic> data = {
        "item_id": itemId,
        "subcat_drop": subId,
        "item_code": codeController.value,
        "item_types": status.value == "Ready" ? "ready" : "not_finished",
        "item_color": colorId,
        if (selectedImage.value != null) "item_logo": selectedImage.value,
      };

      log("Update Data => $data");

      final response = await Backendservice.UploadFiles(
        data,
        ConnectionService.updateItem,
        "POST",
      );

      log("Update Response => $response");

      if (response['data']['status'] == true) {
        /// ✅ GO BACK TO LIST
        Get.back();
        refreshItemList();
        CustomSnackbar("Success", "Item updated successfully");
      } else {
        print(response['message'] ?? "Update failed");
      }
    } catch (e) {
      log("Error updating item: $e");
      CustomErrorSnackbar();
    } finally {
      isUpdating.value = false;
    }
  }

  void refreshItemList() {
    if (Get.isRegistered<ItemController>()) {
      Get.find<ItemController>().fetchItems();
    }
  }
}
