import 'package:flutter/material.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';

class KTextFormField extends StatelessWidget {
  final bool readOnly;
  final String? labelText;
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final Iterable<String>? autofillHints;
  final int? maxLines;

  final int? maxLength; // 👈 NEW optional parameter

  final Widget? prefixIcon;
  final Function(String)? onChanged;

  const KTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.autofillHints,
    this.labelText,
    this.maxLines,
    this.readOnly = false,
    this.prefixIcon,
    this.onChanged,
    this.maxLength, // 👈 include in constructor
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null && labelText!.isNotEmpty) ...[
          KText(
            textAlign: TextAlign.start,
            text: labelText!,
            fontSize: isMobile ? 16 : isTablet ? 18 : 20,
            fontWeight: FontWeight.w600,
            color: AppColorConstants.titleColor,
          ),
          const SizedBox(height: 10),
        ],

        TextFormField(
          readOnly: readOnly,
          controller: controller,
          validator: validator,
          obscureText: obscureText,
          keyboardType: keyboardType,
          autofillHints: autofillHints,
          maxLines: maxLines ?? 1,
          maxLength: maxLength, // 👈 ADDED HERE
          style: const TextStyle(fontWeight: FontWeight.w600),
          onChanged: onChanged,

          decoration: InputDecoration(
            prefixIcon: prefixIcon,
            filled: true,
            fillColor: AppColorConstants.secondaryColor.withOpacity(0.1),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColorConstants.subTitleColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColorConstants.subTitleColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColorConstants.primaryColor,
                width: 1,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColorConstants.errorBorderColor,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColorConstants.primaryColor,
                width: 1,
              ),
            ),
            hintText: hintText,
          ),
        ),
      ],
    );
  }
}
