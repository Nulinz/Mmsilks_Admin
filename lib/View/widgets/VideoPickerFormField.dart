import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mm_textiles_admin/Theme/Colors.dart';
import 'package:mm_textiles_admin/Theme/Fonts.dart';

/// 🎥 VIDEO VALIDATION CONSTANTS
const int maxVideoSizeMB = 30;
const List<String> allowedVideoExtensions = ['mp4', 'mov'];

Future<File?> pickVideo(BuildContext context) async {
  final picker = ImagePicker();
  final XFile? pickedFile = await picker.pickVideo(source: ImageSource.gallery);

  if (pickedFile == null) return null;

  final File file = File(pickedFile.path);

  /// 🔹 Check extension
  final String extension = pickedFile.path.split('.').last.toLowerCase();

  if (!allowedVideoExtensions.contains(extension)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Only MP4 and MOV videos are allowed"),
        backgroundColor: Colors.red,
      ),
    );
    return null;
  }

  /// 🔹 Check size
  final double fileSizeMB = await file.length() / (1024 * 1024);

  if (fileSizeMB > maxVideoSizeMB) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Video size must be less than $maxVideoSizeMB MB"),
        backgroundColor: Colors.red,
      ),
    );
    return null;
  }

  return file;
}

class VideoPickerFormField extends FormField<File> {
  VideoPickerFormField({
    super.key,
    required String labelText,
    File? initialValue,
    required ValueChanged<File?> onChanged,
    bool validationRequired = true,
  }) : super(
          initialValue: initialValue,
          validator: (value) {
            if (validationRequired && value == null) {
              return "Video is required";
            }
            return null;
          },
          builder: (FormFieldState<File> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Label
                Row(
                  children: [
                    Text(
                      labelText,
                      style: TextStyle(
                        fontSize: Get.width / 28,
                        fontWeight: FontWeight.w600,
                        color: blackColor,
                      ),
                    ),
                    if (validationRequired)
                      const Text(
                        " *",
                        style: TextStyle(color: Colors.red),
                      ),
                  ],
                ),
                const SizedBox(height: 8),

                /// Picker Box
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () async {
                    final file = await pickVideo(state.context);
                    if (file != null) {
                      state.didChange(file);
                      onChanged(file);
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: state.hasError ? Colors.red : greyColor,
                      ),
                    ),
                    child: Row(
                      children: [
                        /// Icon
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: greyColor.withOpacity(.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Iconsax.video_copy,
                            color: kPrimaryColor,
                          ),
                        ),

                        const SizedBox(width: 12),

                        /// Text
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.value != null
                                    ? "Video Selected"
                                    : "Upload Video",
                                style: AppTextStyles.title.bold,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                state.value != null
                                    ? state.value!.path.split('/').last
                                    : "MP4, MOV • Max 30MB",
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.label,
                              ),
                            ],
                          ),
                        ),

                        /// Arrow
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: greyColor,
                        ),
                      ],
                    ),
                  ),
                ),

                /// Error text
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      state.errorText!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            );
          },
        );
}
