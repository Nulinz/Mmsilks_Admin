import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

import '../Theme/Colors.dart';
import '../Theme/appTheme.dart';

class LRNumberInput extends StatelessWidget {
  final String LabelText, HintText, ValidatorText;
  final TextEditingController Controller;
  final IconData IconName;
  final bool isContactnumber;
  final bool readOnly;
  final bool validationRequired;
  final Function(String) onChanged;

  const LRNumberInput(
      {super.key,
      required this.LabelText,
      required this.Controller,
      required this.HintText,
      required this.ValidatorText,
      required this.IconName,
      this.readOnly = false,
      this.isContactnumber = false,
      this.validationRequired = true,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              LabelText,
              style: TextStyle(
                fontSize: Get.width / 28,
                letterSpacing: .5,
                fontWeight: FontWeight.w600,
                color: textcolor,
              ),
            ),
            const SizedBox(width: 5),
            // validationRequired
            //     ? Text(
            //         "*",
            //         style: TextStyle(
            //           fontSize: Get.width / 28,
            //           letterSpacing: .5,
            //           fontWeight: FontWeight.w600,
            //           color: Colors.red,
            //         ),
            //       )
            //     : const SizedBox(),
          ],
        ),
        const SizedBox(height: 5),
        TextFormField(
          keyboardType: TextInputType.number,
          cursorColor: kPrimaryColor,
          controller: Controller,
          readOnly: readOnly,
          maxLength: isContactnumber ? 10 : null,
          buildCounter: (BuildContext context,
              {int? currentLength, int? maxLength, bool? isFocused}) {
            return null;
          },
          onChanged: onChanged,
          decoration: InputDecoration(
              prefixIcon: Icon(
                IconName,
                color: greyColor,
                size: Get.width / 24,
              ),
              //filled: true,
              //fillColor: greyColor10,
              hintText: HintText,
              hintStyle:
                  TextStyle(fontSize: Get.width / 32, color: greyColor80),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              enabledBorder: AppTheme.enabledBorder,
              focusedBorder: AppTheme.focusedBorder,
              errorBorder: AppTheme.errorBorder,
              focusedErrorBorder: AppTheme.focusedErrorBorder),
          validator: (value) {
            if (!validationRequired) {
              return null;
            }
            if (value == null || value.isEmpty) {
              return ValidatorText;
            }
            if (isContactnumber == true) {
              if (value.length != 10) {
                return 'Please Enter a valid 10-digit contact number';
              }
            }

            RegExp regExp = RegExp(r'^[0-9]+$'); // Allows only numbers
            // Check if the input is empty or doesn't match the regex pattern
            if (!regExp.hasMatch(value)) {
              return 'Please Enter a valid input ';
            }

            return null;
          },
        ),
      ],
    );
  }
}

class NumberInput extends StatelessWidget {
  final String LabelText, HintText, ValidatorText;
  final TextEditingController Controller;
  final bool readOnly;
  final bool validationRequired;
  final bool isFloat;
  final bool isContactnumber;
  final bool isPincode;
  final int maxcount;
  final bool pcontact;
  final String CoLabelText;
  final String matchvalidation;
  final TextEditingController? matchController;
  final Function(String) onChanged;

