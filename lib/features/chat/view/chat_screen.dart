import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:chat_bubbles/date_chips/date_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';
import 'package:meshal_doctor_booking_app/features/chat/chat.dart';

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
  // Message controller and focus node
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _startSubscription();
  }

  // Start Subscription
  void _startSubscription() {
    context.read<SubscribeChatMessageBloc>().add(
      StartSubscribeChatMessageEvent(
        senderRoomId: widget.senderRoomId,
        recieverRoomId: widget.receiverRoomId,
        userId: widget.userId,
      ),
    );
  }

  // Send message function
  void _sendMessage() {
    final message = _messageController.text.trim();

    if (message.isEmpty) {
      return; // Don't send empty messages
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

    // Clear the input field after sending
    _messageController.clear();

    // Optionally refocus on the input field
    _messageFocusNode.requestFocus();
  }

  // Handle keyboard submit
  void _handleSubmitted(String value) {
    _sendMessage();
  }

  @override
  void deactivate() {
    // _stopSubscription();

    super.deactivate();
  }

  @override
  void dispose() {
    // Dispose controllers
    _messageController.dispose();
    _messageFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    // Localization
    final appLoc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColorConstants.secondaryColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: BlocBuilder<SubscribeChatMessageBloc, SubscribeChatMessageState>(
          builder: (context, state) {
            String title = "Chat";
            String status = "Connecting...";
            Color statusColor = Colors.grey;

            if (state is GetSubscribeChatMessageSuccess) {
              final isReceiverOnline = state.chatMessage.isReceiverOnline;
              final receiverName = _getReceiverName(state.chatMessage);
              title = receiverName;
              status = isReceiverOnline ? "Online" : "Offline";
              statusColor = isReceiverOnline ? Colors.green : Colors.grey;
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
                    AppLoggerHelper.logInfo(
                      "📥 Subscription updated with ${state.chatMessage.messages.length} messages",
                    );
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

                  // Loading state
                  if (subscriptionState is GetSubscribeChatMessageLoading) {
                    AppLoggerHelper.logInfo("⏳ Showing loading state");
                    return _buildLoadingState('Connecting to chat...');
                  }

                  // Success state - Primary data source
                  if (subscriptionState is GetSubscribeChatMessageSuccess) {
                    final chatData = subscriptionState.chatMessage;
                    AppLoggerHelper.logInfo(
                      "✅ SUCCESS - Rendering ${chatData.messages.length} messages from subscription",
                    );

                    return _buildMessageList(
                      chatData,
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
                  return _buildLoadingState('Loading chat...');
                },
              ),
            ),

            _buildMessageInput(isMobile, isTablet, appLoc),
          ],
        ),
      ),
    );
  }

  // Build Message Input - FIXED VERSION
  Widget _buildMessageInput(
    bool isMobile,
    bool isTablet,
    AppLocalizations appLoc,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      // Added vertical padding
      color: AppColorConstants.secondaryColor,
      child: Row(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
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

          // Send Button
          BlocListener<SendChatMessageBloc, SendChatMessageState>(
            listener: (context, state) {
              if (state is SendChatMessageFuncFailure) {
                KSnackBar.error(
                  context,
                  'Failed to send message: ${state.message}',
                );
              }
            },
            child: GestureDetector(
              onTap: () {
                HapticFeedback.heavyImpact();

                // Send Message
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

  // Widget _buildMessageList(ChatData chatData, AppLocalizations appLoc) {
  //   final messages = chatData.messages;
  //   AppLoggerHelper.logInfo('💬 Building ${messages.length} messages');
  //
  //   if (messages.isEmpty) {
  //     return Center(
  //       child: KNoItemsFound(
  //         noItemsFoundText: appLoc.noChatsFound,
  //         noItemsSvg: AppAssetsConstants.noChatFound,
  //       ),
  //     );
  //   }
  //
  //   return ListView.builder(
  //     reverse: true,
  //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
  //     itemCount: messages.length,
  //     itemBuilder: (context, index) {
  //       final message = messages[messages.length - 1 - index];
  //       final isMe = message.type == "SEND";
  //
  //       return Container(
  //         margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
  //         child: Row(
  //           mainAxisAlignment: isMe
  //               ? MainAxisAlignment.end
  //               : MainAxisAlignment.start,
  //           children: [
  //             if (!isMe) const SizedBox(width: 8),
  //             Flexible(
  //               child: Container(
  //                 padding: const EdgeInsets.symmetric(
  //                   vertical: 10,
  //                   horizontal: 14,
  //                 ),
  //                 decoration: BoxDecoration(
  //                   color: isMe
  //                       ? AppColorConstants.primaryColor
  //                       : Colors.grey.shade300,
  //                   borderRadius: BorderRadius.circular(12),
  //                 ),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       message.message,
  //                       style: TextStyle(
  //                         color: isMe
  //                             ? AppColorConstants.secondaryColor
  //                             : Colors.black,
  //                         fontSize: 15,
  //                       ),
  //                     ),
  //                     const SizedBox(height: 4),
  //                     Text(
  //                       formatMessageTime(message.time),
  //                       style: TextStyle(
  //                         fontSize: 11,
  //                         color: isMe
  //                             ? AppColorConstants.secondaryColor.withOpacity(
  //                                 0.7,
  //                               )
  //                             : Colors.grey.shade600,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             if (isMe) const SizedBox(width: 8),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _buildMessageList(
    ChatData chatData,
    AppLocalizations appLoc,
    bool isMobile,
    bool isTablet,
  ) {
    final messages = chatData.messages;
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
      reverse: true,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      children: messageWidgets.reversed.toList(),
    );
  }

  // Build loading state
  Widget _buildLoadingState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(message),
        ],
      ),
    );
  }

  // Build error state
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

  // Helper method to safely get receiver name
  String _getReceiverName(ChatData chatMessage) {
    try {
      if (chatMessage.senderFirstName != null &&
          chatMessage.senderLastName != null) {
        return '${chatMessage.senderFirstName} ${chatMessage.senderLastName}';
      }
      return "User";
    } catch (e) {
      return "User";
    }
  }
}
