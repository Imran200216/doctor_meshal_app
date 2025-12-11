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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Start subscription immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startSubscription();
    });
  }

  void _startSubscription() {
    AppLoggerHelper.logInfo('🚀 Starting chat subscription');

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

    AppLoggerHelper.logInfo(
      "The Logs of Chats: ${widget.senderRoomId} and ${widget.receiverRoomId}",
    );

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
    AppLoggerHelper.logInfo('🛑 Stopping chat subscription');
    context.read<SubscribeChatMessageBloc>().add(
      StopSubscribeChatMessageEvent(),
    );
  }

  @override
  void deactivate() {
    AppLoggerHelper.logInfo('⏸️ Deactivating HomeChatScreen');
    _stopSubscription();
    super.deactivate();
  }

  @override
  void dispose() {
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
                child:
                    BlocConsumer<
                      SubscribeChatMessageBloc,
                      SubscribeChatMessageState
                    >(
                      listener: (context, state) {
                        if (state is GetSubscribeChatMessageSuccess) {
                          final messageCount =
                              state.chatMessage.messages.length;
                          AppLoggerHelper.logInfo(
                            "📥 Subscription updated with $messageCount messages",
                          );

                          // Scroll to bottom on new messages
                          if (messageCount > 0) {
                            _scrollToBottom();
                          }
                        } else if (state is GetSubscribeChatMessageError) {
                          AppLoggerHelper.logError(
                            "❌ Subscription error: ${state.message}",
                          );
                        }
                      },
                      builder: (context, subscriptionState) {
                        // Loading state
                        if (subscriptionState
                            is GetSubscribeChatMessageLoading) {
                          return _buildLoadingState();
                        }

                        // Success state
                        if (subscriptionState
                            is GetSubscribeChatMessageSuccess) {
                          final chatData = subscriptionState.chatMessage;
                          final messages = chatData.messages;

                          AppLoggerHelper.logInfo(
                            "✅ Rendering ${messages.length} messages",
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
                          return _buildErrorState(
                            'Connection Error: ${subscriptionState.message}',
                            true,
                          );
                        }

                        // Initial state
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

    return ListView(
      controller: _scrollController,
      reverse: true,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      children: messageWidgets.reversed.toList(),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [CircularProgressIndicator.adaptive()],
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
