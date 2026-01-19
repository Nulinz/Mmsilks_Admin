import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:mm_textiles_admin/Controller/Category/CategoryListController.dart';
import 'package:mm_textiles_admin/Components/Formfield.dart';
import 'package:mm_textiles_admin/Theme/Colors.dart';
import 'package:mm_textiles_admin/Theme/Fonts.dart';
import 'package:mm_textiles_admin/View/Screen/Items/AddItems.dart';
import 'package:mm_textiles_admin/View/util/LoadingOverlay.dart';

class EditCategoryScreen extends StatefulWidget {
  final int categoryId;

  const EditCategoryScreen({super.key, required this.categoryId});

  @override
  State<EditCategoryScreen> createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  final CategoryController controller = Get.find();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController categoryController = TextEditingController();

  String? selectedProduct;
  int? productId;
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    // Defer network calls until after the first frame to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchProducts();
      controller.fetchCategoryById(widget.categoryId);
    });
  }

  List<String> get productDropdownList {
    return controller.productList.map((e) => e['p_name'].toString()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: whiteColor,
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Obx(() {
          if (controller.isLoading.value && controller.editCategory.isEmpty) {
            return const SizedBox(
              height: 200,
              child: Center(child: LoadingProgress()),
            );
          }

          final data = controller.editCategory;

          /// Bind once
          if (categoryController.text.isEmpty && data.isNotEmpty) {
            categoryController.text = data['c_name'] ?? '';
            selectedProduct = data['product_name'];
            productId = int.tryParse(data['product_id'].toString());
          }

          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Edit Category', style: AppTextStyles.heading),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  /// PRODUCT DROPDOWN
                  DropdownInput(
                    LabelText: 'Product',
                    hintText: 'Select product',
                    validatorText: 'Product required',
                    dropdownList: productDropdownList,
                    dropdownValue: selectedProduct,
                    validationRequired: true,
                    onChanged: (value) {
                      setState(() {
                        selectedProduct = value;
                        productId = controller.getProductIdByName(value);
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  /// CATEGORY FIELD
                  TextInput(
                    LabelText: 'Category',
                    Controller: categoryController,
                    HintText: 'Enter category name',
                    ValidatorText: 'Category required',
                    onChanged: (_) {},
                  ),

                  const SizedBox(height: 16),

                  /// EXISTING IMAGE
                  if (data['c_logo'] != null && selectedImage == null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        data['c_logo'],
                        height: 140,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _defaultCategoryAvatar(),
                      ),
                    ),

                  const SizedBox(height: 12),

                  /// IMAGE PICKER
                  ImagePickerFormField(
                    labelText: 'Replace Image',
                    validationRequired: false,
                    onChanged: (file) => setState(() => selectedImage = file),
                  ),

                  const SizedBox(height: 30),

                  /// UPDATE BUTTON
                  Center(
                    child: SizedBox(
                      width: 180,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () async {
                                if (!_formKey.currentState!.validate()) return;

                                final int? finalProductId = productId ??
                                    controller
                                        .getProductIdByName(selectedProduct);

                                if (finalProductId == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Please select a product')),
                                  );
                                  return;
                                }

                                final success = await controller.updateCategory(
                                  id: widget.categoryId,
                                  categoryName: categoryController.text.trim(),
                                  productId: finalProductId,
                                  image: selectedImage,
                                );

                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Category updated successfully')),
                                  );
                                  Navigator.pop(context);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Failed to update category')),
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                        ),
                        child: controller.isLoading.value
                            ? const SpinKitThreeBounce(
                                size: 10,
                                color: Colors.white,
                              )
                            : const Text(
                                'Update',
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _defaultCategoryAvatar() {
    return Image.asset(
      'assets/Icons/Category_PlaceHolder.png',
      height: 140,
      fit: BoxFit.cover,
    );
  }
}
