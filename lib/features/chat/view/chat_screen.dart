import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:chat_bubbles/date_chips/date_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/features/chat/model/view_user_chat_message_model.dart';
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
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  bool _isSubscribed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startSubscription();
    });
  }

  void _stopSubscription() {
    if (mounted) {
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

  void _startSubscription() {
    if (_isSubscribed) return;

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
    if (message.isEmpty) return;

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

  void _handleSubmitted(String value) => _sendMessage();

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
                    title = state.chatMessage.receiverName;
                    status = state.chatMessage.isReceiverOnline
                        ? "Online"
                        : "Offline";
                  }

                  return KAppBar(
                    centerTitle: false,
                    backgroundColor: AppColorConstants.primaryColor,
                    title: title,
                    description: status,
                    onBack: () {
                      // Pop
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
                child:
                    BlocConsumer<
                      SubscribeChatMessageBloc,
                      SubscribeChatMessageState
                    >(
                      listener: (context, state) {
                        if (state is GetSubscribeChatMessageSuccess) {
                          _scrollToBottom();
                        }
                      },
                      builder: (context, state) {
                        if (state is GetSubscribeChatMessageLoading) {
                          return _buildLoadingState();
                        }

                        if (state is GetSubscribeChatMessageSuccess) {
                          return _buildMessageList(
                            state.chatMessage.messages,
                            appLoc,
                            isMobile,
                            isTablet,
                          );
                        }

                        if (state is GetSubscribeChatMessageError) {
                          return _buildErrorState(
                            'Connection Error: ${state.message}',
                            true,
                          );
                        }

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
              if (state is SendChatMessageFuncFailure) {
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
    if (messages.isEmpty) {
      return Center(
        child: KNoItemsFound(
          noItemsFoundText: appLoc.noChatsFound,
          noItemsSvg: AppAssetsConstants.noChatFound,
        ),
      );
    }

    final List<Widget> messageWidgets = [];
    String? currentDateKey;

    for (final message in messages) {
      final msgDate = DateTime.parse(message.time);
      final dateKey = '${msgDate.year}-${msgDate.month}-${msgDate.day}';

      if (dateKey != currentDateKey) {
        currentDateKey = dateKey;
        messageWidgets.add(
          DateChip(date: msgDate, color: const Color(0x558AD3D5)),
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

    return ListView(
      controller: _scrollController,
      reverse: true,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      children: messageWidgets.reversed.toList(),
    );
  }

  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator.adaptive());
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
            onPressed: _startSubscription,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry Connection'),
          ),
        ],
      ),
    );
  }
}
