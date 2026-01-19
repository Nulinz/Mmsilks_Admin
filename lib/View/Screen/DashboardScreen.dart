import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:mm_textiles_admin/Theme/Colors.dart';
import 'package:mm_textiles_admin/Theme/Fonts.dart';
import 'package:mm_textiles_admin/Theme/appTheme.dart';
import 'package:mm_textiles_admin/View/Screen/Category/CategoryScreen.dart';
import 'package:mm_textiles_admin/View/Screen/Items/ItemList.dart';
import 'package:mm_textiles_admin/View/Screen/Subcategory/SubCategoryScreen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTheme.iconAppBarBackgroundless(
        title: Text(
          "MM TEXTILES",
          style: AppTextStyles.heading.withColor(kPrimaryColor),
        ),
        centerTitle: true,
        implyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DashboardTile(
              title: "Category",
              subtitle: "Manage all categories",
              icon: Iconsax.category_2_copy,
              color: kPrimaryColor,
              onTap: () {
                Get.to(() => const CategoryScreen());
              },
            ),
            const SizedBox(height: 14),
            DashboardTile(
              title: "Sub Category",
              subtitle: "Manage sub categories",
              icon: Iconsax.subtitle,
              color: kPrimaryColor,
              onTap: () {
                Get.to(() => const SubCategoryScreen());
              },
            ),
            const SizedBox(height: 14),
            DashboardTile(
              title: "Items",
              subtitle: "Manage product items",
              icon: Iconsax.image,
              color: kPrimaryColor,
              onTap: () {
                Get.to(() => ItemListScreen());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const DashboardTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            /// Color strip
            Container(
              width: 6,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(14),
                ),
              ),
            ),

            const SizedBox(width: 16),

            /// Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.15),
              ),
              child: Icon(
                icon,
                size: 28,
                color: color,
              ),
            ),

            const SizedBox(width: 16),

            /// Text
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.title.bold,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.label.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            /// Arrow
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
