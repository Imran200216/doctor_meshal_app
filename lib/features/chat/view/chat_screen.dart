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
  bool _isSubscriptionEstablished = false;
  bool _isInitialQueryCalled = false;

  // Message controller and focus node
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startSubscriptionAndThenQuery();
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
    context.read<SubscribeChatMessageBloc>().add(
      StartSubscribeChatMessageEvent(
        senderRoomId: widget.senderRoomId,
        recieverRoomId: widget.receiverRoomId,
        userId: widget.userId,
      ),
    );
  }

  Future<void> _viewChatRoomMessage() async {
    context.read<ViewUserChatRoomMessageBloc>().add(
      GetViewUserChatRoomMessageEvent(
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      AppLoggerHelper.logInfo('📱 App resumed - restarting subscription');
      _isSubscriptionEstablished = false;
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

    context.read<SubscribeChatMessageBloc>().add(
      const StopSubscribeChatMessageEvent(),
    );

    _messageController.dispose();
    _messageFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: BlocBuilder<SubscribeChatMessageBloc, SubscribeChatMessageState>(
          builder: (context, state) {
            // REMOVED: BlocListener wrapper - no setState needed

            if (state is GetSubscribeChatMessageSuccess &&
                !_isSubscriptionEstablished) {
              _isSubscriptionEstablished = true;
              AppLoggerHelper.logInfo('✅ Subscription established and ready!');
            }

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
      body: Column(
        children: [
          // Messages Display
          Expanded(
            flex: 10,
            child: BlocConsumer<SubscribeChatMessageBloc, SubscribeChatMessageState>(
              listenWhen: (previous, current) {
                AppLoggerHelper.logInfo(
                  "👂 Listen When - Previous: ${previous.runtimeType}, Current: ${current.runtimeType}",
                );
                return true;
              },
              buildWhen: (previous, current) {
                AppLoggerHelper.logInfo(
                  "🏗️ Build When - Previous: ${previous.runtimeType}, Current: ${current.runtimeType}",
                );

                if (previous is GetSubscribeChatMessageSuccess &&
                    current is GetSubscribeChatMessageSuccess) {
                  final prevCount = previous.chatMessage.messages.length;
                  final currCount = current.chatMessage.messages.length;
                  AppLoggerHelper.logInfo(
                    "📊 Message count: $prevCount -> $currCount",
                  );
                  return prevCount !=
                      currCount; // Only rebuild if count changed
                }
                return true;
              },
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
                final timestamp = DateTime.now().millisecondsSinceEpoch;
                AppLoggerHelper.logInfo(
                  "🎨 Builder called at $timestamp - State: ${subscriptionState.runtimeType}",
                );

                if (subscriptionState is GetSubscribeChatMessageLoading) {
                  return _buildLoadingState('Connecting to chat...');
                }

                if (subscriptionState is GetSubscribeChatMessageSuccess) {
                  final chatData = subscriptionState.chatMessage;
                  AppLoggerHelper.logInfo(
                    "✅ Rendering ${chatData.messages.length} messages",
                  );
                  return _buildMessageList(chatData);
                }

                if (subscriptionState is GetSubscribeChatMessageError) {
                  return _buildErrorState(
                    'Connection Error: ${subscriptionState.message}',
                    true,
                  );
                }

                return _buildLoadingState('Initializing chat...');
              },
            ),
          ),

          // Message Input Area
          _buildMessageInput(),
        ],
      ),
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
          BlocListener<SendChatMessageBloc, SendChatMessageState>(
            listener: (context, state) {
              if (state is SendChatMessageFuncFailure) {
                KSnackBar.error(
                  context,
                  'Failed to send message: ${state.message}',
                );
              }
              // Success is handled by subscription updates automatically
            },
            child: CircleAvatar(
              backgroundColor: AppColorConstants.primaryColor,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: _sendMessage,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList(ChatData chatData) {
    final messages = chatData.messages;
    AppLoggerHelper.logInfo('💬 Building messages - Count: ${messages.length}');

    if (messages.isEmpty) {
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

  String _formatTime(String timeString) {
    try {
      final dateTime = DateTime.parse(timeString);
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return timeString;
    }
  }
}
