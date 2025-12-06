import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meshal_doctor_booking_app/core/service/service.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';
import 'package:meshal_doctor_booking_app/features/education/education.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';

part 'education_full_view_article_event.dart';

part 'education_full_view_article_state.dart';

class EducationFullViewArticleBloc
    extends Bloc<EducationFullViewArticleEvent, EducationFullViewArticleState> {
  final GraphQLService graphQLService;

  EducationFullViewArticleBloc({required this.graphQLService})
    : super(EducationFullViewArticleInitial()) {
    on<GetEducationFullViewArticleEvent>((event, emit) async {
      EducationFullViewArticle? offlineArticle;

      // -------------------------
      // 1️⃣ Load cached article from Hive
      // -------------------------
      try {
        final saved = await HiveService.getData(
          boxName: AppDBConstants.educationFullViewArticleBox,
          key: event.id,
        );

        if (saved != null) {
          final savedMap = Map<String, dynamic>.from(saved);

          offlineArticle = EducationFullViewArticle.fromJson(savedMap);

          emit(EducationFullViewArticleOfflineSuccess(article: offlineArticle));

          AppLoggerHelper.logInfo(
            "📴 Loaded full article from Hive for id: ${event.id}",
          );
        } else {
          emit(EducationFullViewArticleLoading());
        }
      } catch (e) {
        emit(EducationFullViewArticleLoading());
        AppLoggerHelper.logError("⚠️ Hive load failed for full article: $e");
      }

      // -------------------------
      // 2️⃣ Fetch online from GraphQL
      // -------------------------
      try {
        String query =
            '''
        query View_education_article_by_topic_ {
          View_education_article_by_topic_(id: "${event.id}", user_id: "${event.userId}") {
            article
            article_name
            id
            title_name
            sub_title_name
          }
        }
        ''';

        final result = await graphQLService.performQuery(query);

        if (result.hasException ||
            result.data?['View_education_article_by_topic_'] == null) {
          AppLoggerHelper.logError(
            "⚠️ Online fetch failed for full article id: ${event.id}",
          );

          // fallback to offline if exists
          if (offlineArticle == null) {
            emit(
              EducationFullViewArticleError(
                message: "Failed to fetch full article",
              ),
            );
          }
          return;
        }

        final data = result.data!['View_education_article_by_topic_'];
        final article = EducationFullViewArticle.fromJson(data);

        // Save online data to Hive
        await HiveService.saveData(
          boxName: AppDBConstants.educationFullViewArticleBox,
          key: event.id,
          value: article.toJson(),
        );

        emit(EducationFullViewArticleSuccess(article: article));
        AppLoggerHelper.logInfo(
          "✅ Full article fetched successfully (ONLINE) for id: ${event.id}",
        );
      } catch (e, stack) {
        AppLoggerHelper.logError("🔥 Online fetch error: $e");
        AppLoggerHelper.logError(stack.toString());

        if (offlineArticle == null) {
          emit(EducationFullViewArticleError(message: e.toString()));
        }
      }
    });
  }
}
