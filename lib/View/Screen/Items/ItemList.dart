import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:mm_textiles_admin/Controller/Items/ItemsListController.dart';
import 'package:mm_textiles_admin/Theme/Colors.dart';
import 'package:mm_textiles_admin/Theme/Fonts.dart';
import 'package:mm_textiles_admin/Theme/appTheme.dart';
import 'package:mm_textiles_admin/View/Screen/Items/AddItems.dart';
import 'package:mm_textiles_admin/View/Screen/Items/EditList.dart';

class ItemListScreen extends StatefulWidget {
  const ItemListScreen({super.key});

  @override
  State<ItemListScreen> createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  final ItemController controller = Get.put(ItemController());
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.fetchItems();
  }

  Future<void> _refreshItems() async {
    await controller.fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppTheme.iconAppBarBackgroundless(
        title: Text(
          "Items",
          style: AppTextStyles.heading.withColor(kPrimaryColor),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kPrimaryColor,
        onPressed: () {
          Get.to(() => const AddItemsScreen());
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add Items", style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          /// SEARCH FIELD
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onChanged: controller.searchItems,
              decoration: InputDecoration(
                hintText: "Search items...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: greyColor40,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          /// ITEM LIST WITH PULL TO REFRESH
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredList.isEmpty) {
                return RefreshIndicator(
                  onRefresh: _refreshItems,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(height: 200),
                      Center(child: Text("No items found")),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: _refreshItems,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.filteredList.length,
                  itemBuilder: (context, index) {
                    final item = controller.filteredList[index];
                    return ItemCard(
                      subCategory: item['sub_category'],
                      code: item['code'],
                      imageUrl: item['image'],
                      status: item['status'],
                      onEdit: () {
                        Get.to(() => EditItemsScreen(itemId: item['id']));
                      },
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final String subCategory;
  final String code;
  final String? imageUrl;
  final String status;
  final VoidCallback onEdit;

  const ItemCard({
    super.key,
    required this.subCategory,
    required this.code,
    this.imageUrl,
    required this.status,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = status.toLowerCase() == "active";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE + ACTIONS
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              children: [
                SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: (imageUrl != null && imageUrl!.isNotEmpty)
                      ? Image.network(
                          imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            // fallback if network image fails
                            return AppTheme.defaultCategoryAvatar();
                          },
                        )
                      : AppTheme.defaultCategoryAvatar(),
                ),

                /// STATUS
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: _statusBadge(isActive),
                ),

                /// ACTIONS
                Positioned(
                  top: 10,
                  right: 10,
                  child: InkWell(
                    onTap: onEdit,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: blackColor60,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Iconsax.edit_copy,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// CONTENT
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// LEFT : SUB CATEGORY
                Expanded(
                  child: Text(
                    subCategory,
                    style: AppTextStyles.title.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                const SizedBox(width: 12),

                /// RIGHT : CODE CHIP
                _infoChip("Code", code),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: kPrimaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "$label: $value",
        style: AppTextStyles.small.copyWith(
          color: kPrimaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _statusBadge(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isActive ? "Active" : "Inactive",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
