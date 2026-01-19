// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mm_textiles_admin/Components/Formfield.dart';
// import 'package:mm_textiles_admin/Theme/Colors.dart';
// import 'package:mm_textiles_admin/Theme/Fonts.dart';
// import 'package:mm_textiles_admin/Theme/appTheme.dart';
// import 'package:mm_textiles_admin/View/Screen/Items/AddItems.dart';
// import 'package:mm_textiles_admin/View/widgets/VideoPickerFormField.dart';

// class AddSubCategory extends StatefulWidget {
//   const AddSubCategory({super.key});

//   @override
//   State<AddSubCategory> createState() => _AddSubCategoryState();
// }

// class _AddSubCategoryState extends State<AddSubCategory> {
//   final _formKey = GlobalKey<FormState>();

//   // Controllers
//   final TextEditingController productController = TextEditingController();

//   final TextEditingController subCategoryController = TextEditingController();

//   final TextEditingController categoryAController =
//       TextEditingController(text: "0");

//   final TextEditingController categoryBController = TextEditingController();

//   final TextEditingController categoryCController = TextEditingController();

//   // Dropdown value
//   final RxString selectedCategory = "".obs;

//   // Product dropdown value
//   final RxString selectedProduct = "".obs;

//   /// Image
//   File? selectedImage;

//   /// Video
//   File? selectedVideo;

// // Dummy product list
//   final List<String> productList = [
//     "Cotton",
//     "Silk",
//     "Polyester",
//   ];

//   // Dummy category list
//   final List<String> categoryList = [
//     "Chennai",
//     "Bangalore",
//     "Hyderabad",
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: whiteColor,
//       appBar: AppTheme.iconAppBarBackgroundless(
//         title: Text(
//           "Add Sub Category",
//           style: AppTextStyles.subHeading,
//         ),
//       ),
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               /// Product
//               /// Product (Dropdown)
//               Obx(
//                 () => DropdownInput(
//                   LabelText: "Product",
//                   hintText: "Select Product",
//                   validatorText: "Product is required",
//                   dropdownList: productList,
//                   dropdownValue: selectedProduct.value.isEmpty
//                       ? null
//                       : selectedProduct.value,
//                   onChanged: (value) {
//                     selectedProduct.value = value ?? "";
//                   },
//                 ),
//               ),

//               const SizedBox(height: 16),

//               /// Category (Dropdown)
//               Obx(
//                 () => DropdownInput(
//                   LabelText: "Category",
//                   hintText: "Select Category",
//                   validatorText: "Category is required",
//                   dropdownList: categoryList,
//                   dropdownValue: selectedCategory.value.isEmpty
//                       ? null
//                       : selectedCategory.value,
//                   onChanged: (value) {
//                     selectedCategory.value = value ?? "";
//                   },
//                 ),
//               ),

//               const SizedBox(height: 16),

//               /// Sub Category
//               TextInput(
//                 LabelText: "Sub Category",
//                 HintText: "Enter Sub Category",
//                 ValidatorText: "Sub Category is required",
//                 Controller: subCategoryController,
//                 onChanged: (_) {},
//               ),

//               const SizedBox(height: 16),

//               /// Category A
//               TextInput(
//                 LabelText: "Category A",
//                 HintText: "Enter value",
//                 ValidatorText: "",
//                 validationRequired: false,
//                 Controller: categoryAController,
//                 onChanged: (_) {},
//               ),

//               const SizedBox(height: 16),

//               /// Category B
//               TextInput(
//                 LabelText: "Category B",
//                 HintText: "Enter value",
//                 ValidatorText: "",
//                 validationRequired: false,
//                 Controller: categoryBController,
//                 onChanged: (_) {},
//               ),

//               const SizedBox(height: 16),

//               /// Category C
//               TextInput(
//                 LabelText: "Category C",
//                 HintText: "Enter value",
//                 ValidatorText: "",
//                 validationRequired: false,
//                 Controller: categoryCController,
//                 onChanged: (_) {},
//               ),

//               const SizedBox(height: 16),

//               /// IMAGE PICKER
//               ImagePickerFormField(
//                 labelText: "SubCategory Image",
//                 initialValue: selectedImage,
//                 validationRequired: true,
//                 onChanged: (file) => selectedImage = file,
//               ),

//               const SizedBox(height: 16),

//               /// VIDEO PICKER
//               VideoPickerFormField(
//                 labelText: "SubCategory Video",
//                 initialValue: selectedVideo,
//                 validationRequired: false,
//                 onChanged: (file) => selectedVideo = file,
//               ),

//               const SizedBox(height: 24),

//               /// Save Button
//               SizedBox(
//                 width: double.infinity,
//                 height: 48,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   onPressed: () {
//                     if (_formKey.currentState!.validate()) {}
//                   },
//                   child: const Text(
//                     "Update",
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: whiteColor,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:mm_textiles_admin/Components/Formfield.dart';
import 'package:mm_textiles_admin/Controller/SubCategory/AddSubCategoryController.dart';
import 'package:mm_textiles_admin/Theme/Colors.dart';
import 'package:mm_textiles_admin/Theme/Fonts.dart';
import 'package:mm_textiles_admin/Theme/appTheme.dart';
import 'package:mm_textiles_admin/View/Screen/Items/AddItems.dart';
import 'package:mm_textiles_admin/View/widgets/VideoPickerFormField.dart';

