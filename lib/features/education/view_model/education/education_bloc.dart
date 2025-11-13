import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meshal_doctor_booking_app/core/service/graphql_service.dart';
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
          }
        }
        ''';

        final result = await graphQLService.performQuery(query);

        final articles =
            result.data?['Get_education_articles_title_list_'] as List?;

        if (articles == null) {
          emit(EducationFailure(message: "No articles found"));
          return;
        }

        final educationList = articles
            .map((e) => Education.fromJson(e))
            .toList();

        emit(EducationSuccess(educationList));
      } catch (e) {
        emit(EducationFailure(message: e.toString()));
      }
    });
  }
}
