import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meshal_doctor_booking_app/core/service/graphql_service.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';
import 'package:meshal_doctor_booking_app/features/chat/model/doctor_model.dart';

part 'doctor_list_event.dart';

part 'doctor_list_state.dart';

class DoctorListBloc extends Bloc<DoctorListEvent, DoctorListState> {
  final GraphQLService graphQLService;

  DoctorListBloc({required this.graphQLService}) : super(DoctorListInitial()) {
    // Get doctor list
    on<GetDoctorListEvent>((event, emit) async {
      emit(GetDoctorListLoading());

      try {
        String query =
            '''
        query Get_chat_contact_lists_ {
          get_chat_contact_lists_(user_id: "${event.userId}") {
            id
            user_id {
              id
              first_name
              last_name
              profile_image
              specialization
            }
          }
        }
        ''';

        AppLoggerHelper.logInfo("GraphQL Query: $query");

        final result = await graphQLService.performQuery(query);

        final list = result.data?["get_chat_contact_lists_"];

        AppLoggerHelper.logInfo("GraphQL Response Data: $list");

        if (list == null) {
          AppLoggerHelper.logError(
            "No data returned for userId: ${event.userId}",
          );
          emit(GetDoctorListFailure(message: "No response from server"));
          return;
        }

        /// Convert list to model list
        final doctorList = (list as List)
            .map((item) => DoctorModel.fromJson(item))
            .toList();

        emit(GetDoctorListSuccess(doctorList: doctorList));
      } catch (e) {
        AppLoggerHelper.logError("Error fetching doctor list: $e");
        emit(GetDoctorListFailure(message: e.toString()));
      }
    });

    // Search doctor list
    on<SearchDoctorListEvent>((event, emit) async {
      emit(SearchDoctorListLoading());

      try {
        String query =
            ''' 
  query Get_chat_contact_lists_ {
  get_chat_contact_lists_(
    user_id: "${event.userId}"
    search: "${event.search}"
  ) {
    id
    user_id {
      id
      first_name
      last_name
      profile_image
      specialization
    }
  }
}
  ''';

        AppLoggerHelper.logInfo("GraphQL Query: $query");

        final result = await graphQLService.performQuery(query);

        final list = result.data?["get_chat_contact_lists_"];

        AppLoggerHelper.logInfo("GraphQL Response Data: $list");

        if (list == null) {
          AppLoggerHelper.logError(
            "No data returned for userId: ${event.userId}",
          );
          emit(SearchDoctorListFailure(message: "No response from server"));
          return;
        }

        /// Convert list to model list
        final doctorList = (list as List)
            .map((item) => DoctorModel.fromJson(item))
            .toList();

        emit(SearchDoctorListSuccess(doctorList: doctorList));
      } catch (e) {
        emit(SearchDoctorListFailure(message: e.toString()));
      }
    });
  }
}
