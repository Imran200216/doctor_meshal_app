import 'package:flutter/material.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_app_bar.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';

class SurveyFormScreen extends StatefulWidget {
  const SurveyFormScreen({super.key});

  @override
  State<SurveyFormScreen> createState() => _SurveyFormScreenState();
}

class _SurveyFormScreenState extends State<SurveyFormScreen> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    // App Localization
    final appLoc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColorConstants.secondaryColor,
      appBar: KAppBar(title: "Survey Form"),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile
              ? 20
              : isTablet
              ? 30
              : 40,
          vertical: isMobile
              ? 20
              : isTablet
              ? 30
              : 40,
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: AppColorConstants.secondaryColor,
            shadowColor: Colors.transparent,
            cardColor: AppColorConstants.secondaryColor,
          ),
          child: Stepper(
            type: StepperType.horizontal,
            currentStep: _currentStep,
            onStepTapped: (index) => setState(() => _currentStep = index),
            onStepContinue: () {
              if (_currentStep < 3) setState(() => _currentStep += 1);
            },
            onStepCancel: () {
              if (_currentStep > 0) setState(() => _currentStep -= 1);
            },
            controlsBuilder: (context, details) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_currentStep > 0)
                    TextButton(
                      onPressed: details.onStepCancel,
                      child: const Text('Back'),
                    ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: details.onStepContinue,
                    child: Text(_currentStep == 3 ? 'Finish' : 'Next'),
                  ),
                ],
              );
            },
            steps: [
              Step(
                title: Text("1"),
                content: Text("Content for Step 1"),
                isActive: _currentStep >= 0,
                state: _currentStep > 0
                    ? StepState.complete
                    : StepState.indexed,
              ),
              Step(
                title: Text("2"),
                content: Text("Content for Step 2"),
                isActive: _currentStep >= 1,
                state: _currentStep > 1
                    ? StepState.complete
                    : StepState.indexed,
              ),
              Step(
                title: Text("3"),
                content: Text("Content for Step 3"),
                isActive: _currentStep >= 2,
                state: _currentStep > 2
                    ? StepState.complete
                    : StepState.indexed,
              ),
              Step(
                title: Text("4"),
                content: Text("Content for Step 4"),
                isActive: _currentStep >= 3,
                state: _currentStep == 3
                    ? StepState.editing
                    : StepState.indexed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
