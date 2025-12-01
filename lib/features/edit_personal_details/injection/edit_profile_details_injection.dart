import 'package:get_it/get_it.dart';
import 'package:meshal_doctor_booking_app/features/edit_personal_details/edit_personal_details.dart';
import 'package:meshal_doctor_booking_app/core/service/service.dart';

final GetIt getIt = GetIt.instance;

void initEditProfileDetailsInjection() {
  // Email Auth Bloc
  getIt.registerFactory(
    () => UpdateUserProfileDetailsBloc(graphQLService: getIt<GraphQLService>()),
  );

  // Profile Image Cubit
  getIt.registerFactory(() => ProfileImageCubit());
}
