import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_app_bar.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';
import 'package:meshal_doctor_booking_app/features/chat/view_model/bloc/subscribe_chat_message/subscribe_chat_message_bloc.dart';
import 'package:meshal_doctor_booking_app/features/chat/widgets/chat_message_text_form_field.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';

class ChatScreen extends StatefulWidget {
  final String receiverRoomId;
  final String senderRoomId;
  final String userId;

  const ChatScreen({
    super.key,
    required this.receiverRoomId,
    required this.senderRoomId,
    required this.userId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<SubscribeChatMessageBloc>().add(
      StartSubscribeChatMessageEvent(
        senderRoomId: widget.senderRoomId,
        recieverRoomId: widget.receiverRoomId,
        userId: widget.userId,
      ),
    );
  }

  @override
  void dispose() {
    context.read<SubscribeChatMessageBloc>().add(
      StopSubcribeChatMessageEvent(),
    );
    _messageController.dispose();

    super.dispose();
  }

  void sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    // Here, you can call your mutation to send message
    // For now, just clearing text
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);
    final appLoc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColorConstants.secondaryColor,
      appBar: KAppBar(
        title: "Chat",
        onBack: () {
          HapticFeedback.heavyImpact();
          GoRouter.of(context).pop();
        },
        centerTitle: false,
      ),
      body: Directionality(
        textDirection: TextDirection.ltr,
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
            children: [
              // Chat Messages List
              Expanded(
                flex: 10,
                child:
                    BlocBuilder<
                      SubscribeChatMessageBloc,
                      SubscribeChatMessageState
                    >(
                      builder: (context, state) {
                        if (state is GetSubscribeChatMessageLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is GetSubscribeChatMessageError) {
                          return Center(
                            child: Text(
                              "Error: ${state.message}",
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        } else if (state is GetSubscribeChatMessageSuccess) {
                          final messages = state.chatMessage.messages;

                          if (messages.isEmpty) {
                            return const Center(child: Text("No messages yet"));
                          }

                          return ListView.builder(
                            reverse: true,
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final message =
                                  messages[messages.length - 1 - index];
                              final isMe = message.type == "SEND";

                              return Align(
                                alignment: isMe
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 8,
                                  ),
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
                                  child: Text(
                                    message.message,
                                    style: TextStyle(
                                      color: isMe
                                          ? AppColorConstants.secondaryColor
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return const Center(child: Text("Loading chat..."));
                        }
                      },
                    ),
              ),

              // Chat Input Area
              Container(
                height: isMobile
                    ? 60
                    : isTablet
                    ? 70
                    : 75,
                color: AppColorConstants.secondaryColor,
                child: Row(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () => HapticFeedback.heavyImpact(),
                      icon: Icon(
                        Icons.attach_file_outlined,
                        size: isMobile
                            ? 28
                            : isTablet
                            ? 30
                            : 32,
                        color: AppColorConstants.subTitleColor,
                      ),
                    ),
                    Expanded(
                      child: ChatMessageTextFormField(
                        controller: _messageController,
                        hintText: appLoc.typeYourMessage,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.heavyImpact();
                        sendMessage();
                      },
                      child: CircleAvatar(
                        radius: isMobile
                            ? 24
                            : isTablet
                            ? 26
                            : 28,
                        backgroundColor: AppColorConstants.primaryColor,
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
