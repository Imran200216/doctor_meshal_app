import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';

class WriteFeedbackScreen extends StatefulWidget {
  const WriteFeedbackScreen({super.key});

  @override
  State<WriteFeedbackScreen> createState() => _WriteFeedbackScreenState();
}

class _WriteFeedbackScreenState extends State<WriteFeedbackScreen> {
  // Controllers
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // App Localization
    final appLoc = AppLocalizations.of(context)!;

    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      appBar: KAppBar(
        title: appLoc.writeFeedback,
        onBack: () => GoRouter.of(context).pop(),
        backgroundColor: AppColorConstants.primaryColor,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
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
          child: Column(
            spacing: 50,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Feedback Controller
              KTextFormField(
                maxLength: 100,
                controller: _feedbackController,
                hintText: appLoc.enterFeedback,
                labelText: appLoc.feedback,
                maxLines: 8,
                keyboardType: TextInputType.multiline,
                autofillHints: [AutofillHints.email],
              ),

              // Submit
              KFilledBtn(
                btnTitle: appLoc.submit,
                btnBgColor: AppColorConstants.primaryColor,
                btnTitleColor: AppColorConstants.secondaryColor,
                onTap: () {
                  // Auth Screen
                },
                borderRadius: 12,
                fontSize: isMobile
                    ? 16
                    : isTablet
                    ? 18
                    : 20,
                btnHeight: isMobile
                    ? 50
                    : isTablet
                    ? 52
                    : 54,
                btnWidth: double.maxFinite,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
