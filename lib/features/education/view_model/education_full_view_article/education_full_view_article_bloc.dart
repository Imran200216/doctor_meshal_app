import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meshal_doctor_booking_app/core/service/graphql_service.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';
import 'package:meshal_doctor_booking_app/features/education/model/education_full_view_article_model.dart';

part 'education_full_view_article_event.dart';

part 'education_full_view_article_state.dart';

class EducationFullViewArticleBloc
    extends Bloc<EducationFullViewArticleEvent, EducationFullViewArticleState> {
  final GraphQLService graphQLService;

  EducationFullViewArticleBloc({required this.graphQLService})
    : super(EducationFullViewArticleInitial()) {
    on<GetEducationFullViewArticleEvent>((event, emit) async {
      emit(EducationFullViewArticleLoading());

      try {
        String query =
            '''
        query View_education_article_by_topic_ {
          View_education_article_by_topic_(id: "${event.id}", user_id: "${event.userId}") {
            article
            article_name
            id
          }
        }
        ''';

        final result = await graphQLService.performQuery(query);

        // Logging the raw result
        AppLoggerHelper.logInfo("GraphQL Raw Result: $result");

        // result is likely a QueryResult
        final data = result.data?['View_education_article_by_topic_'];

        if (data != null) {
          AppLoggerHelper.logInfo("GraphQL Data: $data");

          final article = EducationFullViewArticle.fromJson(data);

          emit(EducationFullViewArticleSuccess(article: article));
          AppLoggerHelper.logInfo("EducationFullViewArticleSuccess emitted");
        } else {
          AppLoggerHelper.logError("No article data found in GraphQL response");
          emit(
            const EducationFullViewArticleError(
              message: "No article data found",
            ),
          );
        }
      } catch (e) {
        AppLoggerHelper.logError("Error fetching article: $e");
        emit(EducationFullViewArticleError(message: e.toString()));
      }
    });
  }
}
