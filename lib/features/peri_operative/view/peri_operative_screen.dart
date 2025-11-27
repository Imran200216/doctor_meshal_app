import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_text.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_assets_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_router_constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';
import 'package:meshal_doctor_booking_app/features/peri_operative/peri_operative.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';

class PeriOperativeScreen extends StatelessWidget {
  const PeriOperativeScreen({super.key});

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
        'route': AppRouterConstants.preOP,
      },
      {
        'icon': AppAssetsConstants.periOperativeOutlined,
        'title': appLoc.postOperative,
        'route': AppRouterConstants.postOP,
      },
      {
        'icon': AppAssetsConstants.status,
        'title': appLoc.status,
        'route': AppRouterConstants.status,
      },
    ];

    return Scaffold(
      backgroundColor: AppColorConstants.secondaryColor,
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
            // Title
            KText(
              textAlign: TextAlign.start,
              text: appLoc.operativeForms,
              fontSize: isMobile
                  ? 20
                  : isTablet
                  ? 22
                  : 24,
              fontWeight: FontWeight.w600,
              color: AppColorConstants.titleColor,
            ),
            const SizedBox(height: 30),

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
                          icon: item['icon'] as String,
                          title: item['title'] as String,
                          onTap: () => GoRouter.of(
                            context,
                          ).pushNamed(item['route'] as String),
                          operationCardStartFormOrViewFormText:
                              appLoc.startForm,
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
                              appLoc.startForm,
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
