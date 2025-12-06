import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/core/bloc/connectivity/connectivity_bloc.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/core/service/service.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';
import 'package:meshal_doctor_booking_app/features/education/education.dart';
import 'package:meshal_doctor_booking_app/features/auth/auth.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';

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

  // Fetch Education Articles using userAuthData
  Future<void> _fetchEducationArticles() async {
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
        AppLoggerHelper.logError("No userAuthData found in Hive!");
      }
    } catch (e) {
      AppLoggerHelper.logError("Error fetching User ID from userAuthData: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    // App localization
    final appLoc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColorConstants.secondaryColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: BlocBuilder<EducationArticlesBloc, EducationArticlesState>(
          builder: (context, state) {
            String appBarTitle = "";

            if ((state is EducationArticlesSuccess &&
                    state.topics.isNotEmpty) ||
                (state is EducationArticlesOfflineSuccess &&
                    state.topics.isNotEmpty)) {
              final topics = state is EducationArticlesSuccess
                  ? state.topics
                  : (state as EducationArticlesOfflineSuccess).topics;
              appBarTitle = topics.first.subTitleName;
            }

            if (state is EducationArticlesFailure) {
              appBarTitle = "";
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
          final connectivityState = context.read<ConnectivityBloc>().state;

          if (connectivityState is ConnectivityFailure) {
            // NO INTERNET → show error toast/snackbar
            KSnackBar.error(context, appLoc.noInternet);
            return;
          }

          // Get Education Article
          await _fetchEducationArticles();
        },

        child: BlocBuilder<EducationArticlesBloc, EducationArticlesState>(
          builder: (context, state) {
            // --------------------
            // LOADING
            // --------------------
            if (state is EducationArticlesLoading) {
              return isTablet
                  ? GridView.builder(
                      padding: EdgeInsets.all(20),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 20,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 18,
                            mainAxisSpacing: 18,
                            childAspectRatio: 1.6,
                          ),
                      itemBuilder: (_, __) => KSkeletonRectangle(
                        width: double.maxFinite,
                        radius: 12,
                        height: 160,
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.all(20),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 20,
                      separatorBuilder: (_, __) => const SizedBox(height: 18),
                      itemBuilder: (_, __) => KSkeletonRectangle(
                        width: double.maxFinite,
                        radius: 12,
                        height: 180,
                      ),
                    );
            }

            // --------------------
            // SUCCESS (ONLINE + OFFLINE HIVE DATA)
            // --------------------
            if (state is EducationArticlesSuccess ||
                state is EducationArticlesOfflineSuccess) {
              final topics = state is EducationArticlesSuccess
                  ? state.topics
                  : (state as EducationArticlesOfflineSuccess).topics;

              final allArticles = topics
                  .expand((t) => t.educationArticles)
                  .toList();

              if (allArticles.isEmpty) {
                return Align(
                  alignment: Alignment.center,
                  heightFactor: 3,
                  child: const KNoItemsFound(),
                );
              }

              return isTablet
                  ? GridView.builder(
                      padding: EdgeInsets.all(20),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: allArticles.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 18,
                            mainAxisSpacing: 18,
                            childAspectRatio: 5,
                          ),
                      itemBuilder: (_, index) {
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
                      padding: EdgeInsets.all(20),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: allArticles.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 18),
                      itemBuilder: (_, index) {
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

            // --------------------
            // FAILURE
            // --------------------
            if (state is EducationArticlesFailure) {
              return Align(
                alignment: Alignment.center,
                heightFactor: 3,
                child: KNoItemsFound(
                  noItemsSvg: AppAssetsConstants.failure,
                  noItemsFoundText: appLoc.somethingWentWrong,
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
