import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meshal_doctor_booking_app/core/service/service.dart';
import 'package:meshal_doctor_booking_app/features/education/education.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';

part 'education_sub_title_event.dart';

part 'education_sub_title_state.dart';

class EducationSubTitleBloc
    extends Bloc<EducationSubTitleEvent, EducationSubTitleState> {
  final GraphQLService graphQLService;

  EducationSubTitleBloc({required this.graphQLService})
    : super(EducationSubTitleInitial()) {
    on<GetEducationSubTitleEvent>((event, emit) async {
      List<EducationSubTitleModel>? offlineList;
      String offlineTitle = '';

      // 1️⃣ Load cached data from Hive first
      try {
        final saved = await HiveService.getData(
          boxName: AppDBConstants.educationSubTitleBox,
          key: event.educationTitleId,
        );

        if (saved != null) {
          final savedMap = Map<String, dynamic>.from(saved);
          offlineTitle = savedMap['mainTitle'] ?? '';
          offlineList = (savedMap['subtitles'] as List)
              .map(
                (e) => EducationSubTitleModel.fromJson(
                  Map<String, dynamic>.from(e),
                ),
              )
              .toList();

          emit(
            EducationSubTitleOfflineSuccess(
              mainTitle: offlineTitle,
              subtitles: offlineList,
            ),
          );

          AppLoggerHelper.logInfo(
            "📴 Loaded subtitles and mainTitle from Hive for titleId: ${event.educationTitleId}",
          );
        } else {
          emit(EducationSubTitleLoading());
        }
      } catch (e) {
        emit(EducationSubTitleLoading());
        AppLoggerHelper.logError("⚠️ Hive load failed: $e");
      }

      // 2️⃣ Fetch online data
      try {
        final String query =
            '''
         query Get_education_articles_sub_title_list_s {
            Get_education_articles_sub_title_list_s(
              id_: "${event.educationTitleId}"
              user_id: "${event.userId}"
            ) {
              title
              article_subtitles_lists {
                id
                image
                sub_title_name
                education_article_counts
              }
            }
          }
        ''';

        final result = await graphQLService.performQuery(query);

        if (result.hasException ||
            result.data?['Get_education_articles_sub_title_list_s'] == null) {
          AppLoggerHelper.logError(
            "⚠️ Online fetch failed for titleId: ${event.educationTitleId}",
          );
          if (offlineList == null) {
            emit(
              EducationSubTitleFailure(message: "Failed to fetch subtitles"),
            );
          }
          return;
        }

        final data = result.data!['Get_education_articles_sub_title_list_s'];

        final List<dynamic> subtitleList =
            data['article_subtitles_lists'] ?? [];

        final subtitles = subtitleList
            .map((json) => EducationSubTitleModel.fromJson(json))
            .toList();

        final mainTitle = data['title'] ?? '';

        // Save online data + mainTitle to Hive
        await HiveService.saveData(
          boxName: AppDBConstants.educationSubTitleBox,
          key: event.educationTitleId,
          value: {
            'mainTitle': mainTitle,
            'subtitles': subtitles.map((e) => e.toJson()).toList(),
          },
        );

        emit(
          EducationSubTitleSuccess(mainTitle: mainTitle, subtitles: subtitles),
        );

        AppLoggerHelper.logInfo(
          "✅ Subtitles + mainTitle fetched successfully (ONLINE) for titleId: ${event.educationTitleId}",
        );
      } catch (e, stack) {
        AppLoggerHelper.logError("🔥 Online fetch error: $e");
        AppLoggerHelper.logError(stack.toString());
        if (offlineList == null) {
          emit(EducationSubTitleFailure(message: e.toString()));
        }
      }
    });
  }
}
