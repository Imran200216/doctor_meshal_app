import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/core/bloc/connectivity/connectivity_bloc.dart';
import 'package:meshal_doctor_booking_app/features/notification/notification.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';
import 'package:meshal_doctor_booking_app/core/service/service.dart';
import 'package:meshal_doctor_booking_app/features/auth/auth.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // UserId
  String? userId;

  @override
  void initState() {
    _fetchUserIdAndLoadNotifications();
    super.initState();
  }

  // Fetch User Auth Data and Doctor Patient Feedbacks
  Future<void> _fetchUserIdAndLoadNotifications() async {
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

        // Trigger View All Notification
        context.read<ViewAllNotificationBloc>().add(
          GetViewAllNotificationEvent(userId: userId!),
        );
      } else {
        AppLoggerHelper.logError("No userAuthData found in Hive!");
      }
    } catch (e) {
      AppLoggerHelper.logError("Error fetching User ID from userAuthData: $e");
    }
  }

  // Fetch User Id and Load Notification Un Read Count
  Future<void> _fetchUserIdAndLoadNotificationsUnReadCount() async {
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

        // Trigger View All Notification
        context.read<ViewNotificationUnReadCountBloc>().add(
          GetViewNotificationUnReadCountEvent(userId: userId!),
        );
      } else {
        AppLoggerHelper.logError("No userAuthData found in Hive!");
      }
    } catch (e) {
      AppLoggerHelper.logError("Error fetching User ID from userAuthData: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // App Localization
    final appLoc = AppLocalizations.of(context)!;

    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: KAppBar(
          title: appLoc.notificationTitle,

          onBack: () {
            _fetchUserIdAndLoadNotificationsUnReadCount();

            // Back
            GoRouter.of(context).pop();
          },
          centerTitle: true,
        ),

        body: RefreshIndicator.adaptive(
          color: AppColorConstants.secondaryColor,
          backgroundColor: AppColorConstants.primaryColor,
          onRefresh: () async {
            final internetState = context.read<ConnectivityBloc>().state;

            if (internetState is ConnectivityFailure) {
              KSnackBar.error(context, appLoc.noItemsFound);
              return;
            }

            if (internetState is ConnectivitySuccess) {
              await _fetchUserIdAndLoadNotifications();
            }
          },

          child: BlocBuilder<ConnectivityBloc, ConnectivityState>(
            builder: (context, connectivityState) {
              // Internet Connection Success State
              if (connectivityState is ConnectivitySuccess) {
                return BlocBuilder<
                  ViewAllNotificationBloc,
                  ViewAllNotificationState
                >(
                  builder: (context, state) {
                    // Loading State
                    if (state is ViewAllNotificationLoading) {
                      return ListView.separated(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        itemCount: 30,
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 12);
                        },
                        itemBuilder: (context, index) {
                          return KSkeletonRectangle(
                            height: isMobile
                                ? 80
                                : isTablet
                                ? 90
                                : 100,
                            width: double.maxFinite,
                          );
                        },
                      );
                    }

                    // Loaded State
                    if (state is ViewAllNotificationLoaded) {
                      final item = state.notificationResponse.notifications;

                      if (item.isEmpty) {
                        return Align(
                          heightFactor: 0.4,
                          alignment: Alignment.center,
                          child: KNoItemsFound(),
                        );
                      }

                      return ListView.separated(
                        scrollDirection: Axis.vertical,
                        physics: AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        itemBuilder: (context, index) {
                          final notificationItem =
                              state.notificationResponse.notifications[index];

                          return NotificationListTile(
                            notificationTitle: notificationItem.title,
                            notificationDescription:
                                notificationItem.description,
                            notificationDateReceived: notificationItem.createdAt
                                .toIso8601String()
                                .toChatTimeFormat(),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            height: 1,
                            color: AppColorConstants.subTitleColor.withOpacity(
                              0.2,
                            ),
                          );
                        },
                        itemCount:
                            state.notificationResponse.notifications.length,
                      );
                    }

                    // Failure State
                    if (state is ViewAllNotificationFailure) {
                      return Align(
                        heightFactor: 4,
                        alignment: Alignment.center,
                        child: KNoItemsFound(
                          noItemsSvg: AppAssetsConstants.failure,
                          noItemsFoundText: appLoc.somethingWentWrong,
                        ),
                      );
                    }

                    return SizedBox.shrink();
                  },
                );
              }

              // Internet Connection Failure State
              if (connectivityState is ConnectivityFailure) {
                return Align(
                  heightFactor: 0.4,
                  alignment: Alignment.center,
                  child: KNoItemsFound(
                    noItemsSvg: AppAssetsConstants.noInternetFound,
                    noItemsFoundText: appLoc.noInternet,
                  ),
                );
              }

              return SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
