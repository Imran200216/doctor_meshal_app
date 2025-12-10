import 'package:flutter/material.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';

class SurveyFormMultiCard extends StatelessWidget {
  final String question;
  final List<String> options;
  final List<int> selectedIndexes;
  final Function(int optionIndex) onMultiSelect;

  const SurveyFormMultiCard({
    super.key,
    required this.question,
    required this.options,
    required this.selectedIndexes,
    required this.onMultiSelect,
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
          Row(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: KText(
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
              ),
              KText(
                textAlign: TextAlign.end,
                text: "(Multiple Choice)",
                maxLines: 2,
                overflow: TextOverflow.visible,
                fontSize: isMobile
                    ? 12
                    : isTablet
                    ? 14
                    : 16,
                fontWeight: FontWeight.w600,
                color: AppColorConstants.subTitleColor,
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Dynamic Checkbox List (Multiple-select)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: options.length,
            itemBuilder: (context, index) {
              return CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(options[index]),
                value: selectedIndexes.contains(index),
                onChanged: (_) => onMultiSelect(index),
                // Add these to ensure proper interaction
                activeColor: AppColorConstants.primaryColor,
                checkColor: Colors.white,
                contentPadding: EdgeInsets.zero,
                // Visual feedback
                selected: selectedIndexes.contains(index),

              );
            },
          ),
        ],
      ),
    );
  }
}
