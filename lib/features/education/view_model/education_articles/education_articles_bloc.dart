import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meshal_doctor_booking_app/core/service/graphql_service.dart';
import 'package:meshal_doctor_booking_app/features/education/model/education_article_topic_model.dart';

part 'education_articles_event.dart';

part 'education_articles_state.dart';

class EducationArticlesBloc
    extends Bloc<EducationArticlesEvent, EducationArticlesState> {
  final GraphQLService graphQLService;

  EducationArticlesBloc({required this.graphQLService})
    : super(EducationArticlesInitial()) {
    // Get Education Articles Event
    on<GetEducationArticlesEvent>((event, emit) async {
      emit(EducationArticlesLoading());

      try {
        String query =
            '''
      query Get_education_articles_topic_list_s {
        Get_education_articles_topic_list_s(id_: "${event.id}", user_id: "${event.userId}") {
          sub_title_name
          education_articles_lists {
            id
            article_name
          }
        }
      }
    ''';

        final result = await graphQLService.performQuery(query);

        if (result.hasException) {
          emit(EducationArticlesFailure(message: result.exception.toString()));
          return;
        }

        final data = result.data?['Get_education_articles_topic_list_s'];

        if (data == null) {
          emit(EducationArticlesFailure(message: "No data found"));
          return;
        }

        final model = EducationArticleTopic.fromJson(data);

        emit(EducationArticlesSuccess(topics: [model]));
      } catch (e) {
        emit(EducationArticlesFailure(message: e.toString()));
      }
    });
  }
}
