import 'package:get_it/get_it.dart';
import 'package:meshal_doctor_booking_app/core/service/graphql_service.dart';
import 'package:meshal_doctor_booking_app/features/doctor_peri_operative/view_model/bloc/operative_form/view_doctor_operative_form_bloc.dart';
import 'package:meshal_doctor_booking_app/features/doctor_peri_operative/view_model/bloc/submitted_patient_form_details_section/submitted_patient_form_details_section_bloc.dart';

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
}
