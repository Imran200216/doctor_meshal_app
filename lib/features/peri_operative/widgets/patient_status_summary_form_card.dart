import 'package:flutter/material.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/features/peri_operative/model/view_patient_submitted_form_details_model.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';

class PatientStatusSummaryFormCard extends StatelessWidget {
  final ViewPatientSubmittedFormDetailsModel submittedForm;

  const PatientStatusSummaryFormCard({super.key, required this.submittedForm});

  @override
  Widget build(BuildContext context) {
    // App Localization
    final appLoc = AppLocalizations.of(context)!;

    if (submittedForm.formSection.isEmpty) {
      return const KNoItemsFound();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
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
                /// Section Title
                Text(
                  section.sectionTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 12),

                /// Loop Options
                ...section.formOption.map((option) {
                  if (section.chooseType == "answer") {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Read-only text field for summary
                          KTextFormField(
                            hintText: appLoc.answer,
                            readOnly: true,
                            controller: TextEditingController(
                              text: option.optionName.toString(),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // -------------------------------------------------------
                  //    DEFAULT → Checkbox (Read Only Summary) ✔
                  // -------------------------------------------------------
                  return CheckboxListTile(
                    value: option.answerStatus,
                    onChanged: null,
                    activeColor: AppColorConstants.primaryColor,
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