class AddSubCategory extends StatefulWidget {
  const AddSubCategory({super.key});

  @override
  State<AddSubCategory> createState() => _AddSubCategoryState();
}

class _AddSubCategoryState extends State<AddSubCategory> {
  final _formKey = GlobalKey<FormState>();

  final AddSubCategoryController controller =
      Get.put(AddSubCategoryController());

  /// TEXT CONTROLLERS
  final TextEditingController subCategoryController = TextEditingController();
  final TextEditingController categoryAController =
      TextEditingController(text: "0");
  final TextEditingController categoryBController = TextEditingController();
  final TextEditingController categoryCController = TextEditingController();

  /// FILES
  File? selectedImage;
  File? selectedVideo;

  @override
  void initState() {
    super.initState();
    categoryAController.text = "0";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppTheme.iconAppBarBackgroundless(
        title: Text("Add Sub Category", style: AppTextStyles.subHeading),
      ),
      body: Obx(
        () => Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                /// PRODUCT DROPDOWN
                DropdownInput(
                  LabelText: "Product",
                  hintText: "Select Product",
                  validatorText: "Product is required",
                  dropdownList: controller.productList
                      .map((e) => e['p_name'].toString())
                      .toList(),
                  dropdownValue: controller.selectedProductId.value == 0
                      ? null
                      : controller.productList.firstWhere((e) =>
                          e['id'] ==
                          controller.selectedProductId.value)['p_name'],
                  onChanged: (value) {
                    final selected = controller.productList
                        .firstWhere((e) => e['p_name'] == value);

                    controller.selectedProductId.value = selected['id'];
                    controller.fetchCategories(selected['id']);
                    controller.selectedCategoryId.value = 0;
                  },
                ),

                const SizedBox(height: 16),

                /// CATEGORY DROPDOWN
                DropdownInput(
                  LabelText: "Category",
                  hintText: "Select Category",
                  validatorText: "Category is required",
                  dropdownList: controller.categoryList
                      .map((e) => e['c_name'].toString())
                      .toList(),
                  dropdownValue: controller.selectedCategoryId.value == 0
                      ? null
                      : controller.categoryList.firstWhere((e) =>
                          e['id'] ==
                          controller.selectedCategoryId.value)['c_name'],
                  onChanged: (value) {
                    final selected = controller.categoryList
                        .firstWhere((e) => e['c_name'] == value);

                    controller.selectedCategoryId.value = selected['id'];
                  },
                ),

                const SizedBox(height: 16),

                /// SUB CATEGORY NAME
                TextInput(
                  LabelText: "Sub Category",
                  HintText: "Enter Sub Category",
                  ValidatorText: "Sub Category is required",
                  Controller: subCategoryController,
                  onChanged: (_) {},
                ),

                const SizedBox(height: 16),

                NumberInput(
                  LabelText: "Category A",
                  HintText: "0",
                  validationRequired: true,
                  Controller: categoryAController,
                  onChanged: (_) {},
                  readOnly: true,
                  ValidatorText: '',
                ),

                const SizedBox(height: 16),

                NumberInput(
                  LabelText: "Category B",
                  HintText: "Enter value",
                  validationRequired: true,
                  Controller: categoryBController,
                  onChanged: (_) {},
                  ValidatorText: '',
                ),

                const SizedBox(height: 16),

                NumberInput(
                  LabelText: "Category C",
                  HintText: "Enter value",
                  validationRequired: true,
                  Controller: categoryCController,
                  onChanged: (_) {},
                  ValidatorText: '',
                ),

                const SizedBox(height: 16),

                /// IMAGE PICKER
                ImagePickerFormField(
                  labelText: "SubCategory Image",
                  initialValue: selectedImage,
                  validationRequired: true,
                  onChanged: (file) => selectedImage = file,
                ),

                const SizedBox(height: 16),

                /// VIDEO PICKER
                VideoPickerFormField(
                  labelText: "Sub Category Video",
                  validationRequired: false,
                  onChanged: (file) {
                    selectedVideo = file;
                  },
                ),

                const SizedBox(height: 24),

                /// SAVE BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              controller.addSubCategory(
                                subCategoryName:
                                    subCategoryController.text.trim(),
                                catA: categoryAController.text.trim(),
                                catB: categoryBController.text.trim(),
                                catC: categoryCController.text.trim(),
                                image: selectedImage,
                                video: selectedVideo,
                              );
                            }
                          },
                    child: controller.isLoading.value
                        ? SpinKitThreeBounce(
                            size: 10.r,
                            color: whiteColor,
                          )
                        : const Text(
                            "Save",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: whiteColor,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
