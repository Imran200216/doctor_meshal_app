import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLService {
  late final GraphQLClient _client;

  GraphQLService(String endpoint, {String? authToken}) {
    final HttpLink httpLink = HttpLink(endpoint);

    Link link = httpLink;
    if (authToken != null && authToken.isNotEmpty) {
      link = AuthLink(
        getToken: () async => 'Bearer $authToken',
      ).concat(httpLink);
    }

    _client = GraphQLClient(
      cache: GraphQLCache(store: InMemoryStore()),
      link: link,
    );
  }

  /// ✅ Run a GraphQL query
  Future<QueryResult> performQuery(
    String query, {
    Map<String, dynamic>? variables,
  }) async {
    final options = QueryOptions(
      document: gql(query),
      variables: variables ?? {},
      fetchPolicy: FetchPolicy.networkOnly,
    );
    return await _client.query(options);
  }

  /// ✅ Run a GraphQL mutation
  Future<QueryResult> performMutation(
    String mutation, {
    Map<String, dynamic>? variables,
  }) async {
    final options = MutationOptions(
      document: gql(mutation),
      variables: variables ?? {},
    );
    return await _client.mutate(options);
  }
}
