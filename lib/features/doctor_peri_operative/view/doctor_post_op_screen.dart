import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/core/bloc/connectivity/connectivity_bloc.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/core/service/service.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';
import 'package:meshal_doctor_booking_app/features/doctor_peri_operative/doctor_peri_operative.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:meshal_doctor_booking_app/features/auth/auth.dart';

class DoctorPostOpScreen extends StatefulWidget {
  const DoctorPostOpScreen({super.key});

  @override
  State<DoctorPostOpScreen> createState() => _DoctorPostOpScreenState();
}

class _DoctorPostOpScreenState extends State<DoctorPostOpScreen> {
  // User Id
  String? userId;

  // Debounce
  Timer? _debounce;

  // Controller
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _fetchDoctorPostOperative();

    super.initState();
  }

  // Fetch Post Operative Form
  Future<void> _fetchDoctorPostOperative() async {
    try {
      // Open the Hive box if not already opened
      await HiveService.openBox(AppDBConstants.userBox);

      // Read full userAuthData from Hive (no generic type)
      final storedUserMapRaw = await HiveService.getData(
        boxName: AppDBConstants.userBox,
        key: AppDBConstants.userAuthData,
      );

      if (storedUserMapRaw != null) {
        // Safely convert dynamic map → Map<String, dynamic>
        final storedUserMap = Map<String, dynamic>.from(storedUserMapRaw);

        // Convert Map → UserAuthModel
        final storedUser = UserAuthModel.fromJson(storedUserMap);
        userId = storedUser.id;

        AppLoggerHelper.logInfo("User ID fetched from userAuthData: $userId");

        // Trigger Post-Operative Form Event
        context.read<ViewDoctorOperativeFormBloc>().add(
          GetViewDoctorOperativeFormEvent(doctorId: userId!, formType: "post"),
        );
      } else {
        AppLoggerHelper.logError("No userAuthData found in Hive!");
      }
    } catch (e) {
      AppLoggerHelper.logError("Error fetching User ID from userAuthData: $e");
    }
  }

  // Debounce Search Changed
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (userId != null) {
        context.read<ViewDoctorOperativeFormBloc>().add(
          SearchDoctorOperativeFormEvent(
            search: query,
            doctorId: userId!,
            formType: "post",
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
        title: appLoc.postOperative,
        onBack: () {
          // Back
          GoRouter.of(context).pop();
        },
      ),

      body: RefreshIndicator.adaptive(
        color: AppColorConstants.secondaryColor,
        backgroundColor: AppColorConstants.primaryColor,
        onRefresh: () async {
          final connectivityState = context.read<ConnectivityBloc>().state;

          // Correct internet check
          if (connectivityState is ConnectivityFailure ||
              (connectivityState is ConnectivitySuccess &&
                  connectivityState.isConnected == false)) {
            KSnackBar.error(context, appLoc.noInternet);
            return;
          }

          // Fetch Post Operative Form
          _fetchDoctorPostOperative();
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Search
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: KTextFormField(
                  prefixIcon: Icon(Icons.search_outlined),
                  controller: _searchController,
                  onChanged: (value) {
                    _onSearchChanged(value);
                  },
                  hintText: appLoc.searchPostOperativeForms,
                  keyboardType: TextInputType.name,
                  autofillHints: [
                    AutofillHints.name,
                    AutofillHints.familyName,
                    AutofillHints.givenName,
                    AutofillHints.middleName,
                    AutofillHints.nickname,
                    AutofillHints.username,
                  ],
                ),
              ),

              BlocBuilder<ConnectivityBloc, ConnectivityState>(
                builder: (context, connectivityState) {
                  if (connectivityState is ConnectivityFailure) {
                    return Align(
                      alignment: Alignment.center,
                      heightFactor: 3,
                      child: const KInternetFound(),
                    );
                  } else if (connectivityState is ConnectivitySuccess) {
                    return BlocBuilder<ConnectivityBloc, ConnectivityState>(
                      builder: (context, connectivityState) {
                        if (connectivityState is ConnectivityFailure) {
                          return Align(
                            alignment: Alignment.center,
                            heightFactor: 3,
                            child: const KInternetFound(),
                          );
                        } else if (connectivityState is ConnectivitySuccess) {
                          return BlocBuilder<
                            ViewDoctorOperativeFormBloc,
                            ViewDoctorOperativeFormState
                          >(
                            builder: (context, state) {
                              // Loading State (Initial Load)
                              if (state is GetViewDoctorOperativeFormLoading) {
                                return _buildLoadingSkeleton(
                                  isTablet,
                                  isMobile,
                                );
                              }

                              // Search Loading State
                              if (state is SearchDoctorOperativeFormLoading) {
                                return _buildLoadingSkeleton(
                                  isTablet,
                                  isMobile,
                                );
                              }

                              // Success State (Initial Load)
                              if (state is GetViewDoctorOperativeFormSuccess) {
                                final operativeFormEvents = state.forms.forms;
                                return _buildFormList(
                                  operativeFormEvents,
                                  isTablet,
                                  isMobile,
                                  context,
                                );
                              }

                              // Search Success State
                              if (state is SearchDoctorOperativeFormSuccess) {
                                final operativeFormEvents = state.forms.forms;
                                return _buildFormList(
                                  operativeFormEvents,
                                  isTablet,
                                  isMobile,
                                  context,
                                );
                              }

                              // Search Failure State
                              if (state is SearchDoctorOperativeFormFailure) {
                                AppLoggerHelper.logError(
                                  "Search Error: ${state.message}",
                                );
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Text(
                                      state.message,
                                      style: TextStyle(color: Colors.red),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              }

                              // Initial Failure State
                              if (state is GetViewDoctorOperativeFormFailure) {
                                AppLoggerHelper.logError(
                                  "Error: ${state.message}",
                                );
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Text(
                                      state.message,
                                      style: TextStyle(color: Colors.red),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              }

                              return const SizedBox.shrink();
                            },
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build loading skeleton
  Widget _buildLoadingSkeleton(bool isTablet, bool isMobile) {
    return isTablet
        ? GridView.builder(
            physics: NeverScrollableScrollPhysics(),
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
            itemCount: 40,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 18,
              mainAxisSpacing: 18,
              childAspectRatio: 1.8,
            ),
            itemBuilder: (context, index) {
              return Skeletonizer(
                effect: ShimmerEffect(),
                enabled: true,
                child: DoctorOperativeFormCard(
                  onTap: () {},
                  formTitle: '',
                  patientName: '',
                  formStatusSubmitted: '',
                  formSubmittedDate: '',
                ),
              );
            },
          )
        : ListView.separated(
            physics: NeverScrollableScrollPhysics(),
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
                child: DoctorOperativeFormCard(
                  onTap: () {},
                  formTitle: '',
                  patientName: '',
                  formStatusSubmitted: '',
                  formSubmittedDate: '',
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 20);
            },
            itemCount: 40,
          );
  }

  // Helper method to build form list
  Widget _buildFormList(
    List<dynamic> operativeFormEvents,
    bool isTablet,
    bool isMobile,
    BuildContext context,
  ) {
    if (operativeFormEvents.isEmpty) {
      return KNoItemsFound();
    }

    return isTablet
        ? GridView.builder(
            physics: NeverScrollableScrollPhysics(),
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
            itemCount: operativeFormEvents.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 18,
              mainAxisSpacing: 18,
              childAspectRatio: 1.8,
            ),
            itemBuilder: (context, index) {
              final item = operativeFormEvents[index];
              return DoctorOperativeFormCard(
                onTap: () {
                  GoRouter.of(context).pushNamed(
                    AppRouterConstants.doctorOperativeSummary,
                    extra: item.id,
                  );
                },
                formTitle: item.title,
                patientName: "${item.user.firstName} ${item.user.lastName}",
                formStatusSubmitted: item.formStatus,
                formSubmittedDate: item.createdAtTime,
              );
            },
          )
        : ListView.separated(
            physics: NeverScrollableScrollPhysics(),
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
              final item = operativeFormEvents[index];
              return DoctorOperativeFormCard(
                onTap: () {
                  GoRouter.of(context).pushNamed(
                    AppRouterConstants.doctorOperativeSummary,
                    extra: item.id,
                  );
                },
                formTitle: item.title,
                patientName: "${item.user.firstName} ${item.user.lastName}",
                formStatusSubmitted: item.formStatus,
                formSubmittedDate: item.createdAtTime,
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 20);
            },
            itemCount: operativeFormEvents.length,
          );
  }
}
