import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';

class ChatGraphQLWebSocketService {
  late final GraphQLClient client;
  late final WebSocketLink websocketLink;

  ChatGraphQLWebSocketService();

  Future<void> init({required String websocketEndpoint}) async {
    AppLoggerHelper.logInfo('Initializing Chat GraphQL WebSocket Service');

    websocketLink = WebSocketLink(
      websocketEndpoint,
      subProtocol: GraphQLProtocol.graphqlTransportWs,
      config: SocketClientConfig(
        autoReconnect: true,
        inactivityTimeout: const Duration(seconds: 30),
        delayBetweenReconnectionAttempts: const Duration(seconds: 2),
      ),
    );

    client = GraphQLClient(
      link: websocketLink,
      cache: GraphQLCache(store: InMemoryStore()),
    );

    AppLoggerHelper.logInfo("Chat WebSocket Service initialized");
  }

  Stream<QueryResult> subscribe(
    String subscription, {
    Map<String, dynamic>? variables,
  }) {
    AppLoggerHelper.logInfo('Starting chat subscription');
    AppLoggerHelper.logInfo('Subscription query: $subscription');
    AppLoggerHelper.logInfo('Variables: $variables');

    return client.subscribe(
      SubscriptionOptions(
        document: gql(subscription),
        variables: variables ?? {},
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
  }

  void reconnectWebSocket() {
    AppLoggerHelper.logInfo('Manually reconnecting Chat WebSocket');
    websocketLink.connectOrReconnect();
  }

  Future<void> dispose() async {
    AppLoggerHelper.logInfo('Disposing Chat WebSocket Service');
    await websocketLink.dispose();
  }
}
