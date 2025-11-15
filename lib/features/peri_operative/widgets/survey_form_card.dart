import 'package:flutter/material.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_text.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';

class SurveyFormCard extends StatelessWidget {
  final String question;
  final List<String> options;
  final int? selectedIndex;
  final Function(int optionIndex) onOptionSelected;

  const SurveyFormCard({
    super.key,
    required this.question,
    required this.options,
    required this.selectedIndex,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColorConstants.subTitleColor.withOpacity(0.2),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question
          KText(
            textAlign: TextAlign.start,
            text: question,
            maxLines: 4,
            overflow: TextOverflow.visible,
            fontSize: isMobile
                ? 16
                : isTablet
                ? 18
                : 20,
            fontWeight: FontWeight.w600,
            color: AppColorConstants.titleColor,
          ),

          const SizedBox(height: 12),

          // Dynamic Checkbox List (Single-select but UI only)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: options.length,
            itemBuilder: (context, index) {
              return CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(options[index]),
                value: selectedIndex == index,
                onChanged: (_) => onOptionSelected(index),
              );
            },
          ),
        ],
      ),
    );
  }
}
