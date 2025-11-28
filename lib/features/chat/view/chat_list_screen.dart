import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/core/bloc/connectivity/connectivity_bloc.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/core/service/service.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';
import 'package:meshal_doctor_booking_app/features/auth/auth.dart';
import 'package:meshal_doctor_booking_app/features/chat/chat.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  // User Id
  String? userId;

  // Controller
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    AppLoggerHelper.logInfo('🎬 ChatListScreen initState called');

    // Start Subscription
    _startSubscription();
  }

  // Start Subscription Function
  Future<void> _startSubscription() async {
    AppLoggerHelper.logInfo('🚀 Starting unified subscription...');

    try {
      await HiveService.openBox(AppDBConstants.userBox);

      final storedUserId = await HiveService.getData<String>(
        boxName: AppDBConstants.userBox,
        key: AppDBConstants.userId,
      );

      if (storedUserId != null) {
        userId = storedUserId;
        AppLoggerHelper.logInfo('👤 User ID: $userId');

        // First immediate dispatch
        context.read<ViewUserChatHomeBloc>().add(
          GetViewUserChatHomeEvent(userId: userId!),
        );

        AppLoggerHelper.logInfo(
          '📡 Event dispatched: GetViewUserChatHomeEvent',
        );
      } else {
        AppLoggerHelper.logError('❌ No userId found in Hive');
      }
    } catch (e) {
      AppLoggerHelper.logError('💥 Error starting subscription: $e');
    }
  }

  // Stop Subscription Function
  void _stopSubscription() {
    if (mounted) {
      AppLoggerHelper.logInfo('🛑 Stopping chat home subscription');
      context.read<ViewUserChatHomeBloc>().add(
        StopViewUserChatHomeSubscriptionEvent(),
      );
    }
  }

  @override
  void deactivate() {
    // Stop subscription
    _stopSubscription();
    super.deactivate();
  }

  @override
  void dispose() {
    _searchController.dispose();
    AppLoggerHelper.logInfo('🧹 ChatListScreen disposed');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    // Localization
    final appLoc = AppLocalizations.of(context)!;

    // MediaQuery
    final height = MediaQuery.of(context).size.height;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppColorConstants.secondaryColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: BlocBuilder<UserAuthBloc, UserAuthState>(
            builder: (context, state) {
              String title = appLoc.consultDoctor;

              if (state is GetUserAuthSuccess) {
                final userType = state.user.userType;

                if (userType == 'doctor' || userType == 'admin') {
                  // Doctor App Bar Title
                  title = appLoc.patients;
                } else {
                  // Patient App Bar Title
                  title = appLoc.consultDoctor;
                }
              } else if (state is GetUserAuthLoading) {
                title = appLoc.consultDoctor;
              } else if (state is GetUserAuthFailure) {
                title = appLoc.consultDoctor;
              }

              return KAppBar(
                title: title,
                onBack: () {
                  // Haptics
                  HapticFeedback.heavyImpact();

                  // Back
                  GoRouter.of(context).pop();
                },
              );
            },
          ),
        ),
        // Conditionally show FAB only for patients
        floatingActionButton: BlocBuilder<UserAuthBloc, UserAuthState>(
          builder: (context, state) {
            // Default to not showing FAB
            bool showFab = false;

            if (state is GetUserAuthSuccess) {
              final userType = state.user.userType;
              // Show FAB only for patients (not doctors or admins)
              showFab = userType == 'patient';
            }

            return showFab
                ? KFloatingActionBtn(
                    onTap: () {
                      // Doctor List
                      GoRouter.of(
                        context,
                      ).pushNamed(AppRouterConstants.doctorList);
                    },
                    fabIconPath: AppAssetsConstants.doctor,
                    heroTag: "doctorList",
                  )
                : const SizedBox.shrink(); // Hide FAB for doctors/admins
          },
        ),

        body: BlocConsumer<ViewUserChatHomeBloc, ViewUserChatHomeState>(
          listener: (context, state) {
            AppLoggerHelper.logInfo('👂 State changed: ${state.runtimeType}');

            if (state is GetViewUserChatHomeFailure) {
              KSnackBar.error(context, state.message);
            }
          },

          builder: (context, state) {
            return RefreshIndicator.adaptive(
              color: AppColorConstants.secondaryColor,
              backgroundColor: AppColorConstants.primaryColor,
              onRefresh: () async {
                final connectivityState = context
                    .read<ConnectivityBloc>()
                    .state;
                if (connectivityState is ConnectivityFailure) {
                  AppLoggerHelper.logError("No internet connection");
                  KSnackBar.error(context, appLoc.internetConnection);
                  return;
                }

                // Get View User Chat Home Event Subscription
                if (userId != null) {
                  context.read<ViewUserChatHomeBloc>().add(
                    GetViewUserChatHomeEvent(userId: userId!),
                  );
                }
              },

              // ---------------------- FIXED: USING SINGLE CHILD SCROLL VIEW ---------------------- //
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile
                      ? 20
                      : isTablet
                      ? 140
                      : 160,
                  vertical: isMobile
                      ? 30
                      : isTablet
                      ? 60
                      : 80,
                ),
                child: Column(
                  children: [
                    // 🔍 SEARCH BAR
                    KTextFormField(
                      prefixIcon: const Icon(Icons.search_outlined),
                      controller: _searchController,
                      hintText: appLoc.search,
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 20),

                    // Wrap only the chat list with Connectivity BlocBuilder
                    BlocBuilder<ConnectivityBloc, ConnectivityState>(
                      builder: (context, connectivityState) {
                        if (connectivityState is ConnectivityFailure) {
                          return FractionallySizedBox(
                            heightFactor: height * 0.6,
                            child: const Align(
                              alignment: Alignment.center,
                              child: KInternetFound(),
                            ),
                          );
                        } else if (connectivityState is ConnectivitySuccess) {
                          return _buildChatList(state, height, appLoc);
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // CHAT LIST BUILDER
  // ---------------------------------------------------------
  Widget _buildChatList(
    ViewUserChatHomeState state,
    double height,
    AppLocalizations appLoc,
  ) {
    // Loading state - FIXED: Using Column instead of ListView
    if (state is GetViewUserChatHomeLoading) {
      return Column(
        children: List.generate(30, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: KSkeletonRectangle(),
          );
        }),
      );
    }

    // Error state
    if (state is GetViewUserChatHomeFailure) {
      return FractionallySizedBox(
        heightFactor: height * 0.6,
        child: KNoItemsFound(
          noItemsSvg: AppAssetsConstants.noChatListFound,
          noItemsFoundText: state.message,
        ),
      );
    }

    // SUCCESS STATE (subscription data)
    if (state is GetViewUserChatHomeSuccess) {
      final chatRooms = state.viewUserChatHomeModel.data;

      if (chatRooms.isEmpty) {
        return FractionallySizedBox(
          heightFactor: height * 0.6,
          child: Center(
            child: KNoItemsFound(
              noItemsFoundText: appLoc.noChatsFound,
              noItemsSvg: AppAssetsConstants.noChatListFound,
            ),
          ),
        );
      }

      // FIXED: Using Column instead of nested ListView
      return Column(
        children: [
          for (final chat in chatRooms)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ChatListTile(
                onTap: () async {
                  // Sender Room Id in hive
                  final senderRoomId = await HiveService.getData(
                    boxName: AppDBConstants.chatRoom,
                    key: AppDBConstants.chatRoomSenderRoomId,
                  );

                  // Chat Screen
                  GoRouter.of(context).pushNamed(
                    AppRouterConstants.chat,
                    extra: {
                      "receiverRoomId": chat.id,
                      "senderRoomId": senderRoomId,
                      "userId": userId,
                    },
                  );
                },
                profileImageUrl: chat.reciever.profileImage,
                name: '${chat.reciever.firstName} ${chat.reciever.lastName}',
                message: chat.lastMessage,
                time: chat.lastMessageTime.toChatTimeFormat(),
                unreadCount: chat.unReadCount,
              ),
            ),
        ],
      );
    }

    // Default fallback
    return Column(
      children: List.generate(30, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: KSkeletonRectangle(),
        );
      }),
    );
  }
}