  const NumberInput({
    super.key,
    required this.LabelText,
    required this.Controller,
    required this.HintText,
    required this.ValidatorText,
    this.readOnly = false,
    this.validationRequired = true,
    this.isFloat = false,
    this.isContactnumber = false,
    this.isPincode = false,
    this.maxcount = 0,
    this.pcontact = false,
    required this.onChanged,
    this.CoLabelText = "",
    this.matchvalidation = "",
    this.matchController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              LabelText,
              style: TextStyle(
                fontSize: Get.width / 28,
                letterSpacing: .5,
                fontWeight: FontWeight.w600,
                color: textcolor,
              ),
            ),
            const SizedBox(width: 5),
            validationRequired
                ? Text(
                    "*",
                    style: TextStyle(
                      fontSize: Get.width / 28,
                      letterSpacing: .5,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  )
                : const SizedBox(),
          ],
        ),
        CoLabelText == ''
            ? const SizedBox.shrink()
            : Text(
                CoLabelText,
                style: TextStyle(
                  fontSize: Get.width / 32,
                  letterSpacing: .5,
                  fontWeight: FontWeight.w500,
                  color: greyColor,
                ),
              ),
        const SizedBox(height: 8),
        TextFormField(
          readOnly: readOnly,
          keyboardType: TextInputType.number,
          cursorColor: kPrimaryColor,
          controller: Controller,
          onChanged: onChanged,
          maxLength: maxcount > 0
              ? maxcount
              : isContactnumber
                  ? 10
                  : isPincode
                      ? 6
                      : null,
          buildCounter: (BuildContext context,
              {int? currentLength, int? maxLength, bool? isFocused}) {
            return null; // This hides the maxLength counter
          },
          decoration: InputDecoration(
              hintStyle:
                  TextStyle(fontSize: Get.width / 32, color: greyColor80),
              //filled: true,
              fillColor: whiteColor,
              hintText: pcontact ? "Enter your $HintText" : HintText,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              enabledBorder: AppTheme.enabledBorder,
              focusedBorder: AppTheme.focusedBorder,
              errorBorder: AppTheme.errorBorder,
              focusedErrorBorder: AppTheme.focusedErrorBorder),
          validator: (value) {
            // Skip validation if _validationRequired is false
            if (!validationRequired) {
              return null;
            }
            if (value == null || value.isEmpty) {
              return ValidatorText;
            }
            if (isContactnumber == true) {
              if (value.length != 10) {
                return 'Please Enter a valid 10-digit contact number';
              }
            }
            if (isPincode == true) {
              if (value.length != 6) {
                return 'Enter a valid 6-digit ';
              }
            }
            if (matchController != null && matchController!.text.isNotEmpty) {
              if (value != matchController!.text) {
                return matchvalidation;
              }
            }

            RegExp regExp = isFloat
                ? RegExp(r'^-?[0-9]+(\.[0-9]+)?$')
                : RegExp(r'^[0-9]+$'); // Allows only numbers
            // Check if the input is empty or doesn't match the regex pattern
            if (!regExp.hasMatch(value)) {
              return 'Please Enter a valid input ';
            }
            return null;
          },
        ),
      ],
    );
  }
}

class LRTextInput extends StatelessWidget {
  final String LabelText, HintText, ValidatorText;
  final TextEditingController Controller;
  final IconData IconName;
  final bool readOnly;
  final bool validationRequired;

  const LRTextInput({
    super.key,
    required this.LabelText,
    required this.Controller,
    required this.HintText,
    required this.ValidatorText,
    required this.IconName,
    this.readOnly = false,
    this.validationRequired = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              LabelText,
              style: TextStyle(
                fontSize: Get.width / 28,
                letterSpacing: .5,
                fontWeight: FontWeight.w500,
                color: textcolor,
              ),
            ),
            const SizedBox(width: 5),
            validationRequired
                ? Text(
                    "*",
                    style: TextStyle(
                      fontSize: Get.width / 28,
                      letterSpacing: .5,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  )
                : const SizedBox(),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          keyboardType: TextInputType.text,
          cursorColor: kPrimaryColor,
          controller: Controller,
          readOnly: readOnly,
          decoration: InputDecoration(
              prefixIcon: Icon(
                IconName,
                color: kPrimaryColor,
                size: Get.width / 24,
              ),
              //filled: true,
              fillColor: whiteColor,
              hintText: "Enter the $HintText",
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              enabledBorder: AppTheme.enabledBorder,
              focusedBorder: AppTheme.focusedBorder,
              errorBorder: AppTheme.errorBorder,
              focusedErrorBorder: AppTheme.focusedErrorBorder),
          validator: (value) {
            if (!validationRequired) {
              return null;
            }
            if (value == null || value.isEmpty) {
              return ValidatorText;
            }
            // RegExp regExp = RegExp(r'^[0-9]+$'); // Allows only numbers
            // // Check if the input is empty or doesn't match the regex pattern
            // if (!regExp.hasMatch(value)) {
            //   return 'Please Enter a valid input ';
            // }
            return null;
          },
        ),
      ],
    );
  }
}
// inside widgets folder or same file

class PasswordInputField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool isVisible;
  final Function(bool) onVisibilityChanged;
  final String? Function(String?)? validator;
  final String hintText;

  const PasswordInputField({
    super.key,
    required this.label,
    required this.controller,
    required this.isVisible,
    required this.onVisibilityChanged,
    this.validator,
    this.hintText = '',
  });

  @override
  State<PasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 16.r,
                letterSpacing: .5,
                fontWeight: FontWeight.w600,
                color: blackColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 5.r),
        TextFormField(
          obscureText: !widget.isVisible,
          controller: widget.controller,
          validator: widget.validator,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(fontSize: 14.r, color: greyColor80),
            contentPadding:
                EdgeInsets.symmetric(vertical: 15.r, horizontal: 15.r),
            filled: true,
            fillColor: greyColor10,
            enabledBorder: AppTheme.enabledBorder,
            focusedBorder: AppTheme.focusedBorder,
            errorBorder: AppTheme.errorBorder,
            focusedErrorBorder: AppTheme.focusedErrorBorder,
            suffixIcon: IconButton(
              icon: Icon(
                widget.isVisible ? Icons.visibility : Icons.visibility_off,
                color: greyColor,
              ),
              onPressed: () => widget.onVisibilityChanged(!widget.isVisible),
            ),
          ),
        ),
      ],
    );
  }
}

