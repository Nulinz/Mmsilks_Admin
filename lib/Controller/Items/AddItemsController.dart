import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mm_textiles_admin/Backendservice/BackendService.dart';
import 'package:mm_textiles_admin/Backendservice/connectionService.dart';
import 'package:mm_textiles_admin/Components/Snackbars.dart';
import 'package:mm_textiles_admin/Controller/Items/ItemsListController.dart';

class AddItemsController extends GetxController {
  /// ----------------------------
  /// LOADING STATE
  /// ----------------------------
  RxBool isLoading = false.obs;

  /// ----------------------------
  /// DROPDOWN DATA (ID + NAME)
  /// ----------------------------
  RxList<Map<String, dynamic>> subCategories = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> colors = <Map<String, dynamic>>[].obs;

  /// ----------------------------
  /// IMAGE PICKER
  /// ----------------------------
  final ImagePicker _picker = ImagePicker();
  Rx<File?> selectedImage = Rx<File?>(null);

  Future<void> pickImageFromCamera() async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  Future<void> pickImageFromGallery() async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  /// ----------------------------
  /// FETCH DROPDOWNS
  /// ----------------------------
  Future<void> fetchDropdownData() async {
    try {
      isLoading.value = true;

      final response = await Backendservice.function(
        {},
        ConnectionService.dropdownList,
        "GET",
      );

      log("Dropdown Response => $response");

      if (response['status'] == 'success') {
        subCategories.value =
            List<Map<String, dynamic>>.from(response['subcategory']);
        colors.value = List<Map<String, dynamic>>.from(response['color']);
      }
    } catch (e) {
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

  List<int> getColorIds(List<String> names) {
    return colors
        .where((e) => names.contains(e['co_name']))
        .map((e) => e['id'] as int)
        .toList();
  }

  /// ----------------------------
  /// SAVE ITEM API (MULTIPART)
  /// ----------------------------
  Future<void> saveItem({
    required String subCategoryName,
    required List<String> colorNames,
    required String code,
    required String status,
    required File image,
  }) async {
    try {
      isLoading.value = true;

      final int? subId = getSubCategoryId(subCategoryName);

      // Pick the first color only (single selection expected by backend)
      final List<int> colorIds = getColorIds(colorNames);
      final int? colorId = colorIds.isNotEmpty ? colorIds.first : null;

      if (subId == null) {
        throw "Invalid Subcategory";
      }
      if (colorId == null) {
        throw "Invalid Color";
      }

      final Map<String, dynamic> data = {
        "sub_id": subId,
        "i_code": code,
        "types": status == "Ready" ? "ready" : "not_finished",
        "color": colorId, // <-- single value
        "i_logo": image, // <-- multipart file
      };

      log("Upload Data => $data");

      final response = await Backendservice.UploadFiles(
        data,
        ConnectionService.itemStore,
        "POST",
      );

      log("Save Response => $response");

      if (response['success'] == true) {
        final respData = response['data'];
        if (respData is Map<String, dynamic>) {
          final String message = respData['message']?.toString() ?? '';

          if (message == "Barcode already exists!") {
            CustomSnackbar("Oops!", "Code is Already Exists");
            return;
          }

          if (message.toLowerCase().contains("created") ||
              message.toLowerCase().contains("uploaded")) {
            if (Get.isRegistered<ItemController>()) {
              await Get.find<ItemController>().fetchItems();
            }
            Get.back();
            CustomSnackbar("Success", message);
            clearForm();
          }
        } else {
          print("Invalid server response");
        }
      } else {
        print("..Failed to upload item");
      }
    } catch (e) {
      log("Error : ${e.toString()}");
      CustomErrorSnackbar();
    } finally {
      isLoading.value = false;
    }
  }

  /// ----------------------------
  /// CLEAR FORM AFTER SUCCESS
  /// ----------------------------
  void clearForm() {
    selectedImage.value = null;
  }

  /// ----------------------------
  /// INIT
  /// ----------------------------
  @override
  void onInit() {
    super.onInit();
    fetchDropdownData();
  }
}
