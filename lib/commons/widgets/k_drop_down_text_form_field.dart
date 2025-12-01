import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';

class KDropDownTextFormField<T> extends StatelessWidget {
  final String? labelText;
  final String hintText;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?) onChanged;
  final String? Function(T?)? validator;
  final double? dropdownMaxHeight;
  final bool isExpanded;

  const KDropDownTextFormField({
    super.key,
    this.labelText,
    required this.hintText,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
    this.dropdownMaxHeight,
    this.isExpanded = true,
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
        DropdownButtonFormField2<T>(
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColorConstants.titleColor,
            fontFamily: "OpenSans",
          ),
          isExpanded: isExpanded,
          value: value,
          items: items,
          validator: validator,
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColorConstants.secondaryColor.withOpacity(0.1),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 12,
            ),
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
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: dropdownMaxHeight ?? 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColorConstants.secondaryColor,
            ),
          ),
          hint: KText(
            text: hintText,
            fontSize: isMobile
                ? 16
                : isTablet
                ? 18
                : 20,
            color: AppColorConstants.subTitleColor,
          ),
          iconStyleData: IconStyleData(
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColorConstants.subTitleColor,
            ),
          ),
        ),
      ],
    );
  }
}