class TextInput extends StatelessWidget {
  final String LabelText, HintText, ValidatorText, CoLabelText;
  final TextEditingController Controller;
  final bool readOnly, capitalization;
  final bool validationRequired;
  final Function(String) onChanged;
  final Function(String)? onSubmitted;
  final Function()? onTap;
  final int maxcount;
  final bool nameinput;

  const TextInput(
      {super.key,
      required this.LabelText,
      required this.Controller,
      required this.HintText,
      required this.ValidatorText,
      this.readOnly = false,
      this.validationRequired = true,
      required this.onChanged,
      this.maxcount = 0,
      this.onTap,
      this.nameinput = false,
      this.CoLabelText = "",
      this.onSubmitted,
      this.capitalization = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              LabelText,
              style: TextStyle(
                fontSize: Get.width / 28,
                letterSpacing: .5,
                fontWeight: FontWeight.w600,
                color: blackColor,
              ),
            ),
            const SizedBox(width: 5),
            validationRequired
                ? Text(
                    "*",
                    style: TextStyle(
                      fontSize: Get.width / 28,
                      letterSpacing: .5,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  )
                : const SizedBox(),
          ],
        ),
        CoLabelText == ''
            ? const SizedBox.shrink()
            : Text(
                CoLabelText,
                style: TextStyle(
                  fontSize: Get.width / 32,
                  letterSpacing: .5,
                  fontWeight: FontWeight.w500,
                  color: greyColor,
                ),
              ),
        const SizedBox(height: 8),
        TextFormField(
          textCapitalization: capitalization
              ? TextCapitalization.characters
              : TextCapitalization.none,
          inputFormatters: capitalization
              ? [
                  UpperCaseTextFormatter()
                ] // Apply uppercase formatter if capitalization is true
              : [],
          readOnly: readOnly,
          maxLength: maxcount > 0 ? maxcount : null,
          buildCounter: (BuildContext context,
              {int? currentLength, int? maxLength, bool? isFocused}) {
            return null; // This hides the maxLength counter
          },
          keyboardType: nameinput ? TextInputType.name : TextInputType.text,
          cursorColor: kPrimaryColor,
          controller: Controller,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          onTap: onTap,
          decoration: InputDecoration(
              hintStyle:
                  TextStyle(fontSize: Get.width / 32, color: greyColor80),
              //filled: true,
              fillColor: whiteColor,
              hintText: nameinput ? "Enter your $HintText" : HintText,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              enabledBorder: AppTheme.enabledBorder,
              focusedBorder: AppTheme.focusedBorder,
              errorBorder: AppTheme.errorBorder,
              focusedErrorBorder: AppTheme.focusedErrorBorder),
          validator: (value) {
            // Skip validation if _validationRequired is false
            if (!validationRequired) {
              return null;
            }
            if (value == null || value.isEmpty) {
              return ValidatorText;
            }
            return null;
          },
        ),
      ],
    );
  }
}

// Custom TextInputFormatter to enforce uppercase

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class DescriptionInput extends StatelessWidget {
  final String LabelText, HintText, ValidatorText;
  final TextEditingController Controller;
  final bool validationRequired;
  final bool readOnly;

  const DescriptionInput({
    super.key,
    required this.LabelText,
    required this.Controller,
    required this.HintText,
    required this.ValidatorText,
    this.readOnly = false,
    this.validationRequired = true,
    required Null Function(dynamic value) onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              LabelText,
              style: TextStyle(
                fontSize: Get.width / 28,
                letterSpacing: .5,
                fontWeight: FontWeight.w600,
                color: textcolor,
              ),
            ),
            const SizedBox(width: 5),
            validationRequired
                ? Text(
                    "*",
                    style: TextStyle(
                      fontSize: Get.width / 28,
                      letterSpacing: .5,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  )
                : const SizedBox(),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          readOnly: readOnly,
          keyboardType: TextInputType.text,
          cursorColor: kPrimaryColor,
          controller: Controller,
          minLines: 3,
          maxLines: null,
          decoration: InputDecoration(
              hintStyle:
                  TextStyle(fontSize: Get.width / 32, color: greyColor80),
              //filled: true,
              fillColor: whiteColor,
              hintText: HintText,
              alignLabelWithHint: true,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              enabledBorder: AppTheme.enabledBorder,
              focusedBorder: AppTheme.focusedBorder,
              errorBorder: AppTheme.errorBorder,
              focusedErrorBorder: AppTheme.focusedErrorBorder),
          validator: (value) {
            // Skip validation if _validationRequired is false
            if (!validationRequired) {
              return null;
            }
            if (value == null || value.isEmpty) {
              return ValidatorText;
            }

            return null;
          },
        ),
      ],
    );
  }
}

