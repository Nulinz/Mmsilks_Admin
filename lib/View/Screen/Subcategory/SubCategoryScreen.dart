import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:mm_textiles_admin/Controller/SubCategory/SubCategoryListController.dart';
import 'package:mm_textiles_admin/Theme/Colors.dart';
import 'package:mm_textiles_admin/Theme/Fonts.dart';
import 'package:mm_textiles_admin/Theme/appTheme.dart';
import 'package:mm_textiles_admin/View/Screen/Subcategory/AddSubCategory.dart';
import 'package:mm_textiles_admin/View/Screen/Subcategory/EditSubcategory.dart';
import 'package:mm_textiles_admin/View/util/LoadingOverlay.dart';

class SubCategoryScreen extends StatefulWidget {
  const SubCategoryScreen({super.key});

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  final TextEditingController searchController = TextEditingController();
  final SubCategoryController controller = Get.put(SubCategoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppTheme.iconAppBarBackgroundless(
        title: Text(
          "Sub Category",
          style: AppTextStyles.heading.withColor(kPrimaryColor),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kPrimaryColor,
        onPressed: () {
          Get.to(() => const AddSubCategory());
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Add Sub Category",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          /// SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onChanged: controller.onSearch,
              decoration: InputDecoration(
                hintText: "Search subcategory...",
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

          /// LIST
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: LoadingProgress(),
                );
              }

              if (controller.filteredList.isEmpty) {
                return const Center(
                  child: Text("No sub categories found"),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.filteredList.length,
                itemBuilder: (context, index) {
                  final item = controller.filteredList[index];

                  return SubCategoryCard(
                    productName: item.productName,
                    categoryTitle: item.categoryName,
                    subCategoryName: item.subCategoryName,
                    priceA: item.priceAInt,
                    priceB: item.priceBInt,
                    priceC: item.priceCInt,
                    imageUrl: item.image,
                    itemCount: item.itemCount,
                    status: item.status,
                    onEdit: () {
                      Get.to(() => EditSubCategory(subCategoryId: item.id));
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

/// SUB CATEGORY CARD
class SubCategoryCard extends StatelessWidget {
  final String productName;
  final String categoryTitle;
  final String subCategoryName;

  /// Prices are flexible now
  final int? priceA;
  final int? priceB;
  final int? priceC;

  final String? imageUrl;
  final int itemCount;
  final String status;
  final VoidCallback? onEdit;

  const SubCategoryCard({
    super.key,
    required this.productName,
    required this.categoryTitle,
    required this.subCategoryName,
    this.priceA,
    this.priceB,
    this.priceC,
    this.imageUrl,
    required this.itemCount,
    required this.status,
    this.onEdit,
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
          /// IMAGE + EDIT + STATUS
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              children: [
                SizedBox(
                  height: 160,
                  width: double.infinity,
                  child: _buildImage(),
                ),

                /// EDIT ICON
                if (onEdit != null)
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

                /// STATUS
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isActive ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: AppTextStyles.title.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  categoryTitle,
                  style: AppTextStyles.small.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 6),
                Text(
                  subCategoryName,
                  style: AppTextStyles.small.copyWith(color: Colors.black87),
                ),
                const SizedBox(height: 10),

                /// PRICE & ITEM COUNT
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    if (priceA != null) _infoBox("Price A", priceA.toString()),
                    if (priceB != null) _infoBox("Price B", priceB.toString()),
                    if (priceC != null) _infoBox("Price C", priceC.toString()),
                    _infoBox("Items", itemCount.toString()),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// IMAGE HANDLER (NULL / EMPTY / ERROR SAFE)
  Widget _buildImage() {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return defaultCategoryAvatar();
    }

    return Image.network(
      imageUrl!,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => defaultCategoryAvatar(),
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  /// INFO BOX
  Widget _infoBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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

  /// DEFAULT PLACEHOLDER IMAGE
  static Widget defaultCategoryAvatar() {
    return Image.asset(
      "assets/Icons/Category_PlaceHolder.png",
      fit: BoxFit.cover,
    );
  }
}
