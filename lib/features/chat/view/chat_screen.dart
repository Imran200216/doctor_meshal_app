import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_app_bar.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_no_items_found.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_assets_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_datas.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';
import 'package:meshal_doctor_booking_app/features/chat/widgets/chat_message_text_form_field.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //  Controllers
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      messages.add({"text": _messageController.text.trim(), "isMe": true});
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    // App Localization
    final appLoc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColorConstants.secondaryColor,
      appBar: KAppBar(
        title: "Zayan",
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
              // Chat Messages
              Expanded(
                flex: 10,
                child: messages.isEmpty
                    ? KNoItemsFound(
                        noItemsFoundText: appLoc.noChatsFound,
                        noItemsSvg: AppAssetsConstants.noChatFound,
                      )
                    : ListView.builder(
                        itemCount: messages.length,
                        padding: const EdgeInsets.only(bottom: 20, top: 10),
                        itemBuilder: (context, index) {
                          final msg = messages[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Column(
                              crossAxisAlignment: msg["isMe"]
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                BubbleSpecialOne(
                                  sent: true,
                                  delivered: true,
                                  tail: true,
                                  seen: true,
                                  text: msg["text"],
                                  isSender: msg["isMe"],
                                  color: msg["isMe"]
                                      ? AppColorConstants.primaryColor
                                      : AppColorConstants.subTitleColor
                                            .withOpacity(0.15),
                                  textStyle: TextStyle(
                                    color: msg["isMe"]
                                        ? AppColorConstants.secondaryColor
                                        : AppColorConstants.titleColor,
                                    fontFamily: "OpenSans",
                                    fontSize: isMobile
                                        ? 14
                                        : isTablet
                                        ? 16
                                        : 18,
                                  ),
                                ),

                                // Message Time Text
                                const SizedBox(height: 4),
                                Text(
                                  msg["time"],
                                  style: TextStyle(
                                    color: AppColorConstants.subTitleColor,
                                    fontSize: isMobile
                                        ? 12
                                        : isTablet
                                        ? 14
                                        : 16,
                                    fontFamily: "OpenSans",
                                  ),
                                ),
                              ],
                            ),
                          );
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
                    // Attach Files
                    IconButton(
                      onPressed: () {
                        HapticFeedback.heavyImpact();
                      },
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

                    // Message Text Field
                    Expanded(
                      child: ChatMessageTextFormField(
                        controller: _messageController,
                        hintText: appLoc.typeYourMessage,
                      ),
                    ),

                    // Send Button
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
