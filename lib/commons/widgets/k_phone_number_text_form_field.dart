import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_text.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';

class KPhoneNumberTextFormField extends StatelessWidget {
  final String? labelText;
  final String hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final Function(String)? onCountryChanged;
  final Locale? locale;

  const KPhoneNumberTextFormField({
    super.key,
    this.labelText,
    required this.hintText,
    this.validator,
    this.onChanged,
    this.onCountryChanged,
    this.locale, this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    // App Localization
    final appLoc = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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

        /// 🔹 Phone Field
        IntlPhoneField(
          controller: controller,
          style: TextStyle(
              fontWeight: FontWeight.w600
          ),
          searchText: appLoc.searchCountry,
          languageCode: locale?.languageCode ?? 'en',
          initialCountryCode: 'IN',
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColorConstants.secondaryColor.withOpacity(0.1),

            /// 👇 Custom borders (same as KTextFormField)
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
          validator: (value) => validator?.call(value?.completeNumber),
          onChanged: (phone) => onChanged?.call(phone.completeNumber),
          onCountryChanged: (country) =>
              onCountryChanged?.call(country.dialCode),
        ),
      ],
    );
  }
}
