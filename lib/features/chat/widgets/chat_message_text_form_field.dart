import 'package:flutter/material.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_text.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';

class ChatMessageTextFormField extends StatelessWidget {
  final bool readOnly;
  final String? labelText;
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final Iterable<String>? autofillHints;
  final int? maxLines;
  final Widget? prefixIcon;
  final void Function(String)? onSubmitted;

  const ChatMessageTextFormField({
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
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    // FIX: Use IntrinsicHeight to prevent overflow in Column
    return IntrinsicHeight(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (labelText != null && labelText!.isNotEmpty) ...[
            KText(
              textAlign: TextAlign.start,
              text: labelText!,
              fontSize: isMobile
                  ? 16
                  : isTablet
                  ? 18
                  : 20,
              fontWeight: FontWeight.w600,
              color: AppColorConstants.titleColor,
            ),
            const SizedBox(height: 10),
          ],

          // FIX: Expanded text field that fits within constraints
          Expanded(
            child: TextFormField(
              readOnly: readOnly,
              controller: controller,
              validator: validator,
              obscureText: obscureText,
              keyboardType: keyboardType,
              autofillHints: autofillHints,
              maxLines: maxLines ?? 1,
              style: const TextStyle(fontWeight: FontWeight.w600),
              onFieldSubmitted: onSubmitted,
              decoration: InputDecoration(
                prefixIcon: prefixIcon,
                filled: true,
                fillColor: AppColorConstants.subTitleColor.withOpacity(0.1),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: AppColorConstants.primaryColor,
                    width: 1,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: AppColorConstants.errorBorderColor,
                    width: 1,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: AppColorConstants.primaryColor,
                    width: 1,
                  ),
                ),
                hintText: hintText,
                isDense: true, // FIX: Reduces the height
              ),
            ),
          ),
        ],
      ),
    );
  }
}
