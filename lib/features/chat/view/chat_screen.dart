import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:chat_bubbles/date_chips/date_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/core/service/hive_service.dart';
import 'package:meshal_doctor_booking_app/features/chat/model/view_user_chat_message_model.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';
import 'package:meshal_doctor_booking_app/features/chat/chat.dart';

import '../../auth/auth.dart';

class ChatScreen extends StatefulWidget {
  final String senderRoomId;
  final String receiverRoomId;
  final String userId;

  const ChatScreen({
    super.key,
    required this.senderRoomId,
    required this.receiverRoomId,
    required this.userId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  bool _isSubscribed = false;

  // User Id
  String? userId;

  // Fetch User Id
  Future<void> _fetchUserId() async {
    try {
      // Fetch stored userAuthData
      final storedUserMapRaw = await HiveService.getData(
        boxName: AppDBConstants.userBox,
        key: AppDBConstants.userAuthData,
      );

      if (storedUserMapRaw != null) {
        // Safely convert dynamic map → Map<String, dynamic>
        final storedUserMap = Map<String, dynamic>.from(storedUserMapRaw);

        // Convert Map → UserAuthModel
        final storedUser = UserAuthModel.fromJson(storedUserMap);
        setState(() {
          userId = storedUser.id;
        });

        AppLoggerHelper.logInfo("User ID from userAuthData: $userId");
      } else {
        AppLoggerHelper.logError("No user data found in Hive");
      }
    } catch (e, stackTrace) {
      AppLoggerHelper.logError("Error fetching user ID: $e");
      AppLoggerHelper.logError("Stack trace: $stackTrace");
    }
  }

  @override
  void initState() {
    super.initState();
    AppLoggerHelper.logInfo('ChatScreen initState called');
    AppLoggerHelper.logInfo('senderRoomId: ${widget.senderRoomId}');
    AppLoggerHelper.logInfo('receiverRoomId: ${widget.receiverRoomId}');
    AppLoggerHelper.logInfo('userId: ${widget.userId}');

    WidgetsBinding.instance.addObserver(this);

    _fetchUserId();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppLoggerHelper.logInfo('addPostFrameCallback - Starting subscription');
      _startSubscription();
    });
  }

  void _stopSubscription() {
    AppLoggerHelper.logInfo('_stopSubscription called');
    if (mounted) {
      context.read<SubscribeChatMessageBloc>().add(
        StopSubscribeChatMessageEvent(),
      );
    }
  }

  @override
  void deactivate() {
    AppLoggerHelper.logInfo('ChatScreen deactivate called');
    _stopSubscription();
    super.deactivate();
  }

  void _startSubscription() {
    AppLoggerHelper.logInfo(
      '_startSubscription called, _isSubscribed: $_isSubscribed',
    );

    if (_isSubscribed) {
      AppLoggerHelper.logInfo('Already subscribed, skipping...');
      return;
    }

    _isSubscribed = true;

    AppLoggerHelper.logInfo('Dispatching StartSubscribeChatMessageEvent with:');
    AppLoggerHelper.logInfo('  senderRoomId: ${widget.senderRoomId}');
    AppLoggerHelper.logInfo('  recieverRoomId: ${widget.receiverRoomId}');
    AppLoggerHelper.logInfo('  userId: ${widget.userId}');

    context.read<SubscribeChatMessageBloc>().add(
      StartSubscribeChatMessageEvent(
        senderRoomId: widget.senderRoomId,
        recieverRoomId: widget.receiverRoomId,
        userId: widget.userId,
      ),
    );
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    AppLoggerHelper.logInfo('_sendMessage called, message: "$message"');

    if (message.isEmpty) {
      AppLoggerHelper.logInfo('Message is empty, returning');
      return;
    }

    AppLoggerHelper.logInfo('Dispatching SendChatMessageFuncEvent with:');
    AppLoggerHelper.logInfo('  senderRoomId: ${widget.senderRoomId}');
    AppLoggerHelper.logInfo('  receiverRoomId: ${widget.receiverRoomId}');
    AppLoggerHelper.logInfo('  message: "$message"');

    context.read<SendChatMessageBloc>().add(
      SendChatMessageFuncEvent(
        senderRoomId: widget.senderRoomId,
        receiverRoomId: widget.receiverRoomId,
        message: message,
      ),
    );

    _messageController.clear();
    _messageFocusNode.requestFocus();
  }

  void _handleSubmitted(String value) {
    AppLoggerHelper.logInfo('_handleSubmitted called with value: "$value"');
    _sendMessage();
  }

