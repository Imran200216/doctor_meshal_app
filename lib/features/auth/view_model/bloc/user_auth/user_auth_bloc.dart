import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meshal_doctor_booking_app/core/service/graphql_service.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';
import 'package:meshal_doctor_booking_app/features/auth/model/user_auth_model.dart';

part 'user_auth_event.dart';
part 'user_auth_state.dart';

class UserAuthBloc extends Bloc<UserAuthEvent, UserAuthState> {
  final GraphQLService graphQLService;

  UserAuthBloc(this.graphQLService) : super(UserAuthInitial()) {
    on<GetUserAuthEvent>((event, emit) async {
      emit(GetUserAuthLoading());
      AppLoggerHelper.logInfo("Fetching user data for id: ${event.id}");

      try {
        final String query = '''
        query Get_user_by_id_auth_ {
          get_user_by_id_auth_(id: "${event.id}", token: "${event.token}") {
            id
            profile_image
            first_name
            last_name
            email
            phone_code
            phone_number
            register_date
            age
            gender
            height
            weight
            blood_group
            cid
            createdAt
            updatedAt
            user_type
          }
        }
        ''';

        AppLoggerHelper.logInfo("GraphQL Query: $query");

        final result = await graphQLService.performQuery(query);

        final userData = result.data?['get_user_by_id_auth_'];
        AppLoggerHelper.logInfo("GraphQL Response Data: $userData");

        if (userData == null) {
          AppLoggerHelper.logError("No user data found for id: ${event.id}");
          emit(GetUserAuthFailure(message: "No user data found"));
          return;
        }

        final user = UserAuthModel.fromJson(userData);
        emit(GetUserAuthSuccess(user: user));
        AppLoggerHelper.logInfo("User data fetched successfully for id: ${event.id}");
      } catch (e) {
        AppLoggerHelper.logError("Error fetching user data for id: ${event.id}, Error: $e");
        emit(GetUserAuthFailure(message: e.toString()));
      }
    });
  }
}
