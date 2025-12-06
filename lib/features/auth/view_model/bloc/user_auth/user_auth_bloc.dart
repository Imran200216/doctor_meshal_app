import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/core/service/service.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';
import 'package:meshal_doctor_booking_app/features/auth/auth.dart';

part 'user_auth_event.dart';

part 'user_auth_state.dart';

class UserAuthBloc extends Bloc<UserAuthEvent, UserAuthState> {
  final GraphQLService graphQLService;

  UserAuthBloc(this.graphQLService) : super(UserAuthInitial()) {
    on<GetUserAuthEvent>((event, emit) async {
      UserAuthModel? offlineUser;

      // -----------------------------
      // 1️⃣ Load offline Hive data first
      // -----------------------------
      try {
        final saved = await HiveService.getData(
          boxName: AppDBConstants.profileUserBox,
          key: AppDBConstants.profileUser,
        );

        if (saved != null) {
          // Cast to Map<String, dynamic> safely
          final map = Map<String, dynamic>.from(saved as Map);
          offlineUser = UserAuthModel.fromJson(map);
          emit(GetUserAuthOfflineSuccess(user: offlineUser));
          AppLoggerHelper.logInfo("📴 Loaded user from Hive (offline first)");
        } else {
          emit(GetUserAuthLoading());
        }
      } catch (e) {
        emit(GetUserAuthLoading());
        AppLoggerHelper.logError("⚠️ Hive load failed: $e");
      }

      // -----------------------------
      // 2️⃣ Fetch online data in background
      // -----------------------------
      try {
        final query =
            '''
        query Get_user_by_id_auth_ {
          get_user_by_id_auth_(id: "${event.id}", token: "") {
            id
            profile_image
            first_name
            last_name
            email
            phone_code
            phone_number
            register_date
            age
            gender
            height
            weight
            blood_group
            cid
            createdAt
            updatedAt
            user_type
          }
        }
        ''';

        AppLoggerHelper.logInfo("📥 GraphQL Query: $query");

        final result = await graphQLService.performQuery(query);

        if (result.hasException ||
            result.data?['get_user_by_id_auth_'] == null) {
          AppLoggerHelper.logError("⚠️ Online fetch failed");
          if (offlineUser == null) {
            emit(GetUserAuthFailure(message: "Failed to fetch user online"));
          }
          return;
        }

        final onlineUser = UserAuthModel.fromJson(
          Map<String, dynamic>.from(result.data!['get_user_by_id_auth_']),
        );

        // Save online data to Hive
        await HiveService.saveData(
          boxName: AppDBConstants.profileUserBox,
          key: AppDBConstants.profileUser,
          value: onlineUser.toJson(),
        );

        emit(GetUserAuthSuccess(user: onlineUser));
        AppLoggerHelper.logInfo("✅ User data fetched successfully (ONLINE)");
      } catch (e) {
        AppLoggerHelper.logError("⚠️ Online fetch error: $e");
        if (offlineUser == null) {
          emit(GetUserAuthFailure(message: e.toString()));
        }
      }
    });
  }
}
