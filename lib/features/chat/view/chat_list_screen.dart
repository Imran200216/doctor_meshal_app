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
  String? userId;
  final TextEditingController _searchController = TextEditingController();

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

    // Screen Height
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
                title = (userType == 'doctor' || userType == 'admin')
                    ? appLoc.patients
                    : appLoc.consultDoctor;
              }

              return KAppBar(
                title: title,
                onBack: () {
                  HapticFeedback.heavyImpact();
                  GoRouter.of(context).pop();
                },
              );
            },
          ),
        ),
        floatingActionButton: BlocBuilder<UserAuthBloc, UserAuthState>(
          builder: (context, state) {
            bool showFab = false;
            if (state is GetUserAuthSuccess) {
              showFab = state.user.userType == 'patient';
            }
            return showFab
                ? KFloatingActionBtn(
                    onTap: () {
                      GoRouter.of(
                        context,
                      ).pushNamed(AppRouterConstants.doctorList);
                    },
                    fabIconPath: AppAssetsConstants.doctor,
                    heroTag: "doctorList",
                  )
                : const SizedBox.shrink();
          },
        ),
        body: BlocConsumer<ViewUserChatHomeBloc, ViewUserChatHomeState>(
          listener: (context, state) {
            AppLoggerHelper.logInfo('👂 Chat State: ${state.runtimeType}');

            if (state is GetViewUserChatHomeFailure) {
              // Only show snackbar for actual errors, not for empty lists
              if (state.message != appLoc.noChatsFound) {
                KSnackBar.error(context, state.message);
              }
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
                  KSnackBar.error(context, appLoc.internetConnection);
                  return;
                }
                if (userId != null) {
                  context.read<ViewUserChatHomeBloc>().add(
                    GetViewUserChatHomeEvent(userId: userId!),
                  );
                }
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
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
                          // Search Bar
                          KTextFormField(
                            prefixIcon: const Icon(Icons.search_outlined),
                            controller: _searchController,
                            hintText: appLoc.search,
                            onChanged: (value) {
                              // Implement search functionality
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Chat List Section
                  _buildChatListContent(state, height, appLoc),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildChatListContent(
    ViewUserChatHomeState state,
    double height,
    AppLocalizations appLoc,
  ) {
    return BlocBuilder<ConnectivityBloc, ConnectivityState>(
      builder: (context, connectivityState) {
        // Handle connectivity states
        if (connectivityState is ConnectivityFailure) {
          return SliverFillRemaining(
            child: FractionallySizedBox(
              heightFactor: 0.6,
              child: const Align(
                alignment: Alignment.center,
                child: KInternetFound(),
              ),
            ),
          );
        }

        // Handle chat states
        if (state is GetViewUserChatHomeLoading) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: KSkeletonRectangle(),
              ),
              childCount: 5,
            ),
          );
        }

        if (state is GetViewUserChatHomeFailure) {
          return SliverFillRemaining(
            child: FractionallySizedBox(
              heightFactor: 0.6,
              child: KNoItemsFound(
                noItemsSvg: AppAssetsConstants.noChatListFound,
                noItemsFoundText: state.message,
              ),
            ),
          );
        }

        if (state is GetViewUserChatHomeSuccess) {
          final chatRooms = state.viewUserChatHomeModel.data;

          if (chatRooms.isEmpty) {
            return SliverFillRemaining(
              child: FractionallySizedBox(
                heightFactor: 0.6,
                child: Center(
                  child: KNoItemsFound(
                    noItemsFoundText: appLoc.noChatsFound,
                    noItemsSvg: AppAssetsConstants.noChatListFound,
                  ),
                ),
              ),
            );
          }

          return SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.isMobile(context)
                  ? 20
                  : Responsive.isTablet(context)
                  ? 140
                  : 160,
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final chat = chatRooms[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ChatListTile(
                    onTap: () async {
                      final senderRoomId = await HiveService.getData(
                        boxName: AppDBConstants.chatRoom,
                        key: AppDBConstants.chatRoomSenderRoomId,
                      );

                      // Get the chat room ID from the model
                      final chatRoomId = chat.chatRoomId?.id;

                      if (chatRoomId == null) {
                        AppLoggerHelper.logError("Chat room ID is null!");
                        return;
                      }

                      // Pass the chat room ID instead of chat.id
                      GoRouter.of(context).pushNamed(
                        AppRouterConstants.homeChat,
                        extra: {
                          "receiverRoomId": chatRoomId,
                          // ← Changed from chat.id to chatRoomId
                          "senderRoomId": senderRoomId!,
                          "userId": userId,
                        },
                      );

                      AppLoggerHelper.logInfo(
                        "Data passing : ChatRoomId: $chatRoomId, SenderRoomId: $senderRoomId, UserId: $userId",
                      );
                    },
                    profileImageUrl: chat.reciever.profileImage,
                    name:
                        '${chat.reciever.firstName} ${chat.reciever.lastName}',
                    message: chat.lastMessage,
                    time: chat.lastMessageTime.toChatTimeFormat(),
                    unreadCount: chat.unReadCount,
                  ),
                );
              }, childCount: chatRooms.length),
            ),
          );
        }

        // Initial state - show loading
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: KSkeletonRectangle(),
            ),
            childCount: 20,
          ),
        );
      },
    );
  }
}
