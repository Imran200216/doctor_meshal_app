import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meshal_doctor_booking_app/core/service/graphql_service.dart';
import 'package:meshal_doctor_booking_app/features/peri_operative/model/operative_form_model.dart';

part 'operative_form_event.dart';

part 'operative_form_state.dart';

class OperativeFormBloc extends Bloc<OperativeFormEvent, OperativeFormState> {
  final GraphQLService graphQLService;

  OperativeFormBloc({required this.graphQLService})
    : super(OperativeFormInitial()) {
    // Get Operative Form Event
    on<GetOperativeFormEvents>((event, emit) async {
      emit(OperativeFormLoading());

      try {
        String query =
            '''
        query List_all_operative_form_patient {
          list_all_operative_form_patient(
            user_id: "${event.userId}"
            form_type: "${event.formType}"
          ) {
            id
            title
            form_enable_status
          }
        }
        ''';

        // Perform the GraphQL query
        final result = await graphQLService.performQuery(query);

        if (result.hasException) {
          emit(OperativeFormFailure(message: result.exception.toString()));
          return;
        }

        // Parse the response
        final List<dynamic> list =
            result.data?['list_all_operative_form_patient'] ?? [];

        final List<OperativeForm> operativeForm = list
            .map((json) => OperativeForm.fromJson(json))
            .toList();

        emit(OperativeFormSuccess(operativeForm: operativeForm));
      } catch (e) {
        emit(OperativeFormFailure(message: e.toString()));
      }
    });
  }
}