class EmailInput extends StatelessWidget {
  final String LabelText;
  final String HintText;
  final TextEditingController Controller;
  final bool readOnly;
  final bool validationRequired;
  final Function(String) onChanged;

  const EmailInput({
    super.key,
    required this.LabelText,
    required this.HintText,
    required this.Controller,
    this.readOnly = false,
    this.validationRequired = true,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              LabelText,
              style: TextStyle(
                fontSize: Get.width / 28,
                letterSpacing: .5,
                fontWeight: FontWeight.w600,
                color: textcolor,
              ),
            ),
            const SizedBox(width: 5),
            validationRequired
                ? Text(
                    "*",
                    style: TextStyle(
                      fontSize: Get.width / 28,
                      letterSpacing: .5,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  )
                : const SizedBox(),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          readOnly: readOnly,
          keyboardType: TextInputType.emailAddress,
          cursorColor: kPrimaryColor,
          controller: Controller,
          onChanged: onChanged,
          decoration: InputDecoration(
              hintStyle:
                  TextStyle(fontSize: Get.width / 32, color: greyColor80),
              //filled: true,
              fillColor: whiteColor,
              hintText: HintText,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              enabledBorder: AppTheme.enabledBorder,
              focusedBorder: AppTheme.focusedBorder,
              errorBorder: AppTheme.errorBorder,
              focusedErrorBorder: AppTheme.focusedErrorBorder),
          validator: (value) {
            if (!validationRequired) {
              return null;
            }
            if (value == null || value.isEmpty) {
              return 'Please Enter Email';
            }
            bool EmailValid = RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(value);
            if (!EmailValid) {
              return 'Please enter a valid Email';
            }

            return null;
          },
        ),
      ],
    );
  }
}

class DropdownInput extends StatefulWidget {
  final String LabelText, hintText, validatorText;
  final String? dropdownValue;
  final List<String> dropdownList;
  final bool validationRequired;
  final ValueChanged<String?> onChanged;

  const DropdownInput({
    Key? key,
    required this.LabelText,
    required this.hintText,
    required this.validatorText,
    this.dropdownValue, // Nullable to allow no selection initially
    required this.dropdownList, // Expecting a non-null list
    required this.onChanged,
    this.validationRequired = true,
  }) : super(key: key);

  @override
  _DropdownInputState createState() => _DropdownInputState();
}

class _DropdownInputState extends State<DropdownInput> {
  String? dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.dropdownValue; // Initialize with widget's value
  }

  @override
  void didUpdateWidget(DropdownInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.dropdownValue != dropdownValue) {
      setState(() {
        dropdownValue = widget.dropdownValue; // Update if the value changes
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.LabelText,
              style: TextStyle(
                fontSize: Get.width / 28,
                letterSpacing: .5,
                fontWeight: FontWeight.w600,
                color: textcolor,
              ),
            ),
            const SizedBox(width: 5),
            widget.validationRequired
                ? Text(
                    "*",
                    style: TextStyle(
                      fontSize: Get.width / 28,
                      letterSpacing: .5,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  )
                : const SizedBox(),
          ],
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          hint: Text(
            widget.hintText,
            style: TextStyle(fontSize: Get.width / 30, color: greyColor80),
          ),
          decoration: InputDecoration(
            // suffixIcon: Icon(
            //   Icons.keyboard_arrow_down,
            //   color: greyColor,
            //   size: Get.width / 15,
            // ),
            //filled: true,
            fillColor: whiteColor,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            enabledBorder: AppTheme.enabledBorder,
            focusedBorder: AppTheme.focusedBorder,
            errorBorder: AppTheme.errorBorder,
            focusedErrorBorder: AppTheme.focusedBorder,
          ),
          elevation: 1,

          validator: (value) {
            if (!widget.validationRequired) {
              return null;
            }
            if (value == null || value.isEmpty) {
              return widget.validatorText;
            }
            return null;
          },
          isExpanded: true,
          value: dropdownValue, // Use the local state value
          items:
              widget.dropdownList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              dropdownValue = value;
              widget.onChanged(value); // Notify parent widget of change
            });
          },
        ),
      ],
    );
  }
}

