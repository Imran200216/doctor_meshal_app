import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_app_bar.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';
import 'package:meshal_doctor_booking_app/features/notification/notification.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // App Localization
    final appLoc = AppLocalizations.of(context)!;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: KAppBar(
          title: appLoc.notificationTitle,
          trailing: IconButton(
            onPressed: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );

              if (pickedDate != null) {
                AppLoggerHelper.logInfo("Selected Date: $pickedDate");
              }
            },
            icon: Icon(
              Icons.calendar_month,
              color: AppColorConstants.secondaryColor,
            ),
          ),

          onBack: () {
            // Back
            GoRouter.of(context).pop();
          },
          centerTitle: true,
        ),

        body: RefreshIndicator.adaptive(
          color: AppColorConstants.secondaryColor,
          backgroundColor: AppColorConstants.primaryColor,
          onRefresh: () async {},

          child: ListView.separated(
            scrollDirection: Axis.vertical,
            physics: AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            itemBuilder: (context, index) {
              return NotificationListTile(
                notificationTitle: "Hi Doctor",
                notificationDescription: "Hi Doctor, hi one issue in my leg",
                notificationDateReceived: "12/11/2025",
              );
            },
            separatorBuilder: (context, index) {
              return Divider(
                height: 1,
                color: AppColorConstants.subTitleColor.withOpacity(0.2),
              );
            },
            itemCount: 30,
          ),
        ),
      ),
    );
  }
}
