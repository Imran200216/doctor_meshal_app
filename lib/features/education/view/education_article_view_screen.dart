import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/core/bloc/connectivity/connectivity_bloc.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/core/service/service.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';
import 'package:meshal_doctor_booking_app/features/education/education.dart';
import 'package:meshal_doctor_booking_app/features/auth/auth.dart';

class EducationArticleViewScreen extends StatefulWidget {
  final String educationFullArticleId;

  const EducationArticleViewScreen({
    super.key,
    required this.educationFullArticleId,
  });

  @override
  State<EducationArticleViewScreen> createState() =>
      _EducationArticleViewScreenState();
}

class _EducationArticleViewScreenState
    extends State<EducationArticleViewScreen> {
  // User Id
  String? userId;

  @override
  void initState() {
    _fetchEducationArticlesView();

    super.initState();
  }

  // Fetch Education Articles View using userAuthData
  Future<void> _fetchEducationArticlesView() async {
    try {
      await HiveService.openBox(AppDBConstants.userBox);

      // Fetch stored userAuthData (no generic type)
      final storedUserMapRaw = await HiveService.getData(
        boxName: AppDBConstants.userBox,
        key: AppDBConstants.userAuthData,
      );

      if (storedUserMapRaw != null) {
        // Safely convert dynamic map → Map<String, dynamic>
        final storedUserMap = Map<String, dynamic>.from(storedUserMapRaw);

        // Convert Map → UserAuthModel
        final storedUser = UserAuthModel.fromJson(storedUserMap);
        userId = storedUser.id;

        AppLoggerHelper.logInfo("User ID from userAuthData: $userId");
        AppLoggerHelper.logInfo(
          "Education Article ID: ${widget.educationFullArticleId}",
        );

        // Get Education Full View Articles
        context.read<EducationFullViewArticleBloc>().add(
          GetEducationFullViewArticleEvent(
            id: widget.educationFullArticleId,
            userId: userId!,
          ),
        );
      } else {
        AppLoggerHelper.logError("No userAuthData found in Hive!");
      }
    } catch (e) {
      AppLoggerHelper.logError("Error fetching User ID from userAuthData: $e");
    }
  }


  // Font Size for Zoom In and Zoom Out
  double _contentFontSize = 16;
  double _titleFontSize = 18;

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    // App Localization
    final appLoc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColorConstants.secondaryColor,
      floatingActionButton: Column(
        spacing: 12,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Zoom In
          KFloatingActionBtn(
            onTap: () {
              setState(() {
                _contentFontSize += 2;
                _titleFontSize += 2;
              });
            },
            fabIconPath: AppAssetsConstants.zoomIn,
            heroTag: "zoomIn",
          ),

          // Zoom Out
          KFloatingActionBtn(
            onTap: () {
              setState(() {
                if (_contentFontSize > 8) _contentFontSize -= 2;
                if (_titleFontSize > 10) _titleFontSize -= 2;
              });
            },
            fabIconPath: AppAssetsConstants.zoomOut,
            heroTag: "zoomOUt",
          ),

          // Reset
          KFloatingActionBtn(
            onTap: () {
              setState(() {
                _contentFontSize = 16;
                _titleFontSize = 18;
              });
            },
            fabIconPath: AppAssetsConstants.reset,
            heroTag: "reset",
          ),
        ],
      ),

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child:
            BlocBuilder<
              EducationFullViewArticleBloc,
              EducationFullViewArticleState
            >(
              builder: (context, state) {
                String appBarTitle = "";

                if (state is EducationFullViewArticleSuccess) {
                  appBarTitle = state.article.articleName;
                }

                return KAppBar(
                  title: appBarTitle,
                  onBack: () => GoRouter.of(context).pop(),
                  backgroundColor: AppColorConstants.primaryColor,
                );
              },
            ),
      ),

      body: RefreshIndicator.adaptive(
        color: AppColorConstants.secondaryColor,
        backgroundColor: AppColorConstants.primaryColor,
        onRefresh: () async {
          // Get Education Article View
          _fetchEducationArticlesView();
        },

        child: BlocBuilder<ConnectivityBloc, ConnectivityState>(
          builder: (context, connectivityState) {
            if (connectivityState is ConnectivityFailure) {
              return Align(
                alignment: Alignment.center,
                heightFactor: 3,
                child: const KInternetFound(),
              );
            } else if (connectivityState is ConnectivitySuccess) {
              return BlocBuilder<
                EducationFullViewArticleBloc,
                EducationFullViewArticleState
              >(
                builder: (context, state) {
                  if (state is EducationFullViewArticleLoading) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile
                            ? 20
                            : isTablet
                            ? 30
                            : 40,
                        vertical: isMobile
                            ? 20
                            : isTablet
                            ? 30
                            : 40,
                      ),
                      child: EducationArticleViewSkeleton(),
                    );
                  }

                  if (state is EducationFullViewArticleSuccess) {
                    final educationFullViewArticle = state.article;

                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile
                              ? 20
                              : isTablet
                              ? 30
                              : 40,
                          vertical: isMobile
                              ? 20
                              : isTablet
                              ? 30
                              : 40,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Topics
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "${appLoc.topics}: ",
                                    style: TextStyle(
                                      fontFamily: "OpenSans",
                                      fontWeight: FontWeight.w700,
                                      fontSize: isMobile
                                          ? 18
                                          : isTablet
                                          ? 20
                                          : 22,
                                      color: AppColorConstants.titleColor,
                                    ),
                                  ),
                                  TextSpan(
                                    text: educationFullViewArticle.titleName,
                                    style: TextStyle(
                                      fontFamily: "OpenSans",
                                      fontWeight: FontWeight.w600,
                                      fontSize: isMobile
                                          ? 18
                                          : isTablet
                                          ? 20
                                          : 22,
                                      color: AppColorConstants.subTitleColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // SubTopics
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "${appLoc.subTopics}: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: isMobile
                                          ? 18
                                          : isTablet
                                          ? 20
                                          : 22,
                                      color: AppColorConstants.titleColor,
                                    ),
                                  ),
                                  TextSpan(
                                    text: educationFullViewArticle.subTitleName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: isMobile
                                          ? 18
                                          : isTablet
                                          ? 20
                                          : 22,
                                      color: AppColorConstants.subTitleColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 40),

                            // Article
                            KText(
                              text: appLoc.articles,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.visible,
                              fontSize: _titleFontSize,
                              fontWeight: FontWeight.w700,
                              color: AppColorConstants.titleColor,
                            ),

                            const SizedBox(height: 20),

                            // Articles
                            KText(
                              text: educationFullViewArticle.article,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.visible,
                              fontSize: _contentFontSize,
                              fontWeight: FontWeight.w500,
                              height: 1.2,
                              color: AppColorConstants.subTitleColor,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (state is EducationFullViewArticleError) {
                    return Center(child: Text(state.message));
                  }

                  return const SizedBox.shrink();
                },
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
