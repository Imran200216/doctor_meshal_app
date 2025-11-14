import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meshal_doctor_booking_app/core/service/graphql_service.dart';
import 'package:meshal_doctor_booking_app/features/edit_personal_details/model/update_user_profile_details_model.dart';

part 'update_user_profile_details_event.dart';

part 'update_user_profile_details_state.dart';

class UpdateUserProfileDetailsBloc
    extends Bloc<UpdateUserProfileDetailsEvent, UpdateUserProfileDetailsState> {
  final GraphQLService graphQLService;

  UpdateUserProfileDetailsBloc({required this.graphQLService})
    : super(UpdateUserProfileDetailsInitial()) {
    // Update User Profile Details Form Event
    on<UpdateUserProfileDetailsFormEvent>((event, emit) async {
      emit(UpdateUserProfileDetailsLoading());

      try {
        // Construct the GraphQL mutation dynamically from the event
        final String mutation =
            '''
        mutation Update_user_profile_detail_ {
          update_user_profile_detail_(
            first_name_: "${event.model.fistName}"
            last_name_: "${event.model.lastName}"
            age_: "${event.model.age}"
            gender_: "${event.model.gender}"
            height_: "${event.model.height}"
            weight_: "${event.model.weight}"
            blood_group_: "${event.model.bloodGroup}"
            user_id_: "${event.model.userId}"
          )
        }
        ''';

        final result = await graphQLService.performMutation(mutation);

        if (result.hasException) {
          emit(
            UpdateUserProfileDetailsFailure(
              message: result.exception.toString(),
            ),
          );
          return;
        }

        // Access data safely
        final data = result.data?['update_user_profile_detail_'];
        if (data != null) {
          emit(UpdateUserProfileDetailsSuccess(message: data.toString()));
        } else {
          emit(
            const UpdateUserProfileDetailsFailure(
              message: "Failed to update user profile",
            ),
          );
        }
      } catch (e) {
        emit(
          UpdateUserProfileDetailsFailure(message: "Error: ${e.toString()}"),
        );
      }
    });
  }
}
