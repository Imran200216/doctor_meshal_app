import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';

class ChatGraphQLHttpService {
  late GraphQLClient client;

  Future<void> init({
    required String httpEndpoint,
    required String websocketEndpoint,
    Map<String, String>? defaultHeaders,
  }) async {
    AppLoggerHelper.logInfo('Initializing Chat GraphQL Services');

    // HTTP Link
    final httpLink = HttpLink(
      httpEndpoint,
      defaultHeaders: defaultHeaders ?? {},
    );

    // WebSocket Link
    final websocketLink = WebSocketLink(
      websocketEndpoint,
      config: SocketClientConfig(
        autoReconnect: true,
        inactivityTimeout: const Duration(minutes: 120),
        initialPayload: {},
        pingMessage: {'type': 'ping'},
        headers: {},
      ),
    );

    // COMBINE BOTH LINKS
    final link = Link.split(
      (request) => request.isSubscription,
      websocketLink,
      httpLink,
    );

    client = GraphQLClient(
      link: link,
      cache: GraphQLCache(store: InMemoryStore()),
    );

    AppLoggerHelper.logInfo("✅ GraphQL client initialized (HTTP + WS)");
  }

  // QUERY
  Future<QueryResult> performQuery(
    String query, {
    Map<String, dynamic>? variables,
  }) {
    return client.query(
      QueryOptions(document: gql(query), variables: variables ?? {}),
    );
  }

  // MUTATION
  Future<QueryResult> performMutation(
    String mutation, {
    Map<String, dynamic>? variables,
  }) {
    return client.mutate(
      MutationOptions(document: gql(mutation), variables: variables ?? {}),
    );
  }

  // SUBSCRIPTION
  Stream<QueryResult> performSubscribe(
    String subscriptionQuery, {
    Map<String, dynamic>? variables,
  }) {
    AppLoggerHelper.logInfo("📡 Starting GraphQL subscription");

    return client.subscribe(
      SubscriptionOptions(
        document: gql(subscriptionQuery),
        variables: variables ?? {},
      ),
    );
  }
}
