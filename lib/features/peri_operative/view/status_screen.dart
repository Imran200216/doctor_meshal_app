import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/core/bloc/connectivity/connectivity_bloc.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/core/service/service.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';
import 'package:meshal_doctor_booking_app/features/peri_operative/peri_operative.dart';
import 'package:meshal_doctor_booking_app/features/auth/auth.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  String? userId;

  @override
  void initState() {
    // Fetch Status Form
    _fetchStatusForm();
    super.initState();
  }

  // Fetch Status Form using userAuthData
  Future<void> _fetchStatusForm() async {
    try {
      // Open Hive box
      await HiveService.openBox(AppDBConstants.userBox);

      // Fetch stored userAuthData
      final storedUserMap = await HiveService.getData<Map<String, dynamic>>(
        boxName: AppDBConstants.userBox,
        key: AppDBConstants.userAuthData,
      );

      if (storedUserMap != null) {
        // Convert Map → UserAuthModel
        final storedUser = UserAuthModel.fromJson(storedUserMap);

        userId = storedUser.id;

        AppLoggerHelper.logInfo("User ID fetched from userAuthData: $userId");

        // Dispatch event to fetch status form
        context.read<StatusFormBloc>().add(GetStatusFormEvent(userId: userId!));
      } else {
        AppLoggerHelper.logError("No userAuthData found in Hive!");
      }
    } catch (e) {
      AppLoggerHelper.logError("Error fetching userAuthData: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    // App Localization
    final appLoc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColorConstants.secondaryColor,
      appBar: KAppBar(
        title: appLoc.status,
        onBack: () {
          // Back
          GoRouter.of(context).pop();
        },
      ),

      body: RefreshIndicator.adaptive(
        color: AppColorConstants.secondaryColor,
        backgroundColor: AppColorConstants.primaryColor,
        onRefresh: () async {
          // Fetch Status Data
          _fetchStatusForm();
        },
        child: BlocBuilder<ConnectivityBloc, ConnectivityState>(
          builder: (context, connectivityState) {
            if (connectivityState is ConnectivityFailure) {
              return Align(
                alignment: Alignment.center,
                heightFactor: 3,
                child: const KInternetFound(),
              );
            } else if (connectivityState is ConnectivitySuccess) {
              return BlocBuilder<StatusFormBloc, StatusFormState>(
                builder: (context, state) {
                  if (state is StatusFormLoading) {
                    return isTablet
                        ? GridView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
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
                            itemCount: 40,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 18,
                                  mainAxisSpacing: 18,
                                  childAspectRatio: 1.8,
                                ),
                            itemBuilder: (context, index) {
                              return Skeletonizer(
                                effect: ShimmerEffect(),
                                enabled: true,
                                child: StatusCard(
                                  formTitle: "",
                                  formNo: '',
                                  formSerialNo: '',
                                  formType: '',
                                  formPatientStatus: '',
                                  doctorStatus: '',
                                  status: '',
                                  onTap: () {},
                                ),
                              );
                            },
                          )
                        : ListView.separated(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
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
                            itemBuilder: (context, index) {
                              return Skeletonizer(
                                effect: ShimmerEffect(),
                                enabled: true,
                                child: StatusCard(
                                  onTap: () {},
                                  formTitle: "",
                                  formNo: '',
                                  formSerialNo: '',
                                  formType: '',
                                  formPatientStatus: '',
                                  doctorStatus: '',
                                  status: '',
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(height: 20);
                            },
                            itemCount: 40,
                          );
                  }

                  if (state is StatusFormSuccess) {
                    return state.status.isEmpty
                        ? Center(child: KNoItemsFound())
                        : isTablet
                        ? GridView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: const BouncingScrollPhysics(),
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
                            itemCount: state.status.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 18,
                                  mainAxisSpacing: 18,
                                  childAspectRatio: 1.8,
                                ),
                            itemBuilder: (context, index) {
                              final statusItem = state.status[index];

                              return StatusCard(
                                onTap: () {
                                  // Status Summary Screen
                                  GoRouter.of(
                                    context,
                                  ).pushNamed(AppRouterConstants.statusSummary);
                                },
                                formTitle: statusItem.title,
                                formNo: statusItem.formNo,
                                formSerialNo: statusItem.formSerialNo,
                                formType: statusItem.formType,
                                formPatientStatus: statusItem.patientStatusForm,
                                doctorStatus: statusItem.formStatus,
                                status: statusItem.status,
                              );
                            },
                          )
                        : isMobile
                        ? ListView.separated(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
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
                            itemBuilder: (context, index) {
                              final statusItem = state.status[index];

                              return StatusCard(
                                onTap: () {
                                  // Status Summary Screen
                                  GoRouter.of(context).pushNamed(
                                    AppRouterConstants.statusSummary,
                                    extra: statusItem.id,
                                  );
                                },
                                formTitle: statusItem.title,
                                formNo: statusItem.formNo,
                                formSerialNo: statusItem.formSerialNo,
                                formType: statusItem.formType,
                                formPatientStatus: statusItem.patientStatusForm,
                                doctorStatus: statusItem.formStatus,
                                status: statusItem.status,
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(height: 20);
                            },
                            itemCount: state.status.length,
                          )
                        : SizedBox.shrink();
                  }

                  if (state is StatusFormFailure) {
                    AppLoggerHelper.logError("Status Error: ${state.message}");

                    return Align(
                      alignment: Alignment.center,
                      heightFactor: 3,
                      child: KNoItemsFound(
                        noItemsSvg: AppAssetsConstants.failure,
                        noItemsFoundText: appLoc.somethingWentWrong,
                      ),
                    );
                  }

                  return SizedBox.shrink();
                },
              );
            } else {
              return SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
