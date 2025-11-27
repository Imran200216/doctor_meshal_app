import 'package:get_it/get_it.dart';
import 'package:meshal_doctor_booking_app/core/service/graphql_service.dart';
import 'package:meshal_doctor_booking_app/features/edit_personal_details/view_model/bloc/update_user_profile_details_bloc.dart';
import 'package:meshal_doctor_booking_app/features/edit_personal_details/view_model/cubit/profile_image/profile_image_cubit.dart';

final GetIt getIt = GetIt.instance;

void initEditProfileDetailsInjection() {
  // Email Auth Bloc
  getIt.registerFactory(
    () => UpdateUserProfileDetailsBloc(graphQLService: getIt<GraphQLService>()),
  );

  // Profile Image Cubit
  getIt.registerFactory(() => ProfileImageCubit());
}
