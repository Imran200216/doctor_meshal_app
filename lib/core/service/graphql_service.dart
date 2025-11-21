import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';

class GraphQLService {
  late final GraphQLClient _client;
  late final WebSocketLink _websocketLink;

  GraphQLService({
    required String httpEndpoint,
    required String websocketEndpoint,
  }) {
    AppLoggerHelper.logInfo('Initializing GraphQL Service');
    AppLoggerHelper.logInfo('WebSocket URL: $websocketEndpoint');

    /// HTTP Link (Queries + Mutations)
    final HttpLink httpLink = HttpLink(httpEndpoint);

    /// WebSocket Link (Subscriptions)
    _websocketLink = WebSocketLink(
      websocketEndpoint,
      // ✅ Use graphql-transport-ws to match Node `graphql-ws` server
      subProtocol: GraphQLProtocol.graphqlTransportWs,
      config: SocketClientConfig(
        autoReconnect: true,
        inactivityTimeout: const Duration(seconds: 30),
        delayBetweenReconnectionAttempts: const Duration(seconds: 5),
        onConnectionLost: (code, reason) {
          AppLoggerHelper.logError(
            '❌ Connection lost: Code=$code, Reason=$reason',
          );
        },
      ),
    );

    /// Split:
    /// - Subscriptions → websocket
    /// - Queries/Mutations → http
    final Link link = Link.split(
      (request) => request.isSubscription,
      _websocketLink,
      httpLink,
    );

    _client = GraphQLClient(link: link, cache: GraphQLCache());
  }

  /// ===========================
  /// 🔵 QUERY
  /// ===========================
  Future<QueryResult> performQuery(
    String query, {
    Map<String, dynamic>? variables,
  }) async {
    try {
      AppLoggerHelper.logInfo('Executing query');
      return await _client.query(
        QueryOptions(
          document: gql(query),
          variables: variables ?? {},
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
    } catch (e) {
      AppLoggerHelper.logError('Query error: $e');
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
      AppLoggerHelper.logInfo('Executing mutation');
      return await _client.mutate(
        MutationOptions(document: gql(mutation), variables: variables ?? {}),
      );
    } catch (e) {
      AppLoggerHelper.logError('Mutation error: $e');
      rethrow;
    }
  }

  /// ===========================
  /// 🔴 SUBSCRIPTION
  /// ===========================
  Stream<QueryResult> performSubscribe(
    String subscription, {
    Map<String, dynamic>? variables,
  }) {
    AppLoggerHelper.logInfo('Starting subscription');
    AppLoggerHelper.logInfo('Subscription query: $subscription');
    AppLoggerHelper.logInfo('Variables: $variables');

    return _client.subscribe(
      SubscriptionOptions(
        document: gql(subscription),
        variables: variables ?? {},
      ),
    );
  }

  /// Manually reconnect websocket
  void reconnectWebSocket() {
    AppLoggerHelper.logInfo('Manually reconnecting WebSocket');
    _websocketLink.connectOrReconnect();
  }

  /// Dispose websocket connection
  Future<void> dispose() async {
    AppLoggerHelper.logInfo('Disposing GraphQL Service');
    await _websocketLink.dispose();
  }
}
