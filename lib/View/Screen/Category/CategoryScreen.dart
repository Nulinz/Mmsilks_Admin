import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:mm_textiles_admin/Controller/Category/CategoryListController.dart';
import 'package:mm_textiles_admin/Theme/Colors.dart';
import 'package:mm_textiles_admin/Theme/Fonts.dart';
import 'package:mm_textiles_admin/Theme/appTheme.dart';
import 'package:mm_textiles_admin/View/Screen/Category/AddCategoryScreen.dart';
import 'package:mm_textiles_admin/View/Screen/Category/EditCategoryScreen.dart';
import 'package:mm_textiles_admin/View/util/LoadingOverlay.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final CategoryController controller = Get.put(CategoryController());
  final TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> filteredList = [];

  @override
  void initState() {
    super.initState();

    controller.fetchCategories().then((_) {
      filteredList = controller.categoryList.toList();
      setState(() {});
    });

    // Keep filteredList in sync when the controller's data changes
    ever(controller.categoryList, (_) {
      filteredList = controller.categoryList.toList();
      setState(() {});
    });
  }

  void onSearch(String value) {
    if (value.isEmpty) {
      filteredList = controller.categoryList.toList();
    } else {
      filteredList = controller.categoryList.where((item) {
        final categoryName = item['name']?.toString().toLowerCase() ?? '';
        final productName =
            item['products']?['p_name']?.toString().toLowerCase() ?? '';
        final status =
            item['products']?['status']?.toString().toLowerCase() ?? '';

        return categoryName.contains(value.toLowerCase()) ||
            productName.contains(value.toLowerCase()) ||
            status.contains(value.toLowerCase());
      }).toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppTheme.iconAppBarBackgroundless(
        title: Text(
          "Category",
          style: AppTextStyles.heading.withColor(kPrimaryColor),
        ),
      ),

      /// ADD BUTTON
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kPrimaryColor,
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => const AddEditCategoryScreen(),
          );
        },
        icon: const Icon(Icons.add, color: whiteColor),
        label: const Text("Add Category", style: TextStyle(color: whiteColor)),
      ),

      body: Column(
        children: [
          /// SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onChanged: onSearch,
              decoration: InputDecoration(
                hintText: "Search category...",
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
                return const Center(child: LoadingProgress());
              }

              if (filteredList.isEmpty) {
                return const Center(child: Text("No categories found"));
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final item = filteredList[index];

                  return CategoryCard(
                    productName: item['products']?['p_name'] ?? '-',
                    categoryTitle: item['name'] ?? '-',
                    subCategoryCount: item['subcategory_count'] ?? 0,
                    status: item['products']?['status'] ?? '-',
                    imageUrl: item['c_logo'] ?? '',
                    onEdit: () {
                      final categoryId = item['id'];

                      if (!mounted) return;

                      // Open dialog immediately; EditCategoryScreen will fetch its data
                      try {
                        showDialog(
                          context: context,
                          useRootNavigator: true,
                          builder: (_) =>
                              EditCategoryScreen(categoryId: categoryId),
                        );
                      } catch (e) {
                        debugPrint('showDialog failed: $e');
                      }
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

class CategoryCard extends StatelessWidget {
  final String productName;
  final String categoryTitle;
  final int subCategoryCount;
  final String status;
  final String? imageUrl;
  final VoidCallback onEdit;

  const CategoryCard({
    super.key,
    required this.productName,
    required this.categoryTitle,
    required this.subCategoryCount,
    required this.status,
    required this.onEdit,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = status == "Active";

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
          /// IMAGE + EDIT BUTTON
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              children: [
                SizedBox(
                  height: 160,
                  width: double.infinity,
                  child: imageUrl != null && imageUrl!.isNotEmpty
                      ? Image.network(
                          imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            // If network image fails, show placeholder
                            return AppTheme.defaultCategoryAvatar();
                          },
                        )
                      : AppTheme
                          .defaultCategoryAvatar(), // If imageUrl is null or empty
                ),

                /// EDIT
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
                /// PRODUCT NAME (INCREASED SIZE)
                Text(
                  productName,
                  style: AppTextStyles.title.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  categoryTitle,
                  style: AppTextStyles.small.copyWith(color: Colors.grey),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: kPrimaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "$subCategoryCount Subcategories",
                        style: AppTextStyles.small.copyWith(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
