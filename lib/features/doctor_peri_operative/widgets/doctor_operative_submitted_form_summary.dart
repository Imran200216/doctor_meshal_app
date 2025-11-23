import 'package:flutter/material.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_no_items_found.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/features/home/model/view_submitted_patient_form_details_section_model.dart';

class DoctorOperativeSubmittedFormSummary extends StatelessWidget {
  final ViewSubmittedPatientFormDetailsSectionModel submittedForm;

  const DoctorOperativeSubmittedFormSummary({
    super.key,
    required this.submittedForm,
  });

  @override
  Widget build(BuildContext context) {
    if (submittedForm.formSection.isEmpty) {
      return const KNoItemsFound();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: submittedForm.formSection.length,
      itemBuilder: (context, index) {
        final section = submittedForm.formSection[index];

        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 20),
          color: AppColorConstants.secondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: AppColorConstants.subTitleColor.withOpacity(0.4),
              width: 0.6,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section Title
                Text(
                  section.sectionTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 12),

                // Options (Checkbox List)
                ...section.formOption.map((option) {
                  return CheckboxListTile(
                    value: option.answerStatus,
                    onChanged: null,
                    //  Read-only summary
                    activeColor: Colors.blue,
                    title: Text(
                      option.optionName,
                      style: const TextStyle(fontSize: 16),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
