import 'package:get_it/get_it.dart';
import 'package:meshal_doctor_booking_app/core/service/graphql_service.dart';
import 'package:meshal_doctor_booking_app/features/feedback/feedback.dart';

final GetIt getIt = GetIt.instance;

void initFeedbackInjection() {
  // Doctor Feedback Bloc
  getIt.registerFactory(
    () => DoctorFeedbackBloc(graphQLService: getIt<GraphQLService>()),
  );
}
