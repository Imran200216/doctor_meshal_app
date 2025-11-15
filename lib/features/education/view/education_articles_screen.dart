import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_app_bar.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_no_items_found.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_skeleton_rectangle.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_db_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_router_constants.dart';
import 'package:meshal_doctor_booking_app/core/service/hive_service.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';
import 'package:meshal_doctor_booking_app/features/education/view_model/education_articles/education_articles_bloc.dart';
import 'package:meshal_doctor_booking_app/features/education/widgets/education_article_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EducationArticlesScreen extends StatefulWidget {
  final String educationArticleId;

  const EducationArticlesScreen({super.key, required this.educationArticleId});

  @override
  State<EducationArticlesScreen> createState() =>
      _EducationArticlesScreenState();
}

class _EducationArticlesScreenState extends State<EducationArticlesScreen> {
  // User Id
  String? userId;

  @override
  void initState() {
    _fetchEducationArticles();
    super.initState();
  }

  // Fetch Education Articles
  Future<void> _fetchEducationArticles() async {
    try {
      await HiveService.openBox(AppDBConstants.userBox);

      final storedUserId = await HiveService.getData<String>(
        boxName: AppDBConstants.userBox,
        key: AppDBConstants.userId,
      );

      if (storedUserId != null) {
        userId = storedUserId;

        AppLoggerHelper.logInfo("User ID fetched: $userId");
        AppLoggerHelper.logInfo(
          "Education Article ID: ${widget.educationArticleId}",
        );

        // Get Education Article
        context.read<EducationArticlesBloc>().add(
          GetEducationArticlesEvent(
            id: widget.educationArticleId,
            userId: userId!,
          ),
        );
      } else {
        AppLoggerHelper.logError("No User ID found in Hive!");
      }
    } catch (e) {
      AppLoggerHelper.logError("Error fetching User ID: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    return BlocBuilder<EducationArticlesBloc, EducationArticlesState>(
      builder: (context, state) {
        String appBarTitle = "ALC Injuries";

        if (state is EducationArticlesSuccess && state.topics.isNotEmpty) {
          appBarTitle = state.topics.first.subTitleName;
        }

        return Scaffold(
          backgroundColor: AppColorConstants.secondaryColor,
          appBar: KAppBar(
            title: appBarTitle,
            onBack: () => GoRouter.of(context).pop(),
            backgroundColor: AppColorConstants.primaryColor,
          ),

          body: RefreshIndicator(
            color: AppColorConstants.secondaryColor,
            backgroundColor: AppColorConstants.primaryColor,
            onRefresh: () async {
              // Get Education Article
              _fetchEducationArticles();
            },

            child: _buildBody(state, isMobile, isTablet),
          ),
        );
      },
    );
  }

  // -------------------------
  // BODY UI BUILDER
  // -------------------------
  Widget _buildBody(
    EducationArticlesState state,
    bool isMobile,
    bool isTablet,
  ) {
    if (state is EducationArticlesLoading) {
      return isTablet
          ? GridView.builder(
              shrinkWrap: true,
              padding: _padding(isMobile, isTablet),
              itemCount: 40,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                childAspectRatio: 5,
              ),
              itemBuilder: (context, index) {
                return KSkeletonRectangle(width: 200, height: 80);
              },
            )
          : ListView.separated(
              shrinkWrap: true,
              padding: _padding(isMobile, isTablet),
              itemCount: 40,
              separatorBuilder: (_, __) => const SizedBox(height: 18),
              itemBuilder: (context, index) {
                return KSkeletonRectangle(width: double.maxFinite, height: 80);
              },
            );
    }

    if (state is EducationArticlesSuccess) {
      final educationArticles = state.topics;

      final allArticles = educationArticles
          .expand((topic) => topic.educationArticles)
          .toList();

      if (educationArticles.isEmpty) {
        return KNoItemsFound();
      }

      return isTablet
          ? GridView.builder(
              shrinkWrap: true,
              padding: _padding(isMobile, isTablet),
              itemCount: allArticles.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                childAspectRatio: 5,
              ),
              itemBuilder: (context, index) {
                final article = allArticles[index];
                return EducationArticleCard(
                  onTap: () {
                    GoRouter.of(context).pushNamed(
                      AppRouterConstants.educationArticlesView,
                      extra: article.id,
                    );
                  },
                  educationArticleName: article.articleName,
                );
              },
            )
          : ListView.separated(
              shrinkWrap: true,
              padding: _padding(isMobile, isTablet),
              itemCount: allArticles.length,
              separatorBuilder: (_, __) => const SizedBox(height: 18),
              itemBuilder: (context, index) {
                final article = allArticles[index];
                return EducationArticleCard(
                  onTap: () {
                    GoRouter.of(context).pushNamed(
                      AppRouterConstants.educationArticlesView,
                      extra: article.id,
                    );
                  },
                  educationArticleName: article.articleName,
                );
              },
            );
    }

    if (state is EducationArticlesFailure) {
      return Center(child: Text(state.message));
    }

    return const SizedBox.shrink();
  }

  EdgeInsets _padding(bool isMobile, bool isTablet) {
    return EdgeInsets.symmetric(
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
    );
  }
}
