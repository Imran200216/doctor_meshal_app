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
import 'package:meshal_doctor_booking_app/features/chat/widgets/chat_list_tile.dart';
import 'package:meshal_doctor_booking_app/features/home/view_model/bloc/user_chat_room/view_user_chat_room_bloc.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';
import 'package:meshal_doctor_booking_app/features/chat/view_model/bloc/view_user_chat_home/view_user_chat_home_bloc.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  // User Id
  String? userId;

  bool _isInitialQueryCalled = false;

  // Controller
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Start the subscription when screen loads
    _startSubscriptionAndThenQuery();
  }

  void _startSubscriptionAndThenQuery() {
    AppLoggerHelper.logInfo('🚀 Starting subscription first...');
    _startChatHomeSubscription();

    // Call query only once after 2 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (!_isInitialQueryCalled) {
        AppLoggerHelper.logInfo(
          '📡 Calling initial query (first time only)...',
        );
        _viewChatRoom();
        _isInitialQueryCalled = true;
      } else {
        AppLoggerHelper.logInfo('⏩ Skipping query - already called initially');
      }
    });
  }

  Future<void> _startChatHomeSubscription() async {
    await HiveService.openBox(AppDBConstants.userBox);

    final storedUserId = await HiveService.getData<String>(
      boxName: AppDBConstants.userBox,
      key: AppDBConstants.userId,
    );

    // Start the subscription
    context.read<ViewUserChatHomeBloc>().add(
      GetViewUserChatHomeEvent(userId: storedUserId!),
    );
  }

  Future<void> _viewChatRoom() async {
    await HiveService.openBox(AppDBConstants.userBox);

    final storedUserId = await HiveService.getData<String>(
      boxName: AppDBConstants.userBox,
      key: AppDBConstants.userId,
    );

    context.read<ViewUserChatRoomBloc>().add(
      GetViewChatRoomEvent(userId: storedUserId!),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    // Stop subscription when screen is disposed
    context.read<ViewUserChatHomeBloc>().add(
      StopViewUserChatHomeSubscriptionEvent(),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    // App Localization
    final appLoc = AppLocalizations.of(context)!;

    // MediaQuery
    final height = MediaQuery.of(context).size.height;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppColorConstants.secondaryColor,
        appBar: KAppBar(
          title: appLoc.consultDoctor,
          onBack: () {
            // Haptics
            HapticFeedback.heavyImpact();

            // Back
            GoRouter.of(context).pop();
          },
        ),
        floatingActionButton: KFloatingActionBtn(
          onTap: () {
            // Doctor List Screen
            GoRouter.of(context).pushNamed(AppRouterConstants.doctorList);
          },
          fabIconPath: AppAssetsConstants.doctor,
          heroTag: "doctorList",
        ),
        body: BlocConsumer<ViewUserChatHomeBloc, ViewUserChatHomeState>(
          listener: (context, state) {
            // Handle state changes if needed
            if (state is GetViewUserChatHomeFailure) {
              // Show error snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${state.message}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return RefreshIndicator.adaptive(
              color: AppColorConstants.secondaryColor,
              backgroundColor: AppColorConstants.primaryColor,
              onRefresh: () async {
                // Refresh by restarting subscription
                _startChatHomeSubscription();
              },
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Search Text Form Field
                      KTextFormField(
                        prefixIcon: const Icon(Icons.search_outlined),
                        controller: _searchController,
                        hintText: appLoc.search,
                        keyboardType: TextInputType.name,
                        autofillHints: const [
                          AutofillHints.name,
                          AutofillHints.familyName,
                          AutofillHints.givenName,
                          AutofillHints.middleName,
                          AutofillHints.nickname,
                          AutofillHints.username,
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Chat List based on BLoC state
                      _buildChatList(state, height, appLoc),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildChatList(
    ViewUserChatHomeState state,
    double height,
    AppLocalizations appLoc,
  ) {
    AppLoggerHelper.logInfo(
      '🔄 Building chat list with state: ${state.runtimeType}',
    );

    if (state is GetViewUserChatHomeLoading) {
      AppLoggerHelper.logInfo('⏳ Chat list loading...');
      return SizedBox(
        height: height * 0.6,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (state is GetViewUserChatHomeFailure) {
      AppLoggerHelper.logError('❌ Chat list error: ${state.message}');
      return SizedBox(
        height: height * 0.6,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
              const SizedBox(height: 16),
              Text(
                'Failed to load chats',
                style: TextStyle(fontSize: 16, color: Colors.red.shade400),
              ),
              const SizedBox(height: 8),
              Text(
                state.message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _startChatHomeSubscription,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (state is GetViewUserChatHomeSuccess) {
      final chatHomeData = state.viewUserChatHomeModel;
      final chatRooms = chatHomeData.data;

      AppLoggerHelper.logInfo(
        '✅ Chat list success - ${chatRooms.length} rooms',
      );

      if (chatRooms.isEmpty) {
        AppLoggerHelper.logInfo('📭 No chat rooms found');
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

      AppLoggerHelper.logInfo(
        '📋 Building list with ${chatRooms.length} items',
      );
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final chatRoom = chatRooms[index];
          AppLoggerHelper.logInfo(
            '👤 Chat room $index: ${chatRoom.receiver.firstName} ${chatRoom.receiver.lastName}',
          );

          return ChatListTile(
            onTap: () {
              // Navigate to chat screen with required parameters
              GoRouter.of(context).pushNamed(AppRouterConstants.chat);
            },
            profileImageUrl: chatRoom.receiver.profileImage,
            name:
                '${chatRoom.receiver.firstName} ${chatRoom.receiver.lastName}',
            message: chatRoom.lastMessage,
            time: chatRoom.lastMessageTime,
            unreadCount: chatRoom.unReadCount,
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 12);
        },
        itemCount: chatRooms.length,
      );
    }

    // Initial state
    AppLoggerHelper.logInfo('⏳ Chat list in initial state');
    return SizedBox(
      height: height * 0.6,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Loading chats...',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
