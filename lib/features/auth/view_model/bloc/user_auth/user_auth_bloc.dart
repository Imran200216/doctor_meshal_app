import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/core/service/service.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';
import 'package:meshal_doctor_booking_app/features/auth/model/user_auth_model.dart';

part 'user_auth_event.dart';

part 'user_auth_state.dart';

class UserAuthBloc extends Bloc<UserAuthEvent, UserAuthState> {
  final GraphQLService graphQLService;
  String? _cachedUserId;
  UserAuthModel? _cachedUser;

  UserAuthBloc(this.graphQLService) : super(UserAuthInitial()) {
    on<GetUserAuthEvent>((event, emit) async {
      emit(GetUserAuthLoading());

      // Try to load from cache first
      await _loadFromCache();

      if (_cachedUser != null) {
        // Immediately show cached data
        emit(GetUserAuthSuccess(user: _cachedUser!, isCached: true));
        AppLoggerHelper.logInfo("Showing cached user data for id: ${event.id}");
      }

      // Now try to fetch from API
      try {
        final String query =
            '''
        query Get_user_by_id_auth_ {
          get_user_by_id_auth_(id: "${event.id}", token: "${event.token}") {
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

        AppLoggerHelper.logInfo("GraphQL Query: $query");

        final result = await graphQLService.performQuery(query);

        final userData = result.data?['get_user_by_id_auth_'];
        AppLoggerHelper.logInfo("GraphQL Response Data: $userData");

        if (userData == null) {
          AppLoggerHelper.logError("No user data found for id: ${event.id}");

          // If we have cached data and API failed, keep showing cached
          if (_cachedUser != null) {
            emit(GetUserAuthSuccess(user: _cachedUser!, isCached: true));
          } else {
            emit(GetUserAuthFailure(message: "No user data found"));
          }
          return;
        }

        final user = UserAuthModel.fromJson(userData);

        // Cache the new data
        await _cacheUserData(user);

        emit(GetUserAuthSuccess(user: user, isCached: false));
        AppLoggerHelper.logInfo(
          "User data fetched successfully for id: ${event.id}",
        );
      } catch (e) {
        AppLoggerHelper.logError(
          "Error fetching user data for id: ${event.id}, Error: $e",
        );

        // If we have cached data, show it with error status
        if (_cachedUser != null) {
          emit(
            GetUserAuthSuccess(
              user: _cachedUser!,
              isCached: true,
              hasError: true,
            ),
          );
        } else {
          emit(GetUserAuthFailure(message: e.toString()));
        }
      }
    });

    on<LoadCachedUserAuthEvent>((event, emit) async {
      emit(GetUserAuthLoading());
      await _loadFromCache();

      if (_cachedUser != null) {
        emit(GetUserAuthSuccess(user: _cachedUser!, isCached: true));
      } else {
        emit(GetUserAuthFailure(message: "No cached user data found"));
      }
    });

    on<ClearUserAuthCacheEvent>((event, emit) async {
      await _clearCache();
      emit(UserAuthInitial());
    });
  }

  Future<void> _loadFromCache() async {
    try {
      await HiveService.openBox(AppDBConstants.userBox);

      final storedUserMap = await HiveService.getData<Map>(
        boxName: AppDBConstants.userBox,
        key: AppDBConstants.userAuthData,
      );

      if (storedUserMap != null) {
        _cachedUser = UserAuthModel.fromJson(
          Map<String, dynamic>.from(storedUserMap),
        );
        _cachedUserId = _cachedUser!.id;
        AppLoggerHelper.logInfo(
          "User data loaded from cache: ${_cachedUser!.id}",
        );
      }
    } catch (e) {
      AppLoggerHelper.logError("Error loading user from cache: $e");
    }
  }

  // Cache User Data
  Future<void> _cacheUserData(UserAuthModel user) async {
    try {
      await HiveService.openBox(AppDBConstants.userBox);

      await HiveService.saveData(
        boxName: AppDBConstants.userBox,
        key: AppDBConstants.userAuthData,
        value: user.toJson(),
      );

      _cachedUser = user;
      _cachedUserId = user.id;
      AppLoggerHelper.logInfo("User data cached successfully: ${user.id}");
    } catch (e) {
      AppLoggerHelper.logError("Error caching user data: $e");
    }
  }


  // Clear Cache
  Future<void> _clearCache() async {
    try {
      await HiveService.openBox(AppDBConstants.userBox);
      await HiveService.clearBox(AppDBConstants.userBox);

      _cachedUser = null;
      _cachedUserId = null;
      AppLoggerHelper.logInfo("User cache cleared");
    } catch (e) {
      AppLoggerHelper.logError("Error clearing user cache: $e");
    }
  }

  // Helper method to get cached user without emitting state
  UserAuthModel? getCachedUser() => _cachedUser;

  String? getCachedUserId() => _cachedUserId;
}
