import 'package:get/get.dart';
import 'package:mm_textiles_admin/Backendservice/BackendService.dart';
import 'package:mm_textiles_admin/Backendservice/connectionService.dart';
import 'package:mm_textiles_admin/Components/Snackbars.dart';

class ItemController extends GetxController {
  // Loading indicator
  final RxBool isLoading = false.obs;

  // List of items fetched from API
  final RxList<Map<String, dynamic>> itemList = <Map<String, dynamic>>[].obs;

  // For filtered list based on search
  final RxList<Map<String, dynamic>> filteredList =
      <Map<String, dynamic>>[].obs;

  // Fetch items from API
  Future<void> fetchItems() async {
    try {
      isLoading.value = true;

      final response = await Backendservice.function(
        {}, // No POST data for GET
        ConnectionService.itemList,
        'GET',
      );

      if (response['status'] == true &&
          response['subcategory_details'] != null) {
        List<Map<String, dynamic>> items = [];

        for (var item in response['subcategory_details']) {
          items.add({
            "id": item['id'],
            "sub_category": item['subcategory']?['p_name'] ?? "No Name",
            "code": item['item_code'] ?? "N/A",
            "image": item['item_logo'] ?? "",
            "status": item['item_status'] ?? "Inactive",
            "color": item['color'] != null ? item['color']['c_name'] : null,
          });
        }

        itemList.value = items;
        filteredList.value = items;
      } else {
        itemList.clear();
        filteredList.clear();
        print("No items found");
      }
    } catch (e) {
      print("❌ Fetch Items Error: $e");
      CustomErrorSnackbar();
    } finally {
      isLoading.value = false;
    }
  }

  // Search functionality
  void searchItems(String query) {
    if (query.isEmpty) {
      filteredList.value = List.from(itemList);
    } else {
      final lowerQuery = query.toLowerCase();

      filteredList.value = itemList.where((item) {
        final itemCode = item['code']?.toString().toLowerCase() ?? '';

        final itemStatus = item['status']?.toString().toLowerCase() ?? '';

        final subCategory =
            item['sub_category']?.toString().toLowerCase() ?? '';

        final color = item['color']?.toString().toLowerCase() ?? '';

        return itemCode.contains(lowerQuery) ||
            itemStatus.contains(lowerQuery) ||
            subCategory.contains(lowerQuery) ||
            color.contains(lowerQuery);
      }).toList();
    }
  }
}
