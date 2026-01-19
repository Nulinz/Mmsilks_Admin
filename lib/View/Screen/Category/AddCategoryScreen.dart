import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:mm_textiles_admin/Components/Formfield.dart';
import 'package:mm_textiles_admin/Controller/Category/CategoryListController.dart';
import 'package:mm_textiles_admin/Theme/Colors.dart';
import 'package:mm_textiles_admin/Theme/Fonts.dart';
import 'package:mm_textiles_admin/View/Screen/Items/AddItems.dart';

class AddEditCategoryScreen extends StatefulWidget {
  const AddEditCategoryScreen({super.key});

  @override
  State<AddEditCategoryScreen> createState() => _AddEditCategoryScreenState();
}

class _AddEditCategoryScreenState extends State<AddEditCategoryScreen> {
  final _formKey = GlobalKey<FormState>();

  /// Get controller
  final CategoryController controller = Get.find();

  /// Dropdown product value
  String? selectedProduct;
  int? productId;

  /// Category controller
  late TextEditingController categoryController;

  /// Picked image
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    categoryController = TextEditingController(text: "");

    // Defer fetching products until after the first frame to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchProducts();
    });
  }

  @override
  void dispose() {
    categoryController.dispose();
    super.dispose();
  }

  List<String> get productDropdownList {
    return controller.productList.map((e) => e['p_name'].toString()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: whiteColor,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Add Category",
                      style: AppTextStyles.heading,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, size: 22),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                /// PRODUCT DROPDOWN
                Obx(() {
                  return DropdownInput(
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
                  );
                }),

                const SizedBox(height: 16),

                /// CATEGORY FIELD
                TextInput(
                  LabelText: "Category",
                  Controller: categoryController,
                  HintText: "Enter category name",
                  ValidatorText: "Category is required",
                  onChanged: (_) {},
                ),

                const SizedBox(height: 20),

                /// IMAGE PICKER
                ImagePickerFormField(
                  labelText: "Category Image",
                  initialValue: selectedImage,
                  validationRequired: true,
                  onChanged: (file) {
                    setState(() => selectedImage = file);
                  },
                ),

                const SizedBox(height: 30),

                /// SUBMIT BUTTON
                Center(
                  child: SizedBox(
                    width: 180,
                    height: 48,
                    child: Obx(() {
                      return ElevatedButton(
                        onPressed:
                            controller.isLoading.value ? null : _onSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: controller.isLoading.value
                            ? const SpinKitThreeBounce(
                                size: 10,
                                color: Colors.white,
                              )
                            : Text(
                                "Save",
                                style: AppTextStyles.title
                                    .copyWith(color: Colors.white),
                              ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// SUBMIT HANDLER
  void _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedProduct == null || productId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a valid product")),
      );
      return;
    }

    final success = await controller.addCategory(
      categoryName: categoryController.text.trim(),
      productId: productId!,
      image: selectedImage,
    );

    if (success) {
      Navigator.pop(context); // Close dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Category added successfully")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to add category")),
      );
    }
  }
}
