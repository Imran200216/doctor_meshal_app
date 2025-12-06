import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meshal_doctor_booking_app/core/service/service.dart';
import 'package:meshal_doctor_booking_app/features/education/education.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';

part 'education_articles_event.dart';

part 'education_articles_state.dart';

class EducationArticlesBloc
    extends Bloc<EducationArticlesEvent, EducationArticlesState> {
  final GraphQLService graphQLService;

  EducationArticlesBloc({required this.graphQLService})
    : super(EducationArticlesInitial()) {
    on<GetEducationArticlesEvent>((event, emit) async {
      EducationArticleTopic? offlineData;

      // -------------------------
      // 1️⃣ Load cached data from Hive
      // -------------------------
      try {
        final saved = await HiveService.getData(
          boxName: AppDBConstants.educationArticlesBox,
          key: event.id, // key = subtitleId
        );

        if (saved != null) {
          // Safe conversion from Hive's dynamic type
          offlineData = await _parseHiveData(saved);

          if (offlineData != null) {
            emit(EducationArticlesOfflineSuccess(topics: [offlineData]));

            AppLoggerHelper.logInfo(
              "📴 Loaded ARTICLES from Hive for subTitleId: ${event.id}",
            );
          } else {
            emit(EducationArticlesLoading());
          }
        } else {
          emit(EducationArticlesLoading());
        }
      } catch (e) {
        emit(EducationArticlesLoading());
        AppLoggerHelper.logError("⚠️ Hive load failed for articles: $e");
      }

      // If offline data is loaded, still show loading state before online fetch
      if (offlineData == null) {
        emit(EducationArticlesLoading());
      }

      // -------------------------
      // 2️⃣ Fetch online data
      // -------------------------
      try {
        String query =
            '''
      query Get_education_articles_topic_list_s {
        Get_education_articles_topic_list_s(id_: "${event.id}", user_id: "${event.userId}") {
          sub_title_name
          education_articles_lists {
            id
            article_name
          }
        }
      }
    ''';

        final result = await graphQLService.performQuery(query);

        if (result.hasException ||
            result.data?['Get_education_articles_topic_list_s'] == null) {
          AppLoggerHelper.logError(
            "⚠️ Online fetch failed for articles id: ${event.id}",
          );

          // No offline? → Show failure
          if (offlineData == null) {
            emit(EducationArticlesFailure(message: "Failed to fetch articles"));
          }
          return;
        }

        final data = result.data!['Get_education_articles_topic_list_s'];

        final model = EducationArticleTopic.fromJson(data);

        // Save to Hive - ensure proper type conversion
        await HiveService.saveData(
          boxName: AppDBConstants.educationArticlesBox,
          key: event.id,
          value: _prepareForHive(model.toJson()),
        );

        emit(EducationArticlesSuccess(topics: [model]));

        AppLoggerHelper.logInfo(
          "✅ Articles fetched successfully (ONLINE) for id: ${event.id}",
        );
      } catch (e, stack) {
        AppLoggerHelper.logError("🔥 Online fetch error: $e");
        AppLoggerHelper.logError(stack.toString());

        if (offlineData == null) {
          emit(EducationArticlesFailure(message: e.toString()));
        }
      }
    });
  }

  /// Parse Hive data and handle type conversions
  Future<EducationArticleTopic?> _parseHiveData(dynamic saved) async {
    try {
      Map<String, dynamic> convertedMap = {};

      if (saved is Map) {
        // Convert Map<dynamic, dynamic> to Map<String, dynamic>
        for (var entry in saved.entries) {
          String key = entry.key.toString();
          dynamic value = entry.value;

          // Recursively convert nested maps
          if (value is Map) {
            value = await _parseHiveData(value);
            if (value is Map<String, dynamic>) {
              convertedMap[key] = value;
            } else {
              convertedMap[key] = _convertValue(value);
            }
          } else {
            convertedMap[key] = _convertValue(value);
          }
        }

        return EducationArticleTopic.fromJson(convertedMap);
      } else if (saved is String) {
        // Handle case where data might be stored as JSON string
        try {
          final Map<String, dynamic> jsonMap = Map<String, dynamic>.from(
            json.decode(saved) as Map<String, dynamic>,
          );
          return EducationArticleTopic.fromJson(jsonMap);
        } catch (e) {
          AppLoggerHelper.logError("Failed to parse JSON string from Hive: $e");
          return null;
        }
      }

      return null;
    } catch (e) {
      AppLoggerHelper.logError("Error parsing Hive data: $e");
      return null;
    }
  }

  /// Convert value to appropriate type
  dynamic _convertValue(dynamic value) {
    if (value is List) {
      return List<dynamic>.from(
        value.map((item) {
          if (item is Map) {
            return _mapFromDynamic(item);
          }
          return item;
        }),
      );
    }
    return value;
  }

  /// Convert Map<dynamic, dynamic> to Map<String, dynamic>
  Map<String, dynamic> _mapFromDynamic(Map<dynamic, dynamic> map) {
    return Map<String, dynamic>.fromEntries(
      map.entries.map(
        (entry) => MapEntry(
          entry.key.toString(),
          entry.value is Map<dynamic, dynamic>
              ? _mapFromDynamic(entry.value as Map<dynamic, dynamic>)
              : entry.value,
        ),
      ),
    );
  }

  /// Prepare data for Hive storage (ensure proper types)
  Map<String, dynamic> _prepareForHive(Map<String, dynamic> json) {
    // Create a copy to avoid modifying original
    final Map<String, dynamic> result = {};

    json.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        // Recursively prepare nested maps
        result[key] = _prepareForHive(value);
      } else if (value is List) {
        // Handle lists
        result[key] = value.map((item) {
          if (item is Map<String, dynamic>) {
            return _prepareForHive(item);
          }
          return item;
        }).toList();
      } else {
        result[key] = value;
      }
    });

    return result;
  }
}