class OptionRadioButton extends StatefulWidget {
  final String option1;
  final String option2;
  final String labelText;
  final String? initialValue;
  final bool validationRequired;
  final ValueChanged<String>? onChanged;

  OptionRadioButton({
    super.key,
    required this.option1,
    required this.option2,
    required this.labelText,
    this.initialValue,
    this.validationRequired = false,
    this.onChanged,
  });

  @override
  _OptionRadioButtonState createState() => _OptionRadioButtonState();
}

class _OptionRadioButtonState extends State<OptionRadioButton> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue ??
        widget.option1; // Default to option1 if no initial value
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.labelText,
              style: TextStyle(
                fontSize: Get.width / 28,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 5),
            // if (widget.validationRequired)
            //   Text(
            //     "*",
            //     style: TextStyle(
            //       fontSize: Get.width / 28,
            //       fontWeight: FontWeight.w600,
            //       color: Colors.red,
            //     ),
            //   ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedValue = widget.option1;
                  });
                  if (widget.onChanged != null) {
                    widget.onChanged!(_selectedValue!);
                  }
                },
                child: Row(
                  children: [
                    Radio<String>(
                      activeColor: kPrimaryColor,
                      value: widget.option1,
                      groupValue: _selectedValue,
                      onChanged: (value) {
                        setState(() {
                          _selectedValue = value;
                        });
                        if (widget.onChanged != null) {
                          widget.onChanged!(_selectedValue!);
                        }
                      },
                    ),
                    Text(
                      widget.option1,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedValue = widget.option2;
                  });
                  if (widget.onChanged != null) {
                    widget.onChanged!(_selectedValue!);
                  }
                },
                child: Row(
                  children: [
                    Radio<String>(
                      activeColor: kPrimaryColor,
                      value: widget.option2,
                      groupValue: _selectedValue,
                      onChanged: (value) {
                        setState(() {
                          _selectedValue = value;
                        });
                        if (widget.onChanged != null) {
                          widget.onChanged!(_selectedValue!);
                        }
                      },
                    ),
                    Text(
                      widget.option2,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (widget.validationRequired && _selectedValue == null)
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 4),
            child: Text(
              "Please Select Option",
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}

class RadioOptionDropdown extends StatefulWidget {
  final String LabelText, hintText, validatorText;
  final List<String> items;
  final String? initialValue;
  final Function(String) onSelectionChanged;
  final bool validationRequired;

  const RadioOptionDropdown({
    required this.LabelText,
    required this.hintText,
    required this.validatorText,
    required this.items,
    this.initialValue,
    required this.onSelectionChanged,
    this.validationRequired = true,
  });

  @override
  _RadioOptionDropdownState createState() => _RadioOptionDropdownState();
}

class _RadioOptionDropdownState extends State<RadioOptionDropdown> {
  String? _selectedItem;
  bool isDropdownOpened = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.initialValue;
  }

  @override
  void didUpdateWidget(covariant RadioOptionDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialValue != widget.initialValue) {
      setState(() {
        _selectedItem = widget.initialValue;
      });
    }
  }

  void _toggleDropdown() {
    setState(() {
      isDropdownOpened = !isDropdownOpened;
    });
  }

  void _onItemSelected(String item) {
    setState(() {
      _selectedItem = item;
      isDropdownOpened = false;
    });
    widget.onSelectionChanged(item);
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: _selectedItem,
      validator: (value) {
        if (!widget.validationRequired) {
          return null;
        }
        if (_selectedItem == null) {
          return widget.validatorText;
        }
        return null;
      },
      builder: (FormFieldState<String> field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  widget.LabelText,
                  style: TextStyle(
                    fontSize: Get.width / 28,
                    letterSpacing: .5,
                    fontWeight: FontWeight.w600,
                    color: textcolor,
                  ),
                ),
                const SizedBox(width: 5),
                widget.validationRequired
                    ? Text(
                        "*",
                        style: TextStyle(
                          fontSize: Get.width / 28,
                          letterSpacing: .5,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _toggleDropdown,
              child: Container(
                width: Get.width,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: field.hasError ? Colors.red : greyColor,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: Get.width / 1.4,
                      child: Text(
                        _selectedItem ?? widget.hintText,
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color:
                                _selectedItem != null ? textcolor : greyColor80,
                            letterSpacing: .5,
                            fontSize: Get.width / 28,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Icon(
                      isDropdownOpened
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: greyColor,
                      size: Get.width / 15,
                    ),
                  ],
                ),
              ),
            ),
            if (isDropdownOpened)
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: whiteColor,
                  border: Border.all(color: greyColor40, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SizedBox(
                  height: Get.height / 3,
                  child: Scrollbar(
                    thumbVisibility: true,
                    radius: const Radius.circular(10),
                    controller: _scrollController,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: widget.items.map((item) {
                          return RadioListTile<String>(
                            visualDensity: VisualDensity.compact,
                            contentPadding: const EdgeInsets.all(0),
                            value: item,
                            groupValue: _selectedItem,
                            activeColor: kPrimaryColor,
                            title: Text(item),
                            onChanged: (value) {
                              if (value != null) {
                                _onItemSelected(value);
                                field.didChange(
                                    value); // Notify the form of the selection change
                              }
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 5.0, left: 10),
                child: Text(
                  field.errorText!,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          color: Colors.red.shade900,
                          fontSize: 13,
                          fontWeight: FontWeight.w400)),
                ),
              ),
          ],
        );
      },
    );
  }
}

