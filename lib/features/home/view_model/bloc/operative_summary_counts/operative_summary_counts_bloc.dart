import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meshal_doctor_booking_app/core/service/service.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';

part 'operative_summary_counts_event.dart';
part 'operative_summary_counts_state.dart';

/// Helper to convert Hive Map<dynamic, dynamic> to Map<String, dynamic>
Map<String, dynamic> convertToMapStringDynamic(Map<dynamic, dynamic> map) {
  final result = <String, dynamic>{};
  map.forEach((key, value) {
    final k = key.toString();
    if (value is Map) {
      result[k] =
          convertToMapStringDynamic(Map<dynamic, dynamic>.from(value));
    } else {
      result[k] = value;
    }
  });
  return result;
}

class OperativeSummaryCountsBloc
    extends Bloc<OperativeSummaryCountsEvent, OperativeSummaryCountsState> {
  final GraphQLService graphQLService;

  OperativeSummaryCountsBloc({required this.graphQLService})
      : super(OperativeSummaryCountsInitial()) {
    on<GetOperativeSummaryCountEvent>((event, emit) async {
      // 1️⃣ Try loading offline from Hive first
      Map<String, dynamic>? offlineData;

      try {
        final saved = await HiveService.getData(
          boxName: AppDBConstants.operativeSummaryBox,
          key: event.userId,
        );

        if (saved != null) {
          offlineData = convertToMapStringDynamic(Map<dynamic, dynamic>.from(saved));

          emit(
            GetOperativeSummaryCountsOfflineSuccess(
              preOperativeCounts: offlineData["post_operative_counts"],
              postOperativeCounts: offlineData["pre_operative_counts"],
              submittedCountsOperative: offlineData["submited_counts_operative"],
            ),
          );

          AppLoggerHelper.logInfo(
            "📴 Loaded operative summary from Hive for userId: ${event.userId}",
          );
        }
      } catch (e) {
        AppLoggerHelper.logError(
          "⚠️ Hive load failed for operative summary: $e",
        );
      }

      // 2️⃣ Emit loading if no offline data exists
      if (offlineData == null) emit(GetOperativeSummaryCountsLoading());

      // 3️⃣ Fetch online data
      try {
        String query = '''
          query Get_operative_summary_counts_ {
            get_operative_summary_counts_(user_id: "${event.userId}") {
              post_operative_counts
              pre_operative_counts
              submited_counts_operative
            }
          }
        ''';

        AppLoggerHelper.logInfo("GraphQL Query: $query");

        final result = await graphQLService.performQuery(query);
        final list = result.data?["get_operative_summary_counts_"];

        AppLoggerHelper.logInfo("GraphQL Response Data: $list");

        if (list == null) {
          AppLoggerHelper.logError("No data returned for userId: ${event.userId}");
          if (offlineData == null) {
            emit(
              GetOperativeSummaryCountsFailure(message: "No response from server"),
            );
          }
          return;
        }

        // 4️⃣ Save online data to Hive
        await HiveService.saveData(
          boxName: AppDBConstants.operativeSummaryBox,
          key: event.userId,
          value: list,
        );

        // 5️⃣ Emit success state
        emit(
          GetOperativeSummaryCountsSuccess(
            preOperativeCounts: list["post_operative_counts"],
            postOperativeCounts: list["pre_operative_counts"],
            submittedCountsOperative: list["submited_counts_operative"],
          ),
        );

        AppLoggerHelper.logInfo(
          "✅ Operative summary fetched successfully for userId: ${event.userId}",
        );
      } catch (e) {
        AppLoggerHelper.logError("🔥 Online fetch error: $e");
        if (offlineData == null) {
          emit(GetOperativeSummaryCountsFailure(message: e.toString()));
        }
      }
    });
  }
}
