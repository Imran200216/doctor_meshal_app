import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meshal_doctor_booking_app/core/service/graphql_service.dart';
import 'package:meshal_doctor_booking_app/features/education/model/education_sub_title_model.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';

part 'education_sub_title_event.dart';

part 'education_sub_title_state.dart';

class EducationSubTitleBloc
    extends Bloc<EducationSubTitleEvent, EducationSubTitleState> {
  final GraphQLService graphQLService;

  EducationSubTitleBloc({required this.graphQLService})
    : super(EducationSubTitleInitial()) {
    on<GetEducationSubTitleEvent>((event, emit) async {
      emit(EducationSubTitleLoading());
      AppLoggerHelper.logInfo(
        "Fetching subtitles for educationTitleId: ${event.educationTitleId}",
      );

      try {
        final String query =
            '''
          query Get_education_articles_sub_title_list_s {
            Get_education_articles_sub_title_list_s(
              id_: "${event.educationTitleId}"
              user_id: "${event.userId}"
            ) {
              title
              article_subtitles_lists {
                id
                image
                sub_title_name
                education_article_counts
              }
            }
          }
        ''';

        final result = await graphQLService.performQuery(query);

        // Debug logs
        AppLoggerHelper.logInfo("GraphQL Response: ${result.data}");

        // Check for GraphQL or network errors
        if (result.hasException) {
          final errorMessage =
              result.exception?.graphqlErrors.isNotEmpty == true
              ? result.exception?.graphqlErrors.first.message
              : "Unknown GraphQL error";
          AppLoggerHelper.logError("GraphQL Exception: $errorMessage");
          emit(EducationSubTitleFailure(message: errorMessage ?? "Error"));
          return;
        }

        final data = result.data?['Get_education_articles_sub_title_list_s'];
        if (data == null) {
          AppLoggerHelper.logError("Response data is null");
          emit(
            const EducationSubTitleFailure(
              message: "No data found for this education title.",
            ),
          );
          return;
        }

        final List<dynamic> subtitleList =
            data['article_subtitles_lists'] ?? [];

        final List<EducationSubTitleModel> subtitles = subtitleList
            .map((json) => EducationSubTitleModel.fromJson(json))
            .toList();

        emit(
          EducationSubTitleSuccess(
            mainTitle: data['title'] ?? '',
            subtitles: subtitles,
          ),
        );
      } catch (e, stack) {
        AppLoggerHelper.logError("Error fetching education subtitles: $e");
        AppLoggerHelper.logError(stack.toString());
        emit(EducationSubTitleFailure(message: e.toString()));
      }
    });
  }
}
