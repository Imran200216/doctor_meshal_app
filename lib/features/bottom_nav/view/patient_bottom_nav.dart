import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_assets_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';
import 'package:meshal_doctor_booking_app/features/bottom_nav/view_model/cubit/bottom_nav_cubit.dart';
import 'package:meshal_doctor_booking_app/features/education/view/education_screen.dart';
import 'package:meshal_doctor_booking_app/features/home/view/home_screen.dart';
import 'package:meshal_doctor_booking_app/features/peri_operative/view/peri_operative_screen.dart';
import 'package:meshal_doctor_booking_app/features/profile/view/profile_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PatientBottomNav extends StatefulWidget {
  const PatientBottomNav({super.key});

  @override
  State<PatientBottomNav> createState() => _PatientBottomNavState();
}

class _PatientBottomNavState extends State<PatientBottomNav> {
  @override
  Widget build(BuildContext context) {
    // Screens
    final List<Widget> screens = [
      const HomeScreen(),
      const PeriOperativeScreen(),
      const EducationScreen(),
      const ProfileScreen(),
    ];

    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    return BlocBuilder<BottomNavCubit, BottomNavState>(
      builder: (context, state) {
        final selectedIndex = (state is BottomNavSelected)
            ? state.selectedIndex
            : 0;

        return Scaffold(
          backgroundColor: AppColorConstants.secondaryColor,
          body: IndexedStack(index: selectedIndex, children: screens),

          bottomNavigationBar: Directionality(
            textDirection: TextDirection.ltr,
            child: BottomNavigationBar(
              currentIndex: selectedIndex,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppColorConstants.primaryColor,
              unselectedItemColor: AppColorConstants.subTitleColor,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              onTap: (index) {
                context.read<BottomNavCubit>().selectBottomNav(index);
              },
              items: [
                // Home
                BottomNavigationBarItem(
                  activeIcon: SvgPicture.asset(
                    AppAssetsConstants.homeFilled,
                    height: isMobile
                        ? 28
                        : isTablet
                        ? 30
                        : 32,
                    fit: BoxFit.cover,
                    color: AppColorConstants.primaryColor,
                  ),
                  icon: SvgPicture.asset(
                    AppAssetsConstants.homeOutlined,
                    height: isMobile
                        ? 28
                        : isTablet
                        ? 30
                        : 32,
                    fit: BoxFit.cover,
                    color: AppColorConstants.subTitleColor,
                  ),
                  label: '',
                ),

                // Peri Operative
                BottomNavigationBarItem(
                  activeIcon: SvgPicture.asset(
                    AppAssetsConstants.periOperativeFilled,
                    height: isMobile
                        ? 28
                        : isTablet
                        ? 30
                        : 32,
                    fit: BoxFit.cover,
                    color: AppColorConstants.primaryColor,
                  ),
                  icon: SvgPicture.asset(
                    AppAssetsConstants.periOperativeOutlined,
                    color: AppColorConstants.subTitleColor,
                    height: isMobile
                        ? 28
                        : isTablet
                        ? 30
                        : 32,
                    fit: BoxFit.cover,
                  ),
                  label: '',
                ),

                // Education
                BottomNavigationBarItem(
                  activeIcon: SvgPicture.asset(
                    AppAssetsConstants.educationFilled,
                    height: isMobile
                        ? 28
                        : isTablet
                        ? 30
                        : 32,
                    fit: BoxFit.cover,
                    color: AppColorConstants.primaryColor,
                  ),
                  icon: SvgPicture.asset(
                    AppAssetsConstants.educationOutlined,
                    height: isMobile
                        ? 28
                        : isTablet
                        ? 30
                        : 32,
                    fit: BoxFit.cover,
                    color: AppColorConstants.subTitleColor,
                  ),
                  label: '',
                ),

                // Profile
                BottomNavigationBarItem(
                  activeIcon: SvgPicture.asset(
                    AppAssetsConstants.profileFilled,
                    height: isMobile
                        ? 28
                        : isTablet
                        ? 30
                        : 32,
                    fit: BoxFit.cover,
                    color: AppColorConstants.primaryColor,
                  ),
                  icon: SvgPicture.asset(
                    AppAssetsConstants.profileOutlined,
                    height: isMobile
                        ? 28
                        : isTablet
                        ? 30
                        : 32,
                    fit: BoxFit.cover,
                    color: AppColorConstants.subTitleColor,
                  ),
                  label: '',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
