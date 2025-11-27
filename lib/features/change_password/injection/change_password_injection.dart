import 'package:get_it/get_it.dart';
import 'package:meshal_doctor_booking_app/core/service/graphql_service.dart';
import 'package:meshal_doctor_booking_app/features/change_password/view_model/bloc/change_password/change_password_bloc.dart';

final GetIt getIt = GetIt.instance;

void initChangePasswordInjection() {
  // Change Password Bloc
  getIt.registerFactory(
    () => ChangePasswordBloc(graphQLService: getIt<GraphQLService>()),
  );
}
