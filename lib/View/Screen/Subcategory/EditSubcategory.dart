import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:mm_textiles_admin/Components/Formfield.dart';
import 'package:mm_textiles_admin/Controller/SubCategory/EditSubCategoryController.dart';
import 'package:mm_textiles_admin/Theme/Colors.dart';
import 'package:mm_textiles_admin/Theme/Fonts.dart';
import 'package:mm_textiles_admin/Theme/appTheme.dart';
import 'package:mm_textiles_admin/View/Screen/Items/AddItems.dart';
import 'package:mm_textiles_admin/View/util/LoadingOverlay.dart';
import 'package:mm_textiles_admin/View/widgets/VideoPickerFormField.dart';

class EditSubCategory extends StatefulWidget {
  final int subCategoryId;

  const EditSubCategory({super.key, required this.subCategoryId});

  @override
  State<EditSubCategory> createState() => _EditSubCategoryState();
}

class _EditSubCategoryState extends State<EditSubCategory> {
  final _formKey = GlobalKey<FormState>();

  final EditSubCategoryController controller =
      Get.put(EditSubCategoryController());

  /// TEXT CONTROLLERS
  final TextEditingController subCategoryController = TextEditingController();
  final TextEditingController categoryAController = TextEditingController();
  final TextEditingController categoryBController = TextEditingController();
  final TextEditingController categoryCController = TextEditingController();

  /// FILES
  File? selectedImage;
  File? selectedVideo;

  @override
  void initState() {
    super.initState();

    /// Listen to changes and update TextFields automatically
    ever(controller.subCategoryName, (val) {
      subCategoryController.text = val;
    });
    ever(controller.catA, (val) {
      categoryAController.text = val;
    });
    ever(controller.catB, (val) {
      categoryBController.text = val;
    });
    ever(controller.catC, (val) {
      categoryCController.text = val;
    });

    // Fetch subcategory details
    controller.fetchSubCategoryDetails(widget.subCategoryId).then((_) {
      // If already existing image/video, show filename
      if (controller.imageUrl.value.isNotEmpty) {
        selectedImage =
            File(controller.imageUrl.value); // Just to show filename
      }
      if (controller.videoUrl.value.isNotEmpty) {
        selectedVideo =
            File(controller.videoUrl.value); // Just to show filename
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppTheme.iconAppBarBackgroundless(
        title: Text("Edit Sub Category", style: AppTextStyles.subHeading),
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: LoadingProgress())
            : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      /// PRODUCT DROPDOWN
                      Obx(() => DropdownInput(
                            LabelText: "Product",
                            hintText: "Select Product",
                            validatorText: "Product is required",
                            dropdownList: controller.productList
                                .map((e) => e['p_name'].toString())
                                .toList(),
                            dropdownValue: controller.selectedProductId.value ==
                                    0
                                ? null
                                : controller.productList.firstWhere(
                                    (e) =>
                                        e['id'] ==
                                        controller.selectedProductId.value,
                                    orElse: () => {'p_name': null})['p_name'],
                            onChanged: (value) {
                              final selected = controller.productList
                                  .firstWhere((e) => e['p_name'] == value,
                                      orElse: () => {});
                              if (selected.isNotEmpty) {
                                controller.selectedProductId.value =
                                    selected['id'];
                                controller.fetchCategories(selected['id']);
                                controller.selectedCategoryId.value = 0;
                              }
                            },
                          )),

                      const SizedBox(height: 16),

                      /// CATEGORY DROPDOWN
                      Obx(() => DropdownInput(
                            LabelText: "Category",
                            hintText: "Select Category",
                            validatorText: "Category is required",
                            dropdownList: controller.categoryList
                                .map((e) => e['c_name'].toString())
                                .toList(),
                            dropdownValue:
                                controller.selectedCategoryId.value == 0
                                    ? null
                                    : controller.categoryList.firstWhere(
                                        (e) =>
                                            e['id'] ==
                                            controller.selectedCategoryId.value,
                                        orElse: () =>
                                            {'c_name': null})['c_name'],
                            onChanged: (value) {
                              final selected = controller.categoryList
                                  .firstWhere((e) => e['c_name'] == value,
                                      orElse: () => {});
                              if (selected.isNotEmpty) {
                                controller.selectedCategoryId.value =
                                    selected['id'];
                              }
                            },
                          )),

                      const SizedBox(height: 16),

                      /// SUB CATEGORY NAME
                      TextInput(
                        LabelText: "Sub Category",
                        HintText: "Enter Sub Category",
                        ValidatorText: "Sub Category is required",
                        Controller: subCategoryController,
                        onChanged: (val) =>
                            controller.subCategoryName.value = val,
                      ),

                      const SizedBox(height: 16),

                      /// CATEGORY A
                      NumberInput(
                        LabelText: "Category A",
                        HintText: "0",
                        validationRequired: true,
                        Controller: categoryAController,
                        onChanged: (val) => controller.catA.value = val,
                        readOnly: true,
                        ValidatorText: '',
                      ),

                      const SizedBox(height: 16),

                      /// CATEGORY B
                      NumberInput(
                        LabelText: "Category B",
                        HintText: "Enter value",
                        validationRequired: true,
                        Controller: categoryBController,
                        onChanged: (val) => controller.catB.value = val,
                        ValidatorText: '',
                      ),

                      const SizedBox(height: 16),

                      /// CATEGORY C
                      NumberInput(
                        LabelText: "Category C",
                        HintText: "Enter value",
                        validationRequired: true,
                        Controller: categoryCController,
                        onChanged: (val) => controller.catC.value = val,
                        ValidatorText: '',
                      ),

                      const SizedBox(height: 16),

                      /// IMAGE PICKER
                      ImagePickerFormField(
                        labelText: "SubCategory Image",
                        initialValue: selectedImage,
                        validationRequired: false,
                        onChanged: (file) {
                          controller.selectedImage = file;
                          setState(() {});
                        },
                      ),

                      const SizedBox(height: 8),

// File name card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.image,
                                color: Colors.blueAccent, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                // Determine what to show
                                () {
                                  if (controller.selectedImage != null) {
                                    return controller.selectedImage!.path
                                        .split('/')
                                        .last;
                                  } else if (controller
                                          .imageUrl.value.isNotEmpty &&
                                      !controller.imageUrl.value
                                          .toLowerCase()
                                          .contains('default.png')) {
                                    return controller.imageUrl.value
                                        .split('/')
                                        .last;
                                  } else {
                                    return "No image selected";
                                  }
                                }(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// VIDEO PICKER
                      VideoPickerFormField(
                        labelText: "SubCategory Video",
                        initialValue: selectedVideo,
                        validationRequired: false,
                        onChanged: (file) {
                          controller.selectedVideo = file;
                          setState(() {});
                        },
                      ),

                      const SizedBox(height: 8),

// Video file name card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.videocam,
                                color: Colors.redAccent, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                controller.selectedVideo != null
                                    ? controller.selectedVideo!.path
                                        .split('/')
                                        .last
                                    : controller.videoUrl.value.isNotEmpty
                                        ? controller.videoUrl.value
                                            .split('/')
                                            .last
                                        : "No video selected",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// UPDATE BUTTON
                      SafeArea(
                        child: SizedBox(
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
                                      controller.updateSubCategory();
                                    }
                                  },
                            child: controller.isLoading.value
                                ? SpinKitThreeBounce(
                                    size: 10.r,
                                    color: whiteColor,
                                  )
                                : const Text(
                                    "Update",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: whiteColor,
                                    ),
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