class DurationDateInput extends StatefulWidget {
  const DurationDateInput(
      {required this.Controller,
      required this.LabelText,
      required this.HintText,
      required this.ValidatorText,
      this.startDateController,
      super.key,
      this.validationRequired = true});

  final TextEditingController Controller;
  final String HintText, LabelText, ValidatorText;
  final TextEditingController? startDateController;
  final bool validationRequired;

  @override
  State<DurationDateInput> createState() => _DurationDateInputState();
}

class _DurationDateInputState extends State<DurationDateInput> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.LabelText,
              style: TextStyle(
                fontSize: Get.width / 28,
                letterSpacing: .5,
                fontWeight: FontWeight.w600,
                color: textcolor,
              ),
            ),
            const SizedBox(width: 5),
            widget.validationRequired
                ? Text(
                    "*",
                    style: TextStyle(
                      fontSize: Get.width / 28,
                      letterSpacing: .5,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  )
                : const SizedBox(),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
            controller: widget.Controller,
            readOnly: true,
            keyboardType: TextInputType.text,
            cursorColor: textcolor,
            decoration: InputDecoration(
                hintText: widget.HintText,
                hintStyle: TextStyle(
                  fontSize: Get.width / 32,
                  color: greyColor80,
                ),
                // suffixIcon: const Icon(
                //   Iconsax.calendar_1_copy,
                //   color: greyColor80,
                // ),
                //filled: true,
                fillColor: whiteColor,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 10.0),
                enabledBorder: AppTheme.enabledBorder,
                focusedBorder: AppTheme.focusedBorder,
                errorBorder: AppTheme.errorBorder,
                focusedErrorBorder: AppTheme.focusedErrorBorder),
            validator: (val) {
              if (val == null || val.isEmpty) {
                return widget.ValidatorText;
              }
              if (widget.startDateController != null &&
                  widget.startDateController!.text.isNotEmpty) {
                DateTime startDate = DateFormat('dd-MM-yyyy')
                    .parse(widget.startDateController!.text);
                DateTime? endDate = DateFormat('dd-MM-yyyy').parse(val);

                if (endDate.isBefore(startDate)) {
                  return "End date cannot be before the start date.";
                }
              }

              return null;
            },
            onTap: () async {
              DateTime? initialDate = DateTime.now();

              // If it's the end date, we ensure start date is considered
              if (widget.startDateController != null &&
                  widget.startDateController!.text.isNotEmpty) {
                initialDate = DateFormat('dd-MM-yyyy')
                    .parse(widget.startDateController!.text);
              }

              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: initialDate,
                firstDate: DateTime(1900),
                lastDate: DateTime.now().add(const Duration(days: 10000)),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: kPrimaryColor,
                        onPrimary: Colors.white,
                        onSurface: Colors.black87,
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black,
                        ),
                      ),
                    ),
                    child: child!,
                  );
                },
              );

              if (pickedDate != null) {
                if (widget.startDateController != null &&
                    widget.startDateController!.text.isNotEmpty) {
                  DateTime startDate = DateFormat('dd-MM-yyyy')
                      .parse(widget.startDateController!.text);

                  // Check if the picked end date is before the start date
                  if (pickedDate.isBefore(startDate)) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content:
                          Text("End date can't be earlier than start date."),
                      backgroundColor: Colors.red,
                    ));
                    return;
                  }
                }

                String formattedDate =
                    DateFormat('dd-MM-yyyy').format(pickedDate);
                setState(() {
                  widget.Controller.text = formattedDate.toString();
                });
              }
            }),
      ],
    );
  }
}

