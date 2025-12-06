import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meshal_doctor_booking_app/core/service/service.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/features/home/model/get_dashboard_counts_summary_model.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';

part 'doctor_dashboard_summary_counts_event.dart';

part 'doctor_dashboard_summary_counts_state.dart';

/// Utility to convert Hive Map<dynamic, dynamic> to Map<String, dynamic>
Map<String, dynamic> convertToMapStringDynamic(Map<dynamic, dynamic> map) {
  final result = <String, dynamic>{};
  map.forEach((key, value) {
    final k = key.toString();
    if (value is Map) {
      result[k] = convertToMapStringDynamic(Map<dynamic, dynamic>.from(value));
    } else {
      result[k] = value;
    }
  });
  return result;
}

class DoctorDashboardSummaryCountsBloc
    extends
        Bloc<
          DoctorDashboardSummaryCountsEvent,
          DoctorDashboardSummaryCountsState
        > {
  final GraphQLService graphQLService;

  DoctorDashboardSummaryCountsBloc({required this.graphQLService})
    : super(DoctorDashboardSummaryCountsInitial()) {
    on<GetDoctorDashboardSummaryCountsEvent>((event, emit) async {
      GetDashboardCountsSummaryModel? offlineData;

      // 1️⃣ Try loading offline from Hive first
      try {
        final saved = await HiveService.getData(
          boxName: AppDBConstants.doctorDashboardSummaryBox,
          key: event.userId,
        );

        if (saved != null) {
          final savedMap = convertToMapStringDynamic(
            Map<dynamic, dynamic>.from(saved),
          );

          offlineData = GetDashboardCountsSummaryModel.fromJson(savedMap);

          emit(
            GetDashboardSummaryCountsOfflineSuccess(
              getDashboardCountsSummaryModel: offlineData,
            ),
          );

          AppLoggerHelper.logInfo(
            "📴 Loaded dashboard summary from Hive for userId: ${event.userId}",
          );
        }
      } catch (e) {
        AppLoggerHelper.logError(
          "⚠️ Hive load failed for dashboard summary: $e",
        );
      }

      // 2️⃣ Emit loading if no offline data exists
      if (offlineData == null) emit(GetDashboardSummaryCountsLoading());

      // 3️⃣ Fetch online data
      try {
        String query =
            '''
          query Get_dashboard_counts_summary {
            get_dashboard_counts_summary(user_id: "${event.userId}") {
              post_operative_submited
              pre_operative_submited
              total_education_articles
              total_patient
            }
          }
        ''';

        final result = await graphQLService.performQuery(query);

        if (result.hasException || result.data == null) {
          AppLoggerHelper.logError(
            "⚠️ Online fetch failed for dashboard summary: ${result.exception}",
          );
          if (offlineData == null) {
            emit(
              GetDashboardSummaryCountsFailure(
                message: result.exception.toString(),
              ),
            );
          }
          return;
        }

        final summaryModel = GetDashboardCountsSummaryModel.fromJson(
          result.data!,
        );

        // 4️⃣ Save online data to Hive
        await HiveService.saveData(
          boxName: AppDBConstants.doctorDashboardSummaryBox,
          key: event.userId,
          value: summaryModel.toJson(),
        );

        emit(
          GetDashboardSummaryCountsSuccess(
            getDashboardCountsSummaryModel: summaryModel,
          ),
        );

        AppLoggerHelper.logInfo(
          "✅ Dashboard summary fetched successfully for userId: ${event.userId}",
        );
      } catch (e) {
        AppLoggerHelper.logError("🔥 Online fetch error: $e");
        if (offlineData == null) {
          emit(GetDashboardSummaryCountsFailure(message: e.toString()));
        }
      }
    });
  }
}
