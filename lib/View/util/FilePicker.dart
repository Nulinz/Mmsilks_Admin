import 'dart:typed_data';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mm_textiles_admin/Theme/Colors.dart';
import 'package:mm_textiles_admin/Theme/Fonts.dart';

class FilePickerFormField extends FormField<PlatformFile?> {
  FilePickerFormField({
    super.key,
    required String label,
    required Function(Uint8List?, PlatformFile?) onFilePicked,
    bool isRequired = false,
    String? initialFileName,
  }) : super(
          validator: (value) {
            if (isRequired && value == null) {
              return 'Please choose a file';
            }
            return null;
          },
          builder: (FormFieldState<PlatformFile?> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.title.copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8.r),
                Container(
                  height: 45.r,
                  decoration: BoxDecoration(
                    color: kPrimaryColor.withOpacity(.05),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(kPrimaryColor),
                          foregroundColor: WidgetStateProperty.all<Color>(blackColor),
                          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                            allowMultiple: false,
                            type: FileType.any,
                          );

                          if (result != null &&
                              result.files.isNotEmpty &&
                              result.files.first.path != null) {
                            final file = result.files.first;
                            Uint8List? bytes = await File(file.path!).readAsBytes();

                            onFilePicked(bytes, file);
                            state.didChange(file); // for validation
                          }
                        },
                        child: Text("Choose File", style: AppTextStyles.title),
                      ),
                      Expanded(
                        child: Text(
                          state.value?.name ?? initialFileName ?? "No File Chosen",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.label,
                        ),
                      ),
                    ],
                  ),
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 5, left: 10),
                    child: Text(
                      state.errorText ?? '',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            );
          },
        );
}
