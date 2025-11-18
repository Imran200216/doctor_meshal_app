import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_app_bar.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_no_items_found.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_skeleton_rectangle.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_text_form_field.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_assets_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_db_constants.dart';
import 'package:meshal_doctor_booking_app/core/service/hive_service.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';
import 'package:meshal_doctor_booking_app/features/chat/view_model/bloc/doctor_list/doctor_list_bloc.dart';
import 'package:meshal_doctor_booking_app/features/chat/widgets/doctor_list_skeleton.dart';
import 'package:meshal_doctor_booking_app/features/chat/widgets/doctor_list_tile.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';

class DoctorListScreen extends StatefulWidget {
  const DoctorListScreen({super.key});

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  // User Id
  String? userId;

  // Search Controller
  final TextEditingController _searchController = TextEditingController();

  // Debounce
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _fetchDoctorList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // Fetch Doctor List
  Future<void> _fetchDoctorList() async {
    try {
      await HiveService.openBox(AppDBConstants.userBox);

      final storedUserId = await HiveService.getData<String>(
        boxName: AppDBConstants.userBox,
        key: AppDBConstants.userId,
      );

      if (storedUserId != null) {
        userId = storedUserId;
        AppLoggerHelper.logInfo("User ID fetched from Hive: $userId");
        context.read<DoctorListBloc>().add(GetDoctorListEvent(userId: userId!));
      } else {
        AppLoggerHelper.logError("No User ID found in Hive!");
      }
    } catch (e) {
      AppLoggerHelper.logError("Error fetching User ID from Hive: $e");
    }
  }

  // Debounce Search Changed
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (userId != null) {
        context.read<DoctorListBloc>().add(
          SearchDoctorListEvent(search: query, userId: userId!),
        );
      }
    });
  }

  // Search TextForm Field
  Widget _buildSearchField(AppLocalizations appLoc) {
    return KTextFormField(
      onChanged: _onSearchChanged,
      prefixIcon: const Icon(Icons.search_outlined),
      controller: _searchController,
      hintText: appLoc.searchDoctors,
      keyboardType: TextInputType.name,
      autofillHints: const [
        AutofillHints.name,
        AutofillHints.familyName,
        AutofillHints.givenName,
        AutofillHints.middleName,
        AutofillHints.nickname,
        AutofillHints.username,
      ],
    );
  }

  // Doctors List
  Widget _buildDoctorList(List doctorsList, bool isMobile, bool isTablet) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final doctor = doctorsList[index];
        return DoctorListTile(
          profileImageUrl: doctor.user.profileImage,
          doctorName: doctor.user.firstName,
          doctorDesignation: doctor.user.specialization,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemCount: doctorsList.length,
    );
  }

  // Loading Skeletons
  Widget _buildLoadingSkeleton() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return const KSkeletonRectangle(
          radius: 10,
          height: 70,
          width: double.maxFinite,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemCount: 20,
    );
  }

  // No Items Found
  Widget _buildNoItemsFound(AppLocalizations appLoc, double height) {
    return SizedBox(
      height: height * 0.6,
      child: Center(
        child: KNoItemsFound(
          noItemsFoundText: appLoc.noDoctorsFound,
          noItemsSvg: AppAssetsConstants.noDoctorFound,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    // Localization
    final appLoc = AppLocalizations.of(context)!;

    // Screen Height
    final height = MediaQuery.of(context).size.height;

    // Padding
    double horizontalPadding = 160;
    if (isMobile) {
      horizontalPadding = 20;
    } else if (isTablet) {
      horizontalPadding = 140;
    }

    double verticalPadding = 80;
    if (isMobile) {
      verticalPadding = 30;
    } else if (isTablet) {
      verticalPadding = 60;
    }

    double skeletonVerticalPadding = 80;
    if (isMobile) {
      skeletonVerticalPadding = 40;
    } else if (isTablet) {
      skeletonVerticalPadding = 60;
    }

    return Scaffold(
      backgroundColor: AppColorConstants.secondaryColor,
      appBar: KAppBar(
        title: appLoc.doctorList,
        onBack: () {
          // Haptics
          HapticFeedback.heavyImpact();

          // Back
          GoRouter.of(context).pop();
        },
      ),
      body: RefreshIndicator.adaptive(
        color: AppColorConstants.secondaryColor,
        backgroundColor: AppColorConstants.primaryColor,
        onRefresh: _fetchDoctorList,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: BlocBuilder<DoctorListBloc, DoctorListState>(
            builder: (context, state) {
              if (state is GetDoctorListLoading) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: skeletonVerticalPadding,
                  ),
                  child: const DoctorListSkeleton(),
                );
              }

              if (state is GetDoctorListSuccess ||
                  state is SearchDoctorListLoading ||
                  state is SearchDoctorListSuccess ||
                  state is SearchDoctorListFailure) {
                List doctorsList = [];
                bool isSearching = false;

                if (state is GetDoctorListSuccess) {
                  doctorsList = state.doctorList;
                } else if (state is SearchDoctorListSuccess) {
                  doctorsList = state.doctorList;
                } else if (state is SearchDoctorListLoading) {
                  isSearching = true;
                } else if (state is SearchDoctorListFailure) {
                  AppLoggerHelper.logError(state.message);
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: verticalPadding,
                    ),
                    child: Column(
                      spacing: 20,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildSearchField(appLoc),

                        if (isSearching)
                          _buildLoadingSkeleton()
                        else if (doctorsList.isEmpty)
                          _buildNoItemsFound(appLoc, height)
                        else
                          _buildDoctorList(doctorsList, isMobile, isTablet),
                      ],
                    ),
                  ),
                );
              }

              if (state is GetDoctorListFailure) {
                AppLoggerHelper.logError(state.message);
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: verticalPadding,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSearchField(appLoc),
                      const SizedBox(height: 20),
                      Text(appLoc.noDoctorsFound),
                    ],
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