class DateInput extends StatefulWidget {
  const DateInput({
    required this.Controller,
    required this.LabelText,
    required this.HintText,
    required this.ValidatorText,
    this.validationRequired = true,
    this.IsDateofBirth = false, // New parameter for age check
    super.key,
  });

  final TextEditingController Controller;
  final String HintText, LabelText, ValidatorText;
  final bool validationRequired;
  final bool IsDateofBirth; // New field

  @override
  State<DateInput> createState() => _DateInputState();
}

class _DateInputState extends State<DateInput> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.LabelText,
              style: TextStyle(
                fontSize: Get.width / 28,
                letterSpacing: .5,
                fontWeight: FontWeight.w600,
                color: textcolor,
              ),
            ),
            const SizedBox(width: 5),
            widget.validationRequired
                ? Text(
                    "*",
                    style: TextStyle(
                      fontSize: Get.width / 28,
                      letterSpacing: .5,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  )
                : const SizedBox(),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.Controller,
          readOnly: true,
          keyboardType: TextInputType.text,
          cursorColor: kPrimaryColor,
          decoration: InputDecoration(
            hintText: widget.HintText,
            // suffixIcon: const Icon(
            //   Iconsax.calendar_1_copy,
            //   color: greyColor80,
            // ),
            //filled: true,
            fillColor: whiteColor,
            hintStyle: TextStyle(
              fontSize: Get.width / 32,
              color: greyColor80,
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            enabledBorder: AppTheme.enabledBorder,
            focusedBorder: AppTheme.focusedBorder,
            errorBorder: AppTheme.errorBorder,
            focusedErrorBorder: AppTheme.focusedErrorBorder,
          ),
          validator: (val) {
            if (!widget.validationRequired) {
              return null;
            }
            if (val == null || val.isEmpty) {
              return widget.ValidatorText;
            }
            return null;
          },
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: widget.IsDateofBirth ? DateTime(1950) : DateTime.now(),
              lastDate: widget.IsDateofBirth
                  ? DateTime.now()
                  : DateTime.now().add(const Duration(days: 10000)),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: kPrimaryColor,
                      onPrimary: Colors.white,
                      onSurface: Colors.black87,
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                      ),
                    ),
                  ),
                  child: child!,
                );
              },
            );

            if (pickedDate != null) {
              // Check age if IsDateofBirth is true
              if (widget.IsDateofBirth) {
                int age = DateTime.now().year - pickedDate.year;
                if (DateTime.now().month < pickedDate.month ||
                    (DateTime.now().month == pickedDate.month &&
                        DateTime.now().day < pickedDate.day)) {
                  age--;
                }

                if (age < 18) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Invalid Age'),
                      content: const Text('Age must be at least 18 years.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            widget.Controller.clear();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                  return;
                }
              }

              String formattedDate =
                  DateFormat('dd-MM-yyyy').format(pickedDate);
              setState(() {
                widget.Controller.text = formattedDate.toString();
              });
            }
          },
        ),
      ],
    );
  }

  Widget Titletext(String text) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          textStyle: TextStyle(
            color: textcolor,
            letterSpacing: .5,
            fontSize: screenWidth / 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class CustomMultiSelectDropdown extends FormField<List<String>> {
  CustomMultiSelectDropdown({
    required List<String> items,
    required List<String> selectedItems,
    List<String>? initialvalue,
    required Function(List<String>) onSelectionChanged,
    required String LabelText,
    FormFieldSetter<List<String>>? onSaved,
    bool validationRequired = true,
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
    required Key key,
  }) : super(
          onSaved: onSaved,
          validator: (selectedItems) {
            if (!validationRequired) {
              return null;
            }
            // In-built validation for null or empty selection
            if ((selectedItems == null || selectedItems.isEmpty) &&
                (initialvalue == null || initialvalue.isEmpty)) {
              return 'Please select at least one option';
            }
            return null; // No validation error
          },
          initialValue:
              initialvalue ?? selectedItems, // Ensure initial value is set
          autovalidateMode: autovalidateMode,
          builder: (FormFieldState<List<String>> state) {
            return CtmMultiSelectDropdown(
              items: items,
              selectedItems: state.value ??
                  [], // Use the current state value or empty list
              onSelectionChanged: (newSelectedItems) {
                state.didChange(newSelectedItems); // Update FormField state
                onSelectionChanged(newSelectedItems); // Notify parent widget
              },
              errorText: state.hasError ? state.errorText : null,
              LabelText: LabelText,
              validationRequired: validationRequired,
              key: key, initialValue: initialvalue ?? [],
            );
          },
        );
}

class CtmMultiSelectDropdown extends StatefulWidget {
  final List<String> items;
  final List<String> selectedItems;
  final List<String>? initialValue;
  final Function(List<String>) onSelectionChanged;
  final String? errorText;
  final String LabelText;
  final bool validationRequired;
  final Key key;

  CtmMultiSelectDropdown({
    required this.items,
    required this.LabelText,
    required this.selectedItems,
    required this.onSelectionChanged,
    this.initialValue,
    this.errorText,
    required this.validationRequired,
    required this.key,
  });

  @override
  CtmMultiSelectDropdownState createState() => CtmMultiSelectDropdownState();
}

class CtmMultiSelectDropdownState extends State<CtmMultiSelectDropdown> {
  List<String> _selectedItems = [];
  List<String> _filteredItems = [];
  bool isDropdownOpened = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    print(widget.initialValue);
    _selectedItems = List<String>.from(widget.selectedItems);
    _filteredItems = List<String>.from(widget.items);
  }

  @override
  void didUpdateWidget(CtmMultiSelectDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.selectedItems != oldWidget.selectedItems ||
        widget.initialValue != oldWidget.initialValue) {
      setState(() {
        if (widget.initialValue?.isNotEmpty ?? false) {
          print("ifcase ${widget.initialValue}");
          _selectedItems = List<String>.from(widget.initialValue!);
        } else {
          print("elsecase ${widget.initialValue}");
          _selectedItems = List<String>.from(widget.selectedItems);
        }
      });
    }
  }

  void _toggleDropdown() {
    setState(() {
      isDropdownOpened = !isDropdownOpened;
      if (isDropdownOpened) {
        _filteredItems = List<String>.from(widget.items);
      }
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _filteredItems = widget.items
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void closeDropdown() {
    setState(() {
      isDropdownOpened = false;
    });
  }

  void resetSelection() {
    setState(() {
      _selectedItems.clear();
      _searchController.clear();
      _filteredItems = List<String>.from(widget.items);
    });
    widget.onSelectionChanged(_selectedItems);
  }

  void _onItemCheckChanged(bool? checked, String item) {
    setState(() {
      if (checked!) {
        _selectedItems.add(item);
      } else {
        _selectedItems.remove(item);
      }
    });
    widget.onSelectionChanged(_selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.LabelText,
              style: TextStyle(
                fontSize: Get.width / 28,
                letterSpacing: .5,
                fontWeight: FontWeight.w600,
                color: textcolor,
              ),
            ),
            const SizedBox(width: 5),
            widget.validationRequired
                ? Text(
                    "*",
                    style: TextStyle(
                      fontSize: Get.width / 28,
                      letterSpacing: .5,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  )
                : const SizedBox(),
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _toggleDropdown,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: whiteColor,
              border: Border.all(color: Colors.grey, width: 1.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: Get.width / 1.4,
                  child: Text(
                    _selectedItems.isNotEmpty
                        ? _selectedItems.join(', ') // Show selected items
                        : "-- Choose a Color --",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: _selectedItems.isEmpty ? greyColor60 : textcolor,
                        letterSpacing: .5,
                        fontSize: Get.width / 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Icon(
                  isDropdownOpened
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: greyColor,
                  size: Get.width / 15,
                ),
              ],
            ),
          ),
        ),
        if (isDropdownOpened)
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300, width: 1.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SizedBox(
              height: Get.height / 3,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    // Search Field
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        //filled: true,
                        fillColor: whiteColor,
                        hintText: "Search",
                        prefixIcon: const Icon(Icons.search),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        focusedBorder: AppTheme.searchEnabledBorder,
                        enabledBorder: AppTheme.searchEnabledBorder,
                      ),
                      onChanged: _onSearchChanged,
                    ),
                    // Filtered Items List
                    if (_filteredItems.isNotEmpty)
                      Column(
                        children: _filteredItems.map((item) {
                          return CheckboxListTile(
                            activeColor: kPrimaryColor,
                            value: _selectedItems.contains(item),
                            title: Text(item),
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (checked) =>
                                _onItemCheckChanged(checked, item),
                          );
                        }).toList(),
                      )
                    else
                      const Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "No options available",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(
              widget.errorText!,
              style: TextStyle(color: Colors.red.shade900, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
