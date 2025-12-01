import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:chat_bubbles/date_chips/date_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/features/chat/model/view_user_chat_message_model.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';
import 'package:meshal_doctor_booking_app/features/chat/chat.dart';

class HomeChatScreen extends StatefulWidget {
  final String senderRoomId;
  final String receiverRoomId;
  final String userId;

  const HomeChatScreen({
    super.key,
    required this.senderRoomId,
    required this.receiverRoomId,
    required this.userId,
  });

  @override
  State<HomeChatScreen> createState() => _HomeChatScreenState();
}

class _HomeChatScreenState extends State<HomeChatScreen>
    with WidgetsBindingObserver {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  // Track the last stable message count to prevent flickering
  int _lastStableMessageCount = 0;
  bool _isSubscriptionStable = false;
  List<ChatMessage> _cachedMessages = [];

  // Track if we're already subscribed to prevent duplicate subscriptions
  bool _isSubscribed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Start subscription with a small delay to ensure proper initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startSubscription();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Check if we already have data from the previous screen
    _checkForExistingData();
  }

  void _checkForExistingData() {
    final currentState = context.read<SubscribeChatMessageBloc>().state;

    if (currentState is GetSubscribeChatMessageSuccess) {
      final messages = currentState.chatMessage.messages;
      if (messages.isNotEmpty && !_isSubscriptionStable) {
        _cachedMessages = List.from(messages);
        _lastStableMessageCount = messages.length;
        _isSubscriptionStable = true;
        AppLoggerHelper.logInfo(
          '📥 Using existing subscription data with ${messages.length} messages',
        );
      }
    }
  }

  void _startSubscription() {
    if (_isSubscribed) {
      AppLoggerHelper.logInfo('🔄 Already subscribed, skipping...');
      return;
    }

    AppLoggerHelper.logInfo('🚀 Starting chat subscription');
    _isSubscribed = true;

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

    if (message.isEmpty) {
      return;
    }

    AppLoggerHelper.logInfo('📤 Sending message: $message');

    // Send Chat Message
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
    _sendMessage();
  }

  void _scrollToBottom() {
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

  // Stop Subscription Function
  void _stopSubscription() {
    if (mounted) {
      AppLoggerHelper.logInfo('🛑 Stopping chat home subscription');
      context.read<SubscribeChatMessageBloc>().add(
        StopSubscribeChatMessageEvent(),
      );
    }
  }

  @override
  void deactivate() {
    _stopSubscription();
    super.deactivate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _messageController.dispose();
    _messageFocusNode.dispose();
    _scrollController.dispose();

    // Don't stop subscription here to maintain WebSocket connection
    // This prevents disconnection when navigating back to chat list
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);
    final appLoc = AppLocalizations.of(context)!;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppColorConstants.secondaryColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child:
              BlocBuilder<SubscribeChatMessageBloc, SubscribeChatMessageState>(
                builder: (context, state) {
                  String title = "Chat";
                  String status = "Connecting...";

                  if (state is GetSubscribeChatMessageSuccess) {
                    final isReceiverOnline = state.chatMessage.isReceiverOnline;
                    final receiverName = state.chatMessage.receiverName;
                    title = receiverName;
                    status = isReceiverOnline ? "Online" : "Offline";
                  }

                  return KAppBar(
                    centerTitle: false,
                    backgroundColor: AppColorConstants.primaryColor,
                    title: title,
                    description: status,
                    onBack: () {
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
              // Messages Display
              Expanded(
                flex: 9,
                child: BlocConsumer<SubscribeChatMessageBloc, SubscribeChatMessageState>(
                  listenWhen: (previous, current) => true,
                  listener: (context, state) {
                    if (state is GetSubscribeChatMessageSuccess) {
                      final messageCount = state.chatMessage.messages.length;
                      AppLoggerHelper.logInfo(
                        "📥 Subscription updated with $messageCount messages (Previous: $_lastStableMessageCount)",
                      );

                      // Check if this is a stable update (not flickering)
                      if (messageCount > 0 &&
                          messageCount != _lastStableMessageCount) {
                        _lastStableMessageCount = messageCount;
                        _cachedMessages = List.from(state.chatMessage.messages);
                        _isSubscriptionStable = true;

                        // Scroll to bottom when we get new stable messages
                        _scrollToBottom();
                      } else if (messageCount == 0 &&
                          _lastStableMessageCount > 0) {
                        // Ignore 0 message updates if we already have messages
                        AppLoggerHelper.logInfo(
                          "🔄 Ignoring flickering 0-message update",
                        );
                      }
                    } else if (state is GetSubscribeChatMessageError) {
                      AppLoggerHelper.logError(
                        "❌ Subscription error: ${state.message}",
                      );
                    }
                  },
                  builder: (context, subscriptionState) {
                    AppLoggerHelper.logInfo(
                      "🎨 BUILDER - State: ${subscriptionState.runtimeType}",
                    );

                    // Use cached messages to prevent flickering
                    if (_isSubscriptionStable && _cachedMessages.isNotEmpty) {
                      AppLoggerHelper.logInfo(
                        "✅ USING CACHED - Rendering ${_cachedMessages.length} stable messages",
                      );
                      return _buildMessageList(
                        _cachedMessages,
                        appLoc,
                        isMobile,
                        isTablet,
                      );
                    }

                    // Loading state
                    if (subscriptionState is GetSubscribeChatMessageLoading) {
                      AppLoggerHelper.logInfo("⏳ Showing loading state");
                      return _buildLoadingState();
                    }

                    // Success state - Use actual state data if no cache
                    if (subscriptionState is GetSubscribeChatMessageSuccess) {
                      final chatData = subscriptionState.chatMessage;
                      final messages = chatData.messages;

                      // Only update cache if we have messages and they're different
                      if (messages.isNotEmpty && !_isSubscriptionStable) {
                        _cachedMessages = List.from(messages);
                        _lastStableMessageCount = messages.length;
                        _isSubscriptionStable = true;
                      }

                      AppLoggerHelper.logInfo(
                        "✅ SUCCESS - Rendering ${messages.length} messages from subscription",
                      );

                      return _buildMessageList(
                        messages,
                        appLoc,
                        isMobile,
                        isTablet,
                      );
                    }

                    // Error state
                    if (subscriptionState is GetSubscribeChatMessageError) {
                      AppLoggerHelper.logInfo("❌ Showing error state");
                      return _buildErrorState(
                        'Connection Error: ${subscriptionState.message}',
                        true,
                      );
                    }

                    // Initial/Unknown state
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

  // ... rest of your methods remain the same (_buildMessageInput, _buildMessageList, etc.)
  Widget _buildMessageInput(
    bool isMobile,
    bool isTablet,
    AppLocalizations appLoc,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      color: AppColorConstants.secondaryColor,
      child: Row(
        children: [
          // Message Text Field
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

          // Send Button
          BlocListener<SendChatMessageBloc, SendChatMessageState>(
            listener: (context, state) {
              if (state is SendChatMessageFuncFailure) {
                KSnackBar.error(
                  context,
                  'Failed to send message: ${state.message}',
                );
              } else if (state is SendChatMessageFuncSuccess) {
                AppLoggerHelper.logInfo('✅ Message sent successfully');
              }
            },
            child: GestureDetector(
              onTap: () {
                HapticFeedback.heavyImpact();
                _sendMessage();
              },
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

  Widget _buildMessageList(
    List<ChatMessage> messages,
    AppLocalizations appLoc,
    bool isMobile,
    bool isTablet,
  ) {
    AppLoggerHelper.logInfo('💬 Building ${messages.length} messages');

    if (messages.isEmpty) {
      return Center(
        child: KNoItemsFound(
          noItemsFoundText: appLoc.noChatsFound,
          noItemsSvg: AppAssetsConstants.noChatFound,
        ),
      );
    }

    // Group messages by date and create a flat list with date chips
    final List<Widget> messageWidgets = [];
    String? currentDateKey;

    for (final message in messages) {
      final messageDate = DateTime.parse(message.time);
      final dateKey =
          '${messageDate.year}-${messageDate.month}-${messageDate.day}';

      // Add DateChip when date changes
      if (dateKey != currentDateKey) {
        currentDateKey = dateKey;
        messageWidgets.add(
          DateChip(date: messageDate, color: const Color(0x558AD3D5)),
        );
      }

      final isMe = message.type == "SEND";

      messageWidgets.add(
        Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: isMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              /// 💬 Chat Bubble
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

              /// 🕒 Formatted Time
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

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        return false;
      },
      child: ListView(
        controller: _scrollController,
        reverse: true,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        children: messageWidgets.reversed.toList(),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [const CircularProgressIndicator.adaptive()],
      ),
    );
  }

  Widget _buildErrorState(String errorMessage, bool isSubscriptionError) {
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
            isSubscriptionError ? "Connection Error" : "Load Error",
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
            onPressed: _startSubscription,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry Connection'),
          ),
        ],
      ),
    );
  }
}