  void _scrollToBottom() {
    AppLoggerHelper.logInfo(
      '_scrollToBottom called, hasClients: ${_scrollController.hasClients}',
    );

    if (_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  void dispose() {
    AppLoggerHelper.logInfo('ChatScreen dispose called');
    WidgetsBinding.instance.removeObserver(this);
    _messageController.dispose();
    _messageFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);
    final appLoc = AppLocalizations.of(context)!;

    AppLoggerHelper.logInfo('ChatScreen build called');
    AppLoggerHelper.logInfo('isMobile: $isMobile, isTablet: $isTablet');

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppColorConstants.secondaryColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: BlocBuilder<SubscribeChatMessageBloc, SubscribeChatMessageState>(
            builder: (context, state) {
              String title = "Chat";
              String status = "Connecting...";

              if (state is GetSubscribeChatMessageSuccess) {
                AppLoggerHelper.logInfo(
                  'GetSubscribeChatMessageSuccess received',
                );
                AppLoggerHelper.logInfo(
                  'Receiver name from state: ${state.chatMessage.receiverName}',
                );
                AppLoggerHelper.logInfo(
                  'Is receiver online: ${state.chatMessage.isReceiverOnline}',
                );

                title = state.chatMessage.receiverName;
                status = state.chatMessage.isReceiverOnline
                    ? "Online"
                    : "Offline";
              } else if (state is GetSubscribeChatMessageError) {
                AppLoggerHelper.logError(
                  'GetSubscribeChatMessageError: ${state.message}',
                );
              } else if (state is GetSubscribeChatMessageLoading) {
                AppLoggerHelper.logInfo('GetSubscribeChatMessageLoading state');
              } else {
                AppLoggerHelper.logInfo(
                  'Unknown SubscribeChatMessageState: $state',
                );
              }

              return KAppBar(
                centerTitle: false,
                backgroundColor: AppColorConstants.primaryColor,
                title: title,
                description: status,
                onBack: () {
                  AppLoggerHelper.logInfo('Back button pressed');

                  context.read<ViewUserChatHomeBloc>().add(
                    GetViewUserChatHomeEvent(userId: userId!),
                  );

                  GoRouter.of(context).pop();
                },
              );
            },
          ),
        ),
        body: SafeArea(
          bottom: true,
          child: Column(
            children: [
              Expanded(
                child: BlocConsumer<SubscribeChatMessageBloc, SubscribeChatMessageState>(
                  listener: (context, state) {
                    if (state is GetSubscribeChatMessageSuccess) {
                      AppLoggerHelper.logInfo(
                        'Listener: GetSubscribeChatMessageSuccess, messages count: ${state.chatMessage.messages.length}',
                      );
                      _scrollToBottom();
                    } else if (state is GetSubscribeChatMessageError) {
                      AppLoggerHelper.logError(
                        'Listener: GetSubscribeChatMessageError: ${state.message}',
                      );
                    }
                  },
                  builder: (context, state) {
                    AppLoggerHelper.logInfo(
                      'Builder: Current state: ${state.runtimeType}',
                    );

                    if (state is GetSubscribeChatMessageLoading) {
                      AppLoggerHelper.logInfo('Builder: Loading state');
                      return _buildLoadingState();
                    }

                    if (state is GetSubscribeChatMessageSuccess) {
                      AppLoggerHelper.logInfo(
                        'Builder: Success state, message count: ${state.chatMessage.messages.length}',
                      );
                      AppLoggerHelper.logInfo(
                        'First message details (if any):',
                      );
                      if (state.chatMessage.messages.isNotEmpty) {
                        final firstMessage = state.chatMessage.messages.first;
                        AppLoggerHelper.logInfo(
                          '  Message: ${firstMessage.message}',
                        );
                        AppLoggerHelper.logInfo('  Type: ${firstMessage.type}');
                        AppLoggerHelper.logInfo('  Time: ${firstMessage.time}');
                      }
                      return _buildMessageList(
                        state.chatMessage.messages,
                        appLoc,
                        isMobile,
                        isTablet,
                      );
                    }

                    if (state is GetSubscribeChatMessageError) {
                      AppLoggerHelper.logError(
                        'Builder: Error state - ${state.message}',
                      );
                      return _buildErrorState(
                        'Connection Error: ${state.message}',
                        true,
                      );
                    }

                    AppLoggerHelper.logInfo('Builder: Default loading state');
                    return _buildLoadingState();
                  },
                ),
              ),

              _buildMessageInput(isMobile, isTablet, appLoc),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------
  // Message Input
  // ------------------------
  Widget _buildMessageInput(
    bool isMobile,
    bool isTablet,
    AppLocalizations appLoc,
  ) {
    AppLoggerHelper.logInfo('_buildMessageInput called');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      color: AppColorConstants.secondaryColor,
      child: Row(
        children: [
          Expanded(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: isMobile
                    ? 52
                    : isTablet
                    ? 56
                    : 60,
              ),
              child: ChatMessageTextFormField(
                onSubmitted: _handleSubmitted,
                controller: _messageController,
                hintText: appLoc.typeYourMessage,
              ),
            ),
          ),
          const SizedBox(width: 8),
          BlocListener<SendChatMessageBloc, SendChatMessageState>(
            listener: (context, state) {
              AppLoggerHelper.logInfo(
                'SendChatMessageBloc listener, state: ${state.runtimeType}',
              );

              if (state is SendChatMessageFuncLoading) {
                AppLoggerHelper.logInfo('Sending message...');
              } else if (state is SendChatMessageFuncSuccess) {
                AppLoggerHelper.logInfo('Message sent successfully');
              } else if (state is SendChatMessageFuncFailure) {
                AppLoggerHelper.logError(
                  'Failed to send message: ${state.message}',
                );
                KSnackBar.error(
                  context,
                  'Failed to send message: ${state.message}',
                );
              }
            },
            child: GestureDetector(
              onTap: _sendMessage,
              child: Container(
                width: isMobile
                    ? 48
                    : isTablet
                    ? 52
                    : 56,
                height: isMobile
                    ? 48
                    : isTablet
                    ? 52
                    : 56,
                decoration: BoxDecoration(
                  color: AppColorConstants.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.send,
                  size: isMobile
                      ? 20
                      : isTablet
                      ? 24
                      : 28,
                  color: AppColorConstants.secondaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------
  // Message List
  // ------------------------
  Widget _buildMessageList(
    List<ChatMessage> messages,
    AppLocalizations appLoc,
    bool isMobile,
    bool isTablet,
  ) {
    AppLoggerHelper.logInfo(
      '_buildMessageList called with ${messages.length} messages',
    );

    if (messages.isEmpty) {
      AppLoggerHelper.logInfo('No messages found, showing empty state');
      return Center(
        child: KNoItemsFound(
          noItemsFoundText: appLoc.noChatsFound,
          noItemsSvg: AppAssetsConstants.noChatFound,
        ),
      );
    }

    final List<Widget> messageWidgets = [];
    String? currentDateKey;

    AppLoggerHelper.logInfo('Processing ${messages.length} messages:');

    for (final message in messages) {
      AppLoggerHelper.logInfo('  Message: "${message.message}"');
      AppLoggerHelper.logInfo('  Type: ${message.type}');
      AppLoggerHelper.logInfo('  Time: ${message.time}');

      final msgDate = DateTime.parse(message.time);
      final dateKey = '${msgDate.year}-${msgDate.month}-${msgDate.day}';

      AppLoggerHelper.logInfo('  Date key: $dateKey');

      if (dateKey != currentDateKey) {
        AppLoggerHelper.logInfo(
          '  New date detected, adding DateChip for $dateKey',
        );
        currentDateKey = dateKey;
        messageWidgets.add(
          DateChip(date: msgDate, color: const Color(0x558AD3D5)),
        );
      }

      final isMe = message.type == "SEND";
      AppLoggerHelper.logInfo('  isMe (type == "SEND"): $isMe');

      messageWidgets.add(
        Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: isMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              BubbleSpecialOne(
                tail: true,
                text: message.message,
                isSender: isMe,
                color: isMe
                    ? AppColorConstants.primaryColor
                    : Colors.grey.shade300,
                textStyle: TextStyle(
                  fontSize: 15,
                  color: isMe ? AppColorConstants.secondaryColor : Colors.black,
                ),
                sent: true,
              ),
              const SizedBox(height: 4),
              Text(
                formatMessageTime(message.time),
                style: TextStyle(
                  fontSize: isMobile
                      ? 12
                      : isTablet
                      ? 14
                      : 16,
                  color: isMe
                      ? AppColorConstants.primaryColor
                      : Colors.grey.shade600,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      );
    }

    AppLoggerHelper.logInfo(
      'Total message widgets created: ${messageWidgets.length}',
    );

    return ListView(
      controller: _scrollController,
      reverse: true,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      children: messageWidgets.reversed.toList(),
    );
  }

  Widget _buildLoadingState() {
    AppLoggerHelper.logInfo('_buildLoadingState called');
    return const Center(child: CircularProgressIndicator.adaptive());
  }

  Widget _buildErrorState(String errorMessage, bool isSubscriptionError) {
    AppLoggerHelper.logError('_buildErrorState called: $errorMessage');

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: isSubscriptionError ? Colors.red : Colors.orange,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            "Connection Error",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              errorMessage,
              style: TextStyle(
                color: isSubscriptionError ? Colors.red : Colors.orange,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              AppLoggerHelper.logInfo('Retry button pressed');
              _startSubscription();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Retry Connection'),
          ),
        ],
      ),
    );
  }
}
