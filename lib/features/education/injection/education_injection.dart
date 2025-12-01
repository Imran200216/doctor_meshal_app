import 'package:get_it/get_it.dart';
import 'package:meshal_doctor_booking_app/features/education/education.dart';
import 'package:meshal_doctor_booking_app/core/service/service.dart';

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

  // Education Articles Bloc
  getIt.registerFactory(
    () => EducationArticlesBloc(graphQLService: getIt<GraphQLService>()),
  );

  // Education Full View Article Bloc
  getIt.registerFactory(
    () => EducationFullViewArticleBloc(graphQLService: getIt<GraphQLService>()),
  );
}
