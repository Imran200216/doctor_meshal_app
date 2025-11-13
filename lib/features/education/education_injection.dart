import 'package:get_it/get_it.dart';
import 'package:meshal_doctor_booking_app/core/service/graphql_service.dart';
import 'package:meshal_doctor_booking_app/features/education/view_model/education/education_bloc.dart';
import 'package:meshal_doctor_booking_app/features/education/view_model/education_sub_title/education_sub_title_bloc.dart';

final GetIt getIt = GetIt.instance;

void initEducationInjection() {
  // Education Bloc
  getIt.registerFactory(
    () => EducationBloc(graphQLService: getIt<GraphQLService>()),
  );

  // Education Sub Title Bloc
  getIt.registerFactory(
    () => EducationSubTitleBloc(graphQLService: getIt<GraphQLService>()),
  );
}
