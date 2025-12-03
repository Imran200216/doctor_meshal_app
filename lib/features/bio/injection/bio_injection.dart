import 'package:get_it/get_it.dart';
import 'package:meshal_doctor_booking_app/core/service/service.dart';
import 'package:meshal_doctor_booking_app/features/bio/bio.dart';

final GetIt getIt = GetIt.instance;

void initBioInjection() {
  // View Doctor Bio Bloc
  getIt.registerFactory(
    () => ViewDoctorBioBloc(graphQLService: getIt<GraphQLService>()),
  );
}
