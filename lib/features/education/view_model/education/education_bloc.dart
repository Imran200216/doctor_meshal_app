import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meshal_doctor_booking_app/core/service/graphql_service.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';
import 'package:meshal_doctor_booking_app/core/service/hive_service.dart';
import 'package:meshal_doctor_booking_app/features/education/model/education_model.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_db_constants.dart';

part 'education_event.dart';

part 'education_state.dart';

class EducationBloc extends Bloc<EducationEvent, EducationState> {
  final GraphQLService graphQLService;

  EducationBloc({required this.graphQLService}) : super(EducationInitial()) {
    on<GetEducationEvent>((event, emit) async {
      List<Education>? offlineList;

      try {
        // 1️⃣ Load offline data from Hive first
        final saved = await HiveService.getData(
          boxName: AppDBConstants.educationBox,
          key: AppDBConstants.educationList,
        );

        if (saved != null) {
          // Hive might store List<Map<String, dynamic>>
          offlineList = (saved as List)
              .map((e) => Education.fromJson(Map<String, dynamic>.from(e)))
              .toList();

          emit(EducationOfflineSuccess(educations: offlineList));
          AppLoggerHelper.logInfo(
            "📴 Loaded education articles from Hive (offline first)",
          );
        } else {
          emit(EducationLoading());
        }
      } catch (e) {
        emit(EducationLoading());
        AppLoggerHelper.logError("⚠️ Hive load failed: $e");
      }

      try {
        // 2️⃣ Fetch online data (background refresh)
        final String query =
            '''
      query Get_education_articles_title_list_ {
        Get_education_articles_title_list_(user_id: "${event.userId}") {
          id
          image
          title
          sub_title_counts
          articles_counts
        }
      }
    ''';

        AppLoggerHelper.logInfo(
          "📥 Fetching education articles online for userId: ${event.userId}",
        );

        final result = await graphQLService.performQuery(query);

        if (result.hasException ||
            result.data?['Get_education_articles_title_list_'] == null) {
          AppLoggerHelper.logError("⚠️ Online fetch failed");
          if (offlineList == null) {
            emit(
              EducationFailure(message: "Failed to fetch education articles"),
            );
          }
          return;
        }

        final articles =
            result.data!['Get_education_articles_title_list_'] as List;
        final educationList = articles
            .map((e) => Education.fromJson(e))
            .toList();

        // Save online data to Hive
        await HiveService.saveData(
          boxName: AppDBConstants.educationBox,
          key: AppDBConstants.educationList,
          value: educationList.map((e) => e.toJson()).toList(),
        );

        emit(EducationSuccess(educationList));
        AppLoggerHelper.logInfo(
          "✅ Education articles fetched successfully (ONLINE)",
        );
      } catch (e) {
        AppLoggerHelper.logError("🔥 Online fetch error: $e");
        if (offlineList == null) {
          emit(EducationFailure(message: e.toString()));
        }
      }
    });
  }
}
