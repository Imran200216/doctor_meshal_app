import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meshal_doctor_booking_app/core/service/service.dart';
import 'package:meshal_doctor_booking_app/features/bio/bio.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';

part 'view_doctor_bio_event.dart';
part 'view_doctor_bio_state.dart';

class ViewDoctorBioBloc extends Bloc<ViewDoctorBioEvent, ViewDoctorBioState> {
  final GraphQLService graphQLService;

  ViewDoctorBioBloc({required this.graphQLService})
      : super(ViewDoctorBioInitial()) {
    on<GetViewDoctorBioEvent>((event, emit) async {
      emit(ViewDoctorBioLoading());

      try {
        String query = '''
          query View_doctor_bio_data {
            view_doctor_bio_data(user_id: "${event.userId}") {
              descriptions_doctor_bio {
                bio_description
                id
              }
              doctor_id {
                id
                first_name
                profile_image
                specialization
              }
            }
          }
        ''';

        AppLoggerHelper.logInfo('📡 Executing GraphQL query for user: ${event.userId}');

        /// 🔥 GraphQL call
        final result = await graphQLService.performQuery(query);

        // 2. Check for GraphQL errors
        if (result.hasException) {
          final error = result.exception?.graphqlErrors.firstOrNull;
          AppLoggerHelper.logError('❌ GraphQL Error: ${error?.message}');
          emit(ViewDoctorBioFailure(
              message: error?.message ?? "GraphQL error occurred"
          ));
          return;
        }

        // 3. Log the full response for debugging
        AppLoggerHelper.logInfo('📦 Full GraphQL Response: ${result.data}');

        // 4. Check if data is null or missing required structure
        if (result.data == null || result.data!['view_doctor_bio_data'] == null) {
          AppLoggerHelper.logError('❌ result.data is null or missing view_doctor_bio_data');
          AppLoggerHelper.logError('❌ Available keys: ${result.data?.keys}');
          emit(ViewDoctorBioFailure(message: "No bio information found for this doctor"));
          return;
        }

        final viewDoctorBioData = result.data!['view_doctor_bio_data'];

        // 5. Check if view_doctor_bio_data is null
        if (viewDoctorBioData == null) {
          AppLoggerHelper.logError('❌ view_doctor_bio_data is null');
          emit(ViewDoctorBioFailure(
              message: "No bio information found for this doctor"
          ));
          return;
        }

        // 6. Validate data structure
        if (!viewDoctorBioData.containsKey('doctor_id')) {
          AppLoggerHelper.logError('❌ Missing required field: doctor_id');
          emit(ViewDoctorBioFailure(
              message: "Invalid doctor data format"
          ));
          return;
        }

        // 7. Check if descriptions_doctor_bio exists (can be empty list)
        if (!viewDoctorBioData.containsKey('descriptions_doctor_bio')) {
          AppLoggerHelper.logError('❌ Missing field: descriptions_doctor_bio');
          emit(ViewDoctorBioFailure(
              message: "Invalid bio data format"
          ));
          return;
        }

        final bioList = viewDoctorBioData['descriptions_doctor_bio'] as List?;

        if (bioList == null) {
          AppLoggerHelper.logError('❌ descriptions_doctor_bio is null');
          emit(ViewDoctorBioFailure(
              message: "Invalid bio data format"
          ));
          return;
        }

        if (bioList.isEmpty) {
          AppLoggerHelper.logInfo('📭 No bio descriptions found for doctor');
        } else {
          AppLoggerHelper.logInfo(
            "📌 Total Doctor Bio Records Fetched: ${bioList.length}",
          );
        }

        try {
          /// 🔥 Convert view_doctor_bio_data directly to model
          final model = DoctorBioDescriptionModel.fromJson(viewDoctorBioData);
          AppLoggerHelper.logInfo('✅ Successfully parsed doctor bio model');
          emit(ViewDoctorBioLoaded(doctorBioDescriptionModel: model));
        } catch (e, stackTrace) {
          AppLoggerHelper.logError('❌ Error parsing doctor bio model: $e');
          AppLoggerHelper.logError('❌ Stack trace: $stackTrace');
          AppLoggerHelper.logError('❌ Data that failed to parse: $viewDoctorBioData');
          emit(ViewDoctorBioFailure(
              message: "Failed to parse bio data: ${e.toString()}"
          ));
        }
      } catch (e, stackTrace) {
        AppLoggerHelper.logError("❌ Exception in ViewDoctorBioBloc: $e");
        AppLoggerHelper.logError("❌ Stack trace: $stackTrace");
        emit(ViewDoctorBioFailure(
            message: "An error occurred: ${e.toString()}"
        ));
      }
    });
  }
}