import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mm_textiles_admin/Components/Formfield.dart';
import 'package:mm_textiles_admin/Controller/Items/AddItemsController.dart';
import 'package:mm_textiles_admin/Theme/Colors.dart';
import 'package:mm_textiles_admin/Theme/Fonts.dart';
import 'package:mm_textiles_admin/Theme/appTheme.dart';
import 'package:mm_textiles_admin/View/util/LoadingOverlay.dart';

class AddItemsScreen extends StatefulWidget {
  const AddItemsScreen({super.key});

  @override
  State<AddItemsScreen> createState() => _AddItemsScreenState();
}

class _AddItemsScreenState extends State<AddItemsScreen> {
  final AddItemsController controller = Get.put(AddItemsController());

  final TextEditingController codeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? subCategory;
  List<String> selectedColors = [];
  String status = "Ready";

  @override
  void initState() {
    super.initState();

    /// RESET UI AFTER SUCCESS
    ever(controller.selectedImage, (file) {
      if (file == null) {
        _formKey.currentState?.reset();
        codeController.clear();
        selectedColors.clear();
        subCategory = null;
        status = "Ready";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTheme.iconAppBarBackgroundless(
        title: Text(
          "Add Items",
          style: AppTextStyles.heading.withColor(kPrimaryColor),
        ),
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: LoadingProgress());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                /// Subcategory Dropdown
                RadioOptionDropdown(
                  LabelText: "Subcategory",
                  hintText: "-- Choose a Subcategory --",
                  validatorText: "Select Subcategory",
                  items: controller.subCategories
                      .map((e) => e['sc_name'].toString())
                      .toList(),
                  onSelectionChanged: (value) {
                    subCategory = value;
                  },
                ),

                const SizedBox(height: 16),

                /// Colors Multi Select
                /// Colors Dropdown (single selection)
                RadioOptionDropdown(
                  LabelText: "Color",
                  hintText: "-- Choose a Color --",
                  validatorText: "Select Color",
                  items: controller.colors
                      .map((e) => e['co_name'].toString())
                      .toList(),
                  onSelectionChanged: (value) {
                    selectedColors = [value];
                  },
                ),

                const SizedBox(height: 16),

                /// Code
                TextInput(
                  LabelText: 'Code',
                  Controller: codeController,
                  HintText: '-- Enter code --',
                  ValidatorText: 'Please enter code',
                  onChanged: (String) {},
                ),

                const SizedBox(height: 16),

                /// Status
                OptionRadioButton(
                  labelText: "Status",
                  option1: "Ready",
                  option2: "Not Finished",
                  onChanged: (val) => status = val,
                ),

                const SizedBox(height: 16),

                /// IMAGE PICKER (INTEGRATED WITH CONTROLLER)
                Obx(() {
                  return ImagePickerFormField(
                    key: ValueKey(controller.selectedImage.value?.path),
                    labelText: "Item Image",
                    initialValue: controller.selectedImage.value,
                    validationRequired: true,
                    onChanged: (file) {
                      controller.selectedImage.value = file;
                    },
                  );
                }),
              ],
            ),
          ),
        );
      }),

      /// Save Button
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  controller.saveItem(
                    subCategoryName: subCategory!,
                    colorNames: selectedColors,
                    code: codeController.text.trim(),
                    status: status,
                    image: controller.selectedImage.value!,
                  );
                }
              },
              child: Text(
                "Save",
                style: AppTextStyles.title.withColor(whiteColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// IMAGE PICKER FORM FIELD

class ImagePickerFormField extends FormField<File> {
  ImagePickerFormField({
    Key? key,
    File? initialValue,
    required String labelText,
    bool validationRequired = true,
    FormFieldSetter<File>? onSaved,
    ValueChanged<File?>? onChanged,
  }) : super(
          key: key,
          initialValue: initialValue,
          validator: (file) {
            if (validationRequired && file == null) {
              return "Please upload image";
            }
            return null;
          },
          onSaved: onSaved,
          builder: (FormFieldState<File> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  labelText,
                  style: AppTextStyles.title,
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    final ImageSource? source =
                        await _chooseSource(Get.context!);

                    if (source != null) {
                      final ImagePicker picker = ImagePicker();
                      final XFile? picked = await picker.pickImage(
                        source: source,
                        imageQuality: 80,
                      );

                      if (picked != null) {
                        final File file = File(picked.path);
                        state.didChange(file);
                        onChanged?.call(file);
                      }
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: state.value == null
                          ? LinearGradient(
                              colors: [
                                Colors.grey.shade100,
                                Colors.grey.shade200,
                              ],
                            )
                          : null,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: state.hasError
                            ? Colors.red
                            : state.value == null
                                ? greyColor.withOpacity(0.6)
                                : kPrimaryColor,
                        width: 1.5,
                      ),
                    ),
                    child: state.value == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: kPrimaryColor.withOpacity(0.15),
                                ),
                                child: const Icon(
                                  Icons.cloud_upload_outlined,
                                  size: 34,
                                  color: kPrimaryColor,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Upload Image",
                                style: AppTextStyles.label.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Camera or Gallery",
                                style: AppTextStyles.small.copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          )
                        : Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.file(
                                  state.value!,
                                  fit: BoxFit.cover,
                                ),
                              ),

                              /// Overlay
                              Positioned(
                                bottom: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: kPrimaryColor,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      state.errorText!,
                      style: TextStyle(
                        color: Colors.red.shade900,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            );
          },
        );

  static Future<ImageSource?> _chooseSource(BuildContext context) async {
    return showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Header
              const Text(
                "Choose Image",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 20),

              /// Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _bottomSheetButton(
                    context,
                    icon: Icons.camera_alt,
                    label: "Camera",
                    source: ImageSource.camera,
                  ),
                  _bottomSheetButton(
                    context,
                    icon: Icons.photo_library,
                    label: "Gallery",
                    source: ImageSource.gallery,
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  static Widget _bottomSheetButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required ImageSource source,
  }) {
    return GestureDetector(
      onTap: () => Navigator.pop(context, source),
      child: Container(
        width: MediaQuery.of(context).size.width / 2.6,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kPrimaryColor.withOpacity(0.15),
              ),
              child: Icon(
                icon,
                size: 26,
                color: kPrimaryColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: AppTextStyles.label.copyWith(
                fontWeight: FontWeight.w600,
                color: textcolor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
