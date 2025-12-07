import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';
import 'package:meshal_doctor_booking_app/features/peri_operative/peri_operative.dart';

class DoctorPeriOperativeScreen extends StatelessWidget {
  const DoctorPeriOperativeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    // App Localization
    final appLoc = AppLocalizations.of(context)!;

    // Data source for cards
    final formItems = [
      {
        'icon': AppAssetsConstants.periOperativeOutlined,
        'title': appLoc.periOperative,
        'route': AppRouterConstants.doctorPreOp,
      },
      {
        'icon': AppAssetsConstants.periOperativeOutlined,
        'title': appLoc.postOperative,
        'route': AppRouterConstants.doctorPostOP,
      },
    ];

    return Scaffold(
      backgroundColor: AppColorConstants.secondaryColor,

      appBar: AppBar(
        centerTitle: false,
        backgroundColor: AppColorConstants.secondaryColor,
        elevation: 0,
        title: Text(appLoc.operativeForms),
        titleTextStyle: TextStyle(
          fontFamily: "OpenSans",
          fontSize: isMobile
              ? 20
              : isTablet
              ? 22
              : 24,
          fontWeight: FontWeight.w700,
          color: AppColorConstants.titleColor,
        ),
      ),

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card List/Grid
            Expanded(
              child: isTablet
                  ? GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            childAspectRatio: 3,
                          ),
                      itemCount: formItems.length,
                      itemBuilder: (context, index) {
                        final item = formItems[index];
                        return OperativeFormCard(
                          operationCardStartFormOrViewFormText:
                              appLoc.viewForm,
                          icon: item['icon'] as String,
                          title: item['title'] as String,
                          onTap: () => GoRouter.of(
                            context,
                          ).pushNamed(item['route'] as String),
                        );
                      },
                    )
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: formItems.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 20),
                      itemBuilder: (context, index) {
                        final item = formItems[index];
                        return OperativeFormCard(
                          operationCardStartFormOrViewFormText:
                              appLoc.viewForm,
                          icon: item['icon'] as String,
                          title: item['title'] as String,
                          onTap: () => GoRouter.of(
                            context,
                          ).pushNamed(item['route'] as String),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
