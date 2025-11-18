import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meshal_doctor_booking_app/core/service/graphql_service.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';
import 'package:meshal_doctor_booking_app/features/education/model/education_model.dart';

part 'education_event.dart';

part 'education_state.dart';

class EducationBloc extends Bloc<EducationEvent, EducationState> {
  final GraphQLService graphQLService;

  EducationBloc({required this.graphQLService}) : super(EducationInitial()) {
    // Get Education Event
    on<GetEducationEvent>((event, emit) async {
      emit(EducationLoading());

      try {
        final String query =
            '''
      query Get_education_articles_title_list_ {
        Get_education_articles_title_list_(user_id: "${event.userId}") {
          id
          image
          title
          sub_title_counts
          articles_counts
        }
      }
    ''';

        final result = await graphQLService.performQuery(query);

        final articles =
            result.data?['Get_education_articles_title_list_'] as List?;

        if (articles == null) {
          AppLoggerHelper.logError("❌ No articles found in response");
          emit(EducationFailure(message: "No articles found"));
          return;
        }

        AppLoggerHelper.logInfo(
          "📊 Total Education Records Fetched: ${articles.length}",
        );

        // Log each raw item
        for (var i = 0; i < articles.length; i++) {
          AppLoggerHelper.logInfo("🔍 Article[$i]: ${articles[i]}");
        }

        final educationList = articles.map((e) {
          // Log before parsing
          AppLoggerHelper.logInfo(
            "➡️ Parsing Article: "
            "id=${e['id']}, "
            "title=${e['title']}, "
            "sub_title_counts=${e['sub_title_counts']}, "
            "articles_counts=${e['articles_counts']}",
          );

          return Education.fromJson(e);
        }).toList();

        // Log final parsed list
        AppLoggerHelper.logInfo(
          "✅ Parsed ${educationList.length} education items successfully",
        );

        emit(EducationSuccess(educationList));
      } catch (e) {
        AppLoggerHelper.logError("🔥 Education Error: $e");
        emit(EducationFailure(message: e.toString()));
      }
    });
  }
}
