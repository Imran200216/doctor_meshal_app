import 'package:flutter/material.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_text.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';

class KPasswordTextFormField extends StatefulWidget {
  final String? labelText;
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final Iterable<String>? autofillHints;

  const KPasswordTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
    this.autofillHints,
    this.labelText,
  });

  @override
  State<KPasswordTextFormField> createState() => _KPasswordTextFormFieldState();
}

class _KPasswordTextFormFieldState extends State<KPasswordTextFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null && widget.labelText!.isNotEmpty) ...[
          KText(
            textAlign: TextAlign.start,
            text: widget.labelText!,
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

        /// 🔹 Password Field
        TextFormField(
          style: TextStyle(
              fontWeight: FontWeight.w600
          ),
          controller: widget.controller,
          validator: widget.validator,
          obscureText: _obscureText,
          autofillHints: widget.autofillHints,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColorConstants.secondaryColor.withOpacity(0.1),

            /// 👇 Consistent borders with KTextFormField
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
            hintText: widget.hintText,

            /// 👁 Toggle visibility icon
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: AppColorConstants.subTitleColor,
              ),
              onPressed: () => setState(() => _obscureText = !_obscureText),
            ),
          ),
        ),
      ],
    );
  }
}
