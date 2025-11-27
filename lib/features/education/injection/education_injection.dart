import 'package:get_it/get_it.dart';
import 'package:meshal_doctor_booking_app/core/service/graphql_service.dart';
import 'package:meshal_doctor_booking_app/features/education/view_model/education/education_bloc.dart';
import 'package:meshal_doctor_booking_app/features/education/view_model/education_articles/education_articles_bloc.dart';
import 'package:meshal_doctor_booking_app/features/education/view_model/education_full_view_article/education_full_view_article_bloc.dart';
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

  // Education Articles Bloc
  getIt.registerFactory(
    () => EducationArticlesBloc(graphQLService: getIt<GraphQLService>()),
  );

  // Education Full View Article Bloc
  getIt.registerFactory(
    () => EducationFullViewArticleBloc(graphQLService: getIt<GraphQLService>()),
  );
}
