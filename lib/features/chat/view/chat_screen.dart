import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_app_bar.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';
import 'package:meshal_doctor_booking_app/features/chat/model/view_user_chat_message_model.dart';
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
  List<ChatMessage> _currentMessages = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startSubscriptionAndThenQuery();
  }

  void _startSubscriptionAndThenQuery() {
    AppLoggerHelper.logInfo('🚀 Starting subscription first...');
    _startSubscription();

    Future.delayed(const Duration(seconds: 3), () {
      AppLoggerHelper.logInfo('📡 Calling query...');
      _viewChatRoomMessage();
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      AppLoggerHelper.logInfo(
        '📱 App resumed - restarting subscription and query',
      );
      _isSubscriptionEstablished = false;
      _startSubscriptionAndThenQuery();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // context.read<SubscribeChatMessageBloc>().add(
    //   const StopSubscribeChatMessageEvent(),
    // );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child:
            BlocListener<SubscribeChatMessageBloc, SubscribeChatMessageState>(
              listener: (context, state) {
                if (state is GetSubscribeChatMessageSuccess &&
                    !_isSubscriptionEstablished) {
                  _isSubscriptionEstablished = true;
                  AppLoggerHelper.logInfo(
                    '✅ Subscription established and ready!',
                  );
                }

                // Update messages from subscription
                if (state is GetSubscribeChatMessageSuccess) {
                  setState(() {
                    _currentMessages = state.chatMessage.messages;
                  });
                }
              },
              child:
                  BlocBuilder<
                    SubscribeChatMessageBloc,
                    SubscribeChatMessageState
                  >(
                    builder: (context, state) {
                      String title = "Chat";
                      String status = "Connecting...";
                      Color statusColor = Colors.grey;

                      if (state is GetSubscribeChatMessageSuccess) {
                        final isReceiverOnline =
                            state.chatMessage.isReceiverOnline;
                        final receiverName = _getReceiverName(
                          state.chatMessage,
                        );
                        title = receiverName;
                        status = isReceiverOnline ? "Online" : "Offline";
                        statusColor = isReceiverOnline
                            ? Colors.green
                            : Colors.grey;
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
      ),
      body: Column(
        children: [
          // Combined Messages Display
          Expanded(
            flex: 10,
            child: BlocConsumer<ViewUserChatRoomMessageBloc, ViewUserChatRoomMessageState>(
              listener: (context, state) {
                AppLoggerHelper.logInfo(
                  "🔄 Listener State: ${state.runtimeType}",
                );

                if (state is GetViewUserChatRoomMessageSuccess) {
                  AppLoggerHelper.logInfo(
                    "✅ Success State - Messages count: ${state.chatMessage.messages.length}",
                  );
                  // Update messages from query
                  setState(() {
                    _currentMessages = state.chatMessage.messages;
                    AppLoggerHelper.logInfo(
                      "📱 Updated _currentMessages count: ${_currentMessages.length}",
                    );
                  });
                }

                if (state is GetViewUserChatRoomMessageFailure) {
                  AppLoggerHelper.logError("The Chat Error: ${state.message}");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Query Error: ${state.message}'),
                      backgroundColor: Colors.orange,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              },
              builder: (context, queryState) {
                AppLoggerHelper.logInfo(
                  "🎨 Builder Query State: ${queryState.runtimeType}",
                );
                AppLoggerHelper.logInfo(
                  "🎨 Current Messages in UI: ${_currentMessages.length}",
                );

                return BlocBuilder<
                  SubscribeChatMessageBloc,
                  SubscribeChatMessageState
                >(
                  builder: (context, subscriptionState) {
                    AppLoggerHelper.logInfo(
                      "📡 Subscription State: ${subscriptionState.runtimeType}",
                    );

                    // Your existing state handling code...
                    if (subscriptionState is GetSubscribeChatMessageLoading &&
                        queryState is GetViewUserChatRoomMessageLoading) {
                      return _buildLoadingState('Establishing connection...');
                    }

                    if (subscriptionState is GetSubscribeChatMessageLoading) {
                      return _buildLoadingState(
                        'Connecting to real-time chat...',
                      );
                    }

                    if (queryState is GetViewUserChatRoomMessageLoading) {
                      return _buildLoadingState('Loading chat history...');
                    }

                    if (subscriptionState is GetSubscribeChatMessageError) {
                      return _buildErrorState(
                        'Connection Error: ${subscriptionState.message}',
                        true,
                      );
                    }

                    if (queryState is GetViewUserChatRoomMessageFailure) {
                      if (_currentMessages.isEmpty) {
                        return _buildErrorState(
                          'Failed to load chat: ${queryState.message}',
                          false,
                        );
                      }
                      return Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            color: Colors.orange.shade100,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.warning,
                                  color: Colors.orange.shade800,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Using cached messages - ${queryState.message}',
                                    style: TextStyle(
                                      color: Colors.orange.shade800,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(child: _buildMessageList(_currentMessages)),
                        ],
                      );
                    }

                    // Show messages (from either source)
                    AppLoggerHelper.logInfo(
                      "🎯 Building message list with ${_currentMessages.length} messages",
                    );
                    return _buildMessageList(_currentMessages);
                  },
                );
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
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: AppColorConstants.primaryColor,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () {
                // Send message logic
              },
            ),
          ),
        ],
      ),
    );
  }

  // // Build message list widget
  Widget _buildMessageList(List<ChatMessage> messages) {
    AppLoggerHelper.logInfo('💬 Building messages - Count: ${messages.length}');

    // Debug: Print each message
    for (var message in messages) {
      AppLoggerHelper.logInfo(
        '📝 Message: ${message.message}, Type: ${message.type}, Time: ${message.time}',
      );
    }

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
      reverse: true, // This might be causing issues
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        // When reverse is true, index 0 is the last message
        final message = messages[messages.length - 1 - index];
        final isMe = message.type == "SEND";

        AppLoggerHelper.logInfo(
          '🎯 Rendering message: ${message.message}, isMe: $isMe',
        );

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
            onPressed: _startSubscriptionAndThenQuery,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  // Helper method to safely get receiver name
  String _getReceiverName(ChatData chatMessage) {
    try {
      return chatMessage.receiverProfile.fullName;
    } catch (e) {
      return "User";
    }
  }

  // Helper method to format time
  String _formatTime(String timeString) {
    try {
      final dateTime = DateTime.parse(timeString);
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return timeString;
    }
  }
}
