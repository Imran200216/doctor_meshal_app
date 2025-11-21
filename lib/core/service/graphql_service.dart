import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';

class GraphQLService {
  late final GraphQLClient client;

  GraphQLService();

  /// Initialize HTTP-only GraphQL client
  Future<void> init({
    required String httpEndpoint, // Use the HTTP base URL here
  }) async {
    AppLoggerHelper.logInfo('Initializing HTTP GraphQL Service');

    final HttpLink httpLink = HttpLink(httpEndpoint);

    client = GraphQLClient(link: httpLink, cache: GraphQLCache());

    AppLoggerHelper.logInfo("HTTP GraphQL Service initialized successfully");
  }

  /// ===========================
  /// 🔵 QUERY
  /// ===========================
  Future<QueryResult> performQuery(
      String query, {
        Map<String, dynamic>? variables,
      }) async {
    try {
      AppLoggerHelper.logInfo('Executing GraphQL query');
      return await client.query(
        QueryOptions(
          document: gql(query),
          variables: variables ?? {},
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
    } catch (e) {
      AppLoggerHelper.logError('GraphQL query error: $e');
      rethrow;
    }
  }

  /// ===========================
  /// 🟢 MUTATION
  /// ===========================
  Future<QueryResult> performMutation(
      String mutation, {
        Map<String, dynamic>? variables,
      }) async {
    try {
      AppLoggerHelper.logInfo('Executing GraphQL mutation');
      return await client.mutate(
        MutationOptions(
          document: gql(mutation),
          variables: variables ?? {},
        ),
      );
    } catch (e) {
      AppLoggerHelper.logError('GraphQL mutation error: $e');
      rethrow;
    }
  }
}
