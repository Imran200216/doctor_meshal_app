import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/features/services/doctor_services.dart';

class DoctorServicesScreen extends StatelessWidget {
  const DoctorServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // App Localization
    final appLoc = AppLocalizations.of(context)!;

    // ---------- TRAUMA SERVICES ----------
    final traumaServicesList = [
      appLoc.traumaService1,
      appLoc.traumaService2,
      appLoc.traumaService3,
      appLoc.traumaService4,
      appLoc.traumaService5,
      appLoc.traumaService6,
      appLoc.traumaService7,
      appLoc.traumaService8,
      appLoc.traumaService9,
      appLoc.traumaService10,
      appLoc.traumaService11,
      appLoc.traumaService12,
      appLoc.traumaService13,
      appLoc.traumaService14,
      appLoc.traumaService15,
      appLoc.traumaService16,
      appLoc.traumaService17,
      appLoc.traumaService18,
      appLoc.traumaService19,
      appLoc.traumaService20,
    ];

    // ---------- FOOT & ANKLE SERVICES ----------
    final footAnkleServicesList = [
      appLoc.footAnkleService1,
      appLoc.footAnkleService2,
      appLoc.footAnkleService3,
      appLoc.footAnkleService4,
      appLoc.footAnkleService5,
      appLoc.footAnkleService6,
      appLoc.footAnkleService7,
      appLoc.footAnkleService8,
      appLoc.footAnkleService9,
      appLoc.footAnkleService10,
      appLoc.footAnkleService11,
      appLoc.footAnkleService12,
      appLoc.footAnkleService13,
      appLoc.footAnkleService14,
      appLoc.footAnkleService15,
      appLoc.footAnkleService16,
      appLoc.footAnkleService17,
      appLoc.footAnkleService18,
      appLoc.footAnkleService19,
      appLoc.footAnkleService20,
      appLoc.footAnkleService21,
      appLoc.footAnkleService22,
    ];

    return Scaffold(
      backgroundColor: AppColorConstants.secondaryColor,
      appBar: KAppBar(
        centerTitle: true,
        title: appLoc.services,
        onBack: () => GoRouter.of(context).pop(),
        backgroundColor: AppColorConstants.primaryColor,
      ),

      body: RefreshIndicator(
        color: AppColorConstants.secondaryColor,
        backgroundColor: AppColorConstants.primaryColor,
        onRefresh: () async {},
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          children: [
            // ---------------- TRAUMA SERVICES ----------------
            DoctorServiceCard(
              doctorServiceTitle: appLoc.traumaServicesTitle,
              doctorServiceDescription: appLoc.traumaServicesDescription,
              doctorServiceImageUrl:
                  "https://images.unsplash.com/photo-1579684453423-f84349ef60b0?q=80&w=2691&auto=format&fit=crop",
              doctorServicesList: traumaServicesList
                  .map((e) => DoctorServicePoints(title: e))
                  .toList(),
            ),

            SizedBox(height: 20),

            // ---------------- FOOT & ANKLE SERVICES ----------------
            DoctorServiceCard(
              doctorServiceTitle: appLoc.footAnkleServicesTitle,
              doctorServiceDescription: appLoc.footAnkleServicesDescription,
              doctorServiceImageUrl:
                  "https://images.unsplash.com/photo-1579684453423-f84349ef60b0?q=80&w=2691&auto=format&fit=crop",

              doctorServicesList: footAnkleServicesList
                  .map((e) => DoctorServicePoints(title: e))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
