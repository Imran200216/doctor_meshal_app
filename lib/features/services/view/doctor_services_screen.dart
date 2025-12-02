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
        child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          itemBuilder: (context, index) {
            return DoctorServiceCard(
              doctorServiceTitle: "Trauma Services",
              doctorServiceDescription: "Expert level trauma care provided...",
              doctorServiceImageUrl:
                  "https://images.unsplash.com/photo-1579684453423-f84349ef60b0?q=80&w=2691&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
              doctorServicesList: [
                DoctorServicePoints(
                  title: "Master of Medicine in Orthopedics (MMO)",
                ),
                DoctorServicePoints(
                  title: "Master of Medicine in Orthopedics (MMO)",
                ),
                DoctorServicePoints(
                  title: "Master of Medicine in Orthopedics (MMO)",
                ),
              ],
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(height: 0);
          },
          itemCount: 4,
        ),
      ),
    );
  }
}
