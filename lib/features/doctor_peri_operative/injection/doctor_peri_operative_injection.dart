import 'package:get_it/get_it.dart';
import 'package:meshal_doctor_booking_app/core/service/service.dart';
import 'package:meshal_doctor_booking_app/features/doctor_peri_operative/doctor_peri_operative.dart';

final GetIt getIt = GetIt.instance;

void initDoctorPeriOperativeInjection() {
  // Doctor Peri Operative Form Bloc
  getIt.registerFactory(
    () => ViewDoctorOperativeFormBloc(graphQLService: getIt<GraphQLService>()),
  );

  // SubmittedPatientFormDetailsSectionBloc
  getIt.registerFactory(
    () => SubmittedPatientFormDetailsSectionBloc(
      graphQLService: getIt<GraphQLService>(),
    ),
  );

  // Doctor Review Patient Submitted Operation Forms Bloc
  getIt.registerFactory(
    () => DoctorReviewPatientSubmittedOperationFormsBloc(
      graphQLService: getIt<GraphQLService>(),
    ),
  );
}
