import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_assets_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';
import 'package:meshal_doctor_booking_app/features/bottom_nav/presentation/cubit/bottom_nav_cubit.dart';
import 'package:meshal_doctor_booking_app/features/education/presentation/screens/education_screen.dart';
import 'package:meshal_doctor_booking_app/features/home/presentation/screens/home_screen.dart';
import 'package:meshal_doctor_booking_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  @override
  Widget build(BuildContext context) {
    // Screens
    final List<Widget> screens = [
      const HomeScreen(),
      // const Center(child: Text('Appointments Screen')),
      const EducationScreen(),
      const ProfileScreen(),
    ];

    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    // App Localization
    final appLoc = AppLocalizations.of(context)!;

    return BlocBuilder<BottomNavCubit, BottomNavState>(
      builder: (context, state) {
        final selectedIndex = (state is BottomNavSelected)
            ? state.selectedIndex
            : 0;

        return Scaffold(
          backgroundColor: AppColorConstants.secondaryColor,
          body: SafeArea(
            child: IndexedStack(index: selectedIndex, children: screens),
          ),

          bottomNavigationBar: Directionality(
            textDirection: TextDirection.ltr,
            child: BottomNavigationBar(
              currentIndex: selectedIndex,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppColorConstants.primaryColor,
              unselectedItemColor: AppColorConstants.subTitleColor,
              selectedFontSize: isMobile
                  ? 14
                  : isTablet
                  ? 16
                  : 18,
              unselectedFontSize: isMobile
                  ? 14
                  : isTablet
                  ? 16
                  : 18,
              unselectedLabelStyle: TextStyle(
                fontFamily: "OpenSans",
                fontWeight: FontWeight.w600,
                color: AppColorConstants.subTitleColor,
              ),
              selectedLabelStyle: TextStyle(
                fontFamily: "OpenSans",
                fontWeight: FontWeight.w700,
                color: AppColorConstants.primaryColor,
              ),
              showUnselectedLabels: true,
              onTap: (index) {
                context.read<BottomNavCubit>().selectBottomNav(index);
              },
              items: [
                // Home
                BottomNavigationBarItem(
                  activeIcon: SvgPicture.asset(
                    AppAssetsConstants.homeFilled,
                    height: isMobile
                        ? 18
                        : isTablet
                        ? 20
                        : 22,
                    fit: BoxFit.cover,
                  ),
                  icon: SvgPicture.asset(
                    AppAssetsConstants.homeOutlined,
                    height: isMobile
                        ? 18
                        : isTablet
                        ? 20
                        : 22,
                    fit: BoxFit.cover,
                  ),
                  label: appLoc.home,
                ),

                // Appointments
                // BottomNavigationBarItem(
                //   activeIcon: SvgPicture.asset(
                //     AppAssetsConstants.appointmentsFilled,
                //     height: isMobile
                //         ? 18
                //         : isTablet
                //         ? 20
                //         : 22,
                //     fit: BoxFit.cover,
                //   ),
                //   icon: SvgPicture.asset(
                //     AppAssetsConstants.appointmentsOutlined,
                //     height: isMobile
                //         ? 18
                //         : isTablet
                //         ? 20
                //         : 22,
                //     fit: BoxFit.cover,
                //   ),
                //   label: appLoc.appointments,
                // ),

                // Education
                BottomNavigationBarItem(
                  activeIcon: SvgPicture.asset(
                    AppAssetsConstants.educationFilled,
                    height: isMobile
                        ? 18
                        : isTablet
                        ? 20
                        : 22,
                    fit: BoxFit.cover,
                  ),
                  icon: SvgPicture.asset(
                    AppAssetsConstants.educationOutlined,
                    height: isMobile
                        ? 18
                        : isTablet
                        ? 20
                        : 22,
                    fit: BoxFit.cover,
                  ),
                  label: appLoc.education,
                ),

                // Profile
                BottomNavigationBarItem(
                  activeIcon: SvgPicture.asset(
                    AppAssetsConstants.profileFilled,
                    height: isMobile
                        ? 14
                        : isTablet
                        ? 16
                        : 18,
                    fit: BoxFit.cover,
                  ),
                  icon: SvgPicture.asset(
                    AppAssetsConstants.profileOutlined,
                    height: isMobile
                        ? 14
                        : isTablet
                        ? 16
                        : 18,
                    fit: BoxFit.cover,
                  ),
                  label: appLoc.profile,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
