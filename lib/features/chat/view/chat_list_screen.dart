import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_app_bar.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_floating_action_btn.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_no_items_found.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_text_form_field.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_assets_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_router_constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_datas.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';
import 'package:meshal_doctor_booking_app/features/chat/widgets/chat_list_tile.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  // Controller
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    // App Localization
    final appLoc = AppLocalizations.of(context)!;

    // MediaQuery
    final height = MediaQuery.of(context).size.height;

    // Profile Image Url
    final String profileImageUrl =
        "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D";

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppColorConstants.secondaryColor,
        appBar: KAppBar(
          title: appLoc.consultDoctor,
          onBack: () {
            // Haptics
            HapticFeedback.heavyImpact();

            // Back
            GoRouter.of(context).pop();
          },
        ),
        floatingActionButton: KFloatingActionBtn(
          onTap: () {
            // Doctor List Screen
            GoRouter.of(context).pushNamed(AppRouterConstants.doctorList);
          },
          fabIconPath: AppAssetsConstants.doctor,
          heroTag: "doctorList",
        ),

        body: RefreshIndicator.adaptive(
          color: AppColorConstants.secondaryColor,
          backgroundColor: AppColorConstants.primaryColor,
          onRefresh: () async {},
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
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
                spacing: 20,
                crossAxisAlignment: .start,
                mainAxisAlignment: .start,
                children: [
                  // Search Text Form Field
                  KTextFormField(
                    prefixIcon: Icon(Icons.search_outlined),
                    controller: _searchController,
                    hintText: appLoc.search,
                    keyboardType: TextInputType.name,
                    autofillHints: [
                      AutofillHints.name,
                      AutofillHints.familyName,
                      AutofillHints.givenName,
                      AutofillHints.middleName,
                      AutofillHints.nickname,
                      AutofillHints.username,
                    ],
                  ),

                  chatUsers.isEmpty
                      ? SizedBox(
                          height: height * 0.6,
                          child: Center(
                            child: KNoItemsFound(
                              noItemsFoundText: appLoc.noChatsFound,
                              noItemsSvg: AppAssetsConstants.noChatListFound,
                            ),
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final chat = chatUsers[index];

                            return ChatListTile(
                              onTap: () {
                                // Chat Screen
                                GoRouter.of(
                                  context,
                                ).pushNamed(AppRouterConstants.chat);
                              },
                              profileImageUrl: profileImageUrl,
                              name: chat["name"]!,
                              message: chat["message"]!,
                              time: chat["time"]!,
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 12);
                          },
                          itemCount: chatUsers.length,
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
