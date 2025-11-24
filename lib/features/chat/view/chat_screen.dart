import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_app_bar.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_snack_bar.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';
import 'package:meshal_doctor_booking_app/features/chat/model/view_user_chat_message_model.dart';
import 'package:meshal_doctor_booking_app/features/chat/view_model/bloc/send_chat_message/send_chat_message_bloc.dart';
import 'package:meshal_doctor_booking_app/features/chat/view_model/bloc/subscribe_chat_message/subscribe_chat_message_bloc.dart';
import 'package:meshal_doctor_booking_app/features/chat/view_model/bloc/view_user_chat_room_message/view_user_chat_room_message_bloc.dart';

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
  bool _isInitialQueryCalled = false;

  // Message controller and focus node
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startSubscriptionAndThenQuery();
    AppLoggerHelper.logInfo(
      '🚀 ChatScreen initialized for user: ${widget.userId}',
    );
  }

  void _startSubscriptionAndThenQuery() {
    AppLoggerHelper.logInfo('🚀 Starting subscription first...');
    _startSubscription();

    // Call query only once after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (!_isInitialQueryCalled) {
        AppLoggerHelper.logInfo(
          '📡 Calling initial query (first time only)...',
        );
        _viewChatRoomMessage();
        _isInitialQueryCalled = true;
      } else {
        AppLoggerHelper.logInfo('⏩ Skipping query - already called initially');
      }
    });
  }

  void _startSubscription() {
    AppLoggerHelper.logInfo('📡 Starting subscription with:');
    AppLoggerHelper.logInfo('   - Sender Room: ${widget.senderRoomId}');
    AppLoggerHelper.logInfo('   - Receiver Room: ${widget.receiverRoomId}');
    AppLoggerHelper.logInfo('   - User ID: ${widget.userId}');

    context.read<SubscribeChatMessageBloc>().add(
      StartSubscribeChatMessageEvent(
        senderRoomId: widget.senderRoomId,
        recieverRoomId: widget.receiverRoomId,
        userId: widget.userId,
      ),
    );
  }

  Future<void> _viewChatRoomMessage() async {
    AppLoggerHelper.logInfo('📋 Calling view chat room message...');
    context.read<ViewUserChatRoomMessageBloc>().add(
      GetViewUserChatRoomMessageEvent(
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
      AppLoggerHelper.logInfo('⏹️  Message is empty, not sending');
      return;
    }

    AppLoggerHelper.logInfo('📤 Sending message: "$message"');
    AppLoggerHelper.logInfo('   - Sender Room: ${widget.senderRoomId}');
    AppLoggerHelper.logInfo('   - Receiver Room: ${widget.receiverRoomId}');

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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      AppLoggerHelper.logInfo('📱 App resumed - restarting subscription');
      _startSubscription();
    } else if (state == AppLifecycleState.paused) {
      AppLoggerHelper.logInfo(
        '📱 App paused - maintaining subscription connection',
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    AppLoggerHelper.logInfo('🗑️  ChatScreen disposed - stopping subscription');

    // Only stop subscription when screen is completely disposed
    context.read<SubscribeChatMessageBloc>().add(
      const StopSubscribeChatMessageEvent(),
    );

    // Dispose controllers
    _messageController.dispose();
    _messageFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Listener for subscription messages
        BlocListener<SubscribeChatMessageBloc, SubscribeChatMessageState>(
          listener: (context, state) {
            AppLoggerHelper.logInfo(
              '🎧 SUBSCRIPTION LISTENER - State: ${state.runtimeType}',
            );

            if (state is GetSubscribeChatMessageSuccess) {
              AppLoggerHelper.logInfo(
                '📥 Subscription received ${state.chatMessage.messages.length} messages',
              );
            } else if (state is GetSubscribeChatMessageError) {
              AppLoggerHelper.logError(
                '❌ Subscription error: ${state.message}',
              );
            }
          },
        ),

        // Listener for send message results
        BlocListener<SendChatMessageBloc, SendChatMessageState>(
          listener: (context, state) {
            AppLoggerHelper.logInfo(
              '📤 SEND MESSAGE LISTENER - State: ${state.runtimeType}',
            );

            if (state is SendChatMessageFuncFailure) {
              AppLoggerHelper.logError(
                '❌ Send message failed: ${state.message}',
              );
              KSnackBar.error(
                context,
                'Failed to send message: ${state.message}',
              );
            } else if (state is SendChatMessageFuncSuccess) {
              AppLoggerHelper.logInfo('✅ Send message success!');
            }
          },
        ),

        // // Listener for initial chat room messages
        // BlocListener<ViewUserChatRoomMessageBloc, ViewUserChatRoomMessageState>(
        //   listener: (context, state) {
        //     AppLoggerHelper.logInfo(
        //       '📋 INITIAL QUERY LISTENER - State: ${state.runtimeType}',
        //     );
        //
        //     if (state is GetViewUserChatRoomMessageSuccess) {
        //       AppLoggerHelper.logInfo(
        //         '📋 Initial query loaded ${state.chatMessage.messages.length} messages',
        //       );
        //     } else if (state is GetViewUserChatRoomMessageFailure) {
        //       AppLoggerHelper.logError(
        //         '❌ Initial query failed: ${state.message}',
        //       );
        //     }
        //   },
        // ),
      ],
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child:
              BlocBuilder<SubscribeChatMessageBloc, SubscribeChatMessageState>(
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
                  } else if (state is GetSubscribeChatMessageError) {
                    status = "Connection Error";
                    statusColor = Colors.red;
                  }

                  AppLoggerHelper.logInfo(
                    '📱 AppBar - Title: "$title", Status: "$status"',
                  );

                  return KAppBar(
                    centerTitle: false,
                    backgroundColor: AppColorConstants.primaryColor,
                    title: title,
                    description: status,
                    onBack: () {
                      AppLoggerHelper.logInfo('⬅️  Back button pressed');
                      GoRouter.of(context).pop();
                    },
                  );
                },
              ),
        ),
        body: Column(
          children: [
            // Messages Display
            Expanded(flex: 10, child: _buildMessageDisplay()),

            // Message Input Area
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageDisplay() {
    return BlocBuilder<SubscribeChatMessageBloc, SubscribeChatMessageState>(
      builder: (context, subscriptionState) {
        return BlocBuilder<
          ViewUserChatRoomMessageBloc,
          ViewUserChatRoomMessageState
        >(
          builder: (context, queryState) {
            // Priority: Show subscription data if available
            if (subscriptionState is GetSubscribeChatMessageSuccess) {
              final chatData = subscriptionState.chatMessage;
              AppLoggerHelper.logInfo(
                '💬 Rendering from subscription: ${chatData.messages.length} messages',
              );

              if (chatData.messages.isEmpty) {
                return _buildEmptyState();
              }

              return _buildMessageList(chatData);
            }

            // Fallback: Show initial query data if subscription not ready
            if (queryState is GetViewUserChatRoomMessageSuccess) {
              final chatData = queryState.chatMessage;
              AppLoggerHelper.logInfo(
                '💬 Rendering from query: ${chatData.messages.length} messages',
              );

              if (chatData.messages.isEmpty) {
                return _buildEmptyState();
              }

              return _buildMessageList(chatData);
            }

            // Show error states
            if (subscriptionState is GetSubscribeChatMessageError) {
              return _buildErrorState(
                subscriptionState.message,
                _startSubscription,
              );
            }

            if (queryState is GetViewUserChatRoomMessageFailure) {
              return _buildErrorState(queryState.message, _viewChatRoomMessage);
            }

            // Show loading
            AppLoggerHelper.logInfo('⏳ Showing loading state');
            return _buildLoadingState('Connecting to chat...');
          },
        );
      },
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              focusNode: _messageFocusNode,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onSubmitted: _handleSubmitted,
              textInputAction: TextInputAction.send,
            ),
          ),
          const SizedBox(width: 8),
          BlocBuilder<SendChatMessageBloc, SendChatMessageState>(
            builder: (context, state) {
              final isLoading = state is SendChatMessageFuncLoading;
              AppLoggerHelper.logInfo('📤 Send button - Loading: $isLoading');

              return CircleAvatar(
                backgroundColor: isLoading
                    ? Colors.grey
                    : AppColorConstants.primaryColor,
                child: isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: _sendMessage,
                      ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Build message list widget
  Widget _buildMessageList(ChatData chatData) {
    final messages = chatData.messages;
    AppLoggerHelper.logInfo(
      '💬 Building message list with ${messages.length} messages',
    );

    if (messages.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      reverse: true,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[messages.length - 1 - index];
        final isMe = message.type == "SEND";

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Row(
            mainAxisAlignment: isMe
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              if (!isMe) const SizedBox(width: 8),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 14,
                  ),
                  decoration: BoxDecoration(
                    color: isMe
                        ? AppColorConstants.primaryColor
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.message,
                        style: TextStyle(
                          color: isMe
                              ? AppColorConstants.secondaryColor
                              : Colors.black,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatTime(message.time),
                        style: TextStyle(
                          fontSize: 11,
                          color: isMe
                              ? AppColorConstants.secondaryColor.withOpacity(
                                  0.7,
                                )
                              : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isMe) const SizedBox(width: 8),
            ],
          ),
        );
      },
    );
  }

  // Build empty state
  Widget _buildEmptyState() {
    AppLoggerHelper.logInfo('📭 Rendering empty state');
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            "No messages yet",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          Text(
            "Start a conversation!",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // Build loading state
  Widget _buildLoadingState(String message) {
    AppLoggerHelper.logInfo('⏳ Rendering loading state: $message');
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

  // Build error state with retry
  Widget _buildErrorState(String errorMessage, VoidCallback onRetry) {
    AppLoggerHelper.logError('❌ Rendering error state: $errorMessage');
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            "Connection Error",
            style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
          ),
          const SizedBox(height: 8),
          Text(
            errorMessage,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text("Retry"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColorConstants.primaryColor,
            ),
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
      AppLoggerHelper.logError('❌ Error getting receiver name: $e');
      return "User";
    }
  }

  // Helper method to format time
  String _formatTime(String timeString) {
    try {
      final dateTime = DateTime.parse(timeString);
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      AppLoggerHelper.logError('❌ Error formatting time: $e');
      return timeString;
    }
  }
}
