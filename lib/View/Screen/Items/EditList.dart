import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:mm_textiles_admin/Components/Formfield.dart';
import 'package:mm_textiles_admin/Controller/Items/EditItemController.dart';
import 'package:mm_textiles_admin/Controller/Items/AddItemsController.dart';
import 'package:mm_textiles_admin/Theme/Colors.dart';
import 'package:mm_textiles_admin/Theme/appTheme.dart';
import 'package:mm_textiles_admin/View/Screen/Items/AddItems.dart';
import 'package:mm_textiles_admin/View/util/LoadingOverlay.dart';

class EditItemsScreen extends StatelessWidget {
  final int itemId;

  EditItemsScreen({super.key, required this.itemId});

  @override
  Widget build(BuildContext context) {
    // Ensure AddItemsController is registered so EditItemController can find it
    if (!Get.isRegistered<AddItemsController>()) {
      Get.put(AddItemsController());
    }

    // Initialize controller with the correct itemId
    final EditItemController controller = Get.put(EditItemController(itemId));

    return Obx(() {
      if (controller.isLoading.value) {
        return const Scaffold(
          body: Center(child: LoadingProgress()),
        );
      }

      return Scaffold(
        appBar: AppTheme.iconAppBarBackgroundless(
          title: const Text("Edit Item"),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// SUBCATEGORY DROPDOWN
              RadioOptionDropdown(
                LabelText: "Subcategory",
                hintText: "-- Choose a Subcategory --",
                validatorText: "Select Subcategory",
                items: controller.subCategories
                    .map((e) => e['sc_name'] as String)
                    .toList(),
                initialValue: controller.subCategory.value,
                onSelectionChanged: (val) => controller.subCategory.value = val,
              ),

              const SizedBox(height: 16),

              /// COLOR DROPDOWN
              RadioOptionDropdown(
                LabelText: "Color",
                hintText: "-- Choose a Color --",
                validatorText: "Select Color",
                items: controller.colors
                    .map((e) => e['co_name'] as String)
                    .toList(),
                initialValue: controller.selectedColor.value,
                onSelectionChanged: (val) =>
                    controller.selectedColor.value = val,
              ),

              const SizedBox(height: 16),

              /// CODE FIELD
              TextInput(
                LabelText: 'Code',
                Controller:
                    TextEditingController(text: controller.codeController.value)
                      ..selection = TextSelection.fromPosition(
                        TextPosition(
                            offset: controller.codeController.value.length),
                      ),
                HintText: '-- Enter code --',
                ValidatorText: 'Please enter code',
                onChanged: (val) => controller.codeController.value = val,
              ),

              const SizedBox(height: 16),

              /// STATUS RADIO
              OptionRadioButton(
                labelText: "Status",
                option1: "Ready",
                option2: "Not Finished",
                initialValue: controller.status.value.isNotEmpty
                    ? controller.status.value
                    : "Ready",
                onChanged: (val) => controller.status.value = val,
              ),

              const SizedBox(height: 16),

              /// IMAGE PICKER
              ImagePickerFormField(
                labelText: "Item Image",
                initialValue: controller.selectedImage.value,
                validationRequired: false,
                onChanged: (file) => controller.selectedImage.value = file,
              ),

              const SizedBox(height: 8),

// File name card
              Obx(() => Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.image,
                            color: Colors.blueAccent, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            controller.selectedImage.value != null
                                ? controller.selectedImage.value!.path
                                    .split('/')
                                    .last
                                : (controller.apiImageUrl.value.isNotEmpty
                                    ? controller.apiImageUrl.value
                                        .split('/')
                                        .last
                                    : "No image selected"),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.isUpdating.value
                    ? null
                    : () {
                        FocusScope.of(context).unfocus(); // hide keyboard
                        controller.updateItem();
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: controller.isUpdating.value
                    ? SpinKitThreeBounce(
                        color: whiteColor,
                        size: 15.r,
                      )
                    : const Text(
                        "Update",
                        style: TextStyle(color: whiteColor, fontSize: 16),
                      ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
