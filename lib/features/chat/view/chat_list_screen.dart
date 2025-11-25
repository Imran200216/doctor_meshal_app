import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_app_bar.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_floating_action_btn.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_no_items_found.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_text_form_field.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_assets_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_db_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_router_constants.dart';
import 'package:meshal_doctor_booking_app/core/service/hive_service.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';
import 'package:meshal_doctor_booking_app/features/chat/view_model/bloc/query_view_user_chat_home/query_view_user_chat_home_bloc.dart';
import 'package:meshal_doctor_booking_app/features/chat/widgets/chat_list_tile.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';
import 'package:meshal_doctor_booking_app/features/chat/view_model/bloc/view_user_chat_home/view_user_chat_home_bloc.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  String? userId;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    AppLoggerHelper.logInfo('🎬 ChatListScreen initState called');

    // Start Subscription
    _startSubscription();
  }

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

        // // 🔥 Delay only first time
        // Future.delayed(const Duration(seconds: 3), () {
        //   AppLoggerHelper.logInfo(
        //     "⏳ 3 sec delay → GetViewUserChatHomeEvent dispatched from initState",
        //   );
        //
        //   context.read<ViewUserChatHomeBloc>().add(
        //     GetViewUserChatHomeEvent(userId: userId!),
        //   );
        // });
      } else {
        AppLoggerHelper.logError('❌ No userId found in Hive');
      }
    } catch (e) {
      AppLoggerHelper.logError('💥 Error starting subscription: $e');
    }
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

    return Scaffold(
      backgroundColor: AppColorConstants.secondaryColor,
      appBar: KAppBar(
        title: appLoc.consultDoctor,
        onBack: () {
          HapticFeedback.heavyImpact();
          GoRouter.of(context).pop();
        },
      ),
      floatingActionButton: KFloatingActionBtn(
        onTap: () {
          GoRouter.of(context).pushNamed(AppRouterConstants.doctorList);
        },
        fabIconPath: AppAssetsConstants.doctor,
        heroTag: "doctorList",
      ),

      // ---------------------- BLOC CONSUMER ---------------------- //
      body: BlocConsumer<ViewUserChatHomeBloc, ViewUserChatHomeState>(
        listener: (context, state) {
          AppLoggerHelper.logInfo('👂 State changed: ${state.runtimeType}');

          if (state is GetViewUserChatHomeFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },

        builder: (context, state) {
          return RefreshIndicator.adaptive(
            onRefresh: () async {
              if (userId != null) {
                context.read<ViewUserChatHomeBloc>().add(
                  GetViewUserChatHomeEvent(userId: userId!),
                );
              }
            },

            // ---------------------- FIX: REBUILD-FRIENDLY LISTVIEW ---------------------- //
            child: ListView(
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
              children: [
                // 🔍 SEARCH BAR
                KTextFormField(
                  prefixIcon: const Icon(Icons.search_outlined),
                  controller: _searchController,
                  hintText: appLoc.search,
                ),
                const SizedBox(height: 20),

                // CHAT LIST BUILDER
                _buildChatList(state, height, appLoc),
              ],
            ),
          );
        },
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
    // Loading state
    if (state is GetViewUserChatHomeLoading) {
      return SizedBox(
        height: height * 0.6,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    // Error state
    if (state is GetViewUserChatHomeFailure) {
      return SizedBox(
        height: height * 0.6,
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
        return SizedBox(
          height: height * 0.6,
          child: Center(
            child: KNoItemsFound(
              noItemsFoundText: appLoc.noChatsFound,
              noItemsSvg: AppAssetsConstants.noChatListFound,
            ),
          ),
        );
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: chatRooms.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final chat = chatRooms[index];

          return ChatListTile(
            onTap: () {
              GoRouter.of(context).pushNamed(AppRouterConstants.chat);
            },
            profileImageUrl: chat.reciever.profileImage,
            name: '${chat.reciever.firstName} ${chat.reciever.lastName}',
            message: chat.lastMessage,
            time: chat.lastMessageTime,
            unreadCount: chat.unReadCount,
          );
        },
      );
    }

    // Default fallback
    return SizedBox(
      height: height * 0.6,
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
