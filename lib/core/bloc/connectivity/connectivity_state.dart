part of 'connectivity_bloc.dart';

sealed class ConnectivityState extends Equatable {
  const ConnectivityState();
}

final class ConnectivityInitial extends ConnectivityState {
  @override
  List<Object> get props => [];
}

class ConnectivitySuccess extends ConnectivityState {
  final bool isConnected;

  const ConnectivitySuccess(this.isConnected);

  @override
  List<Object> get props => [isConnected];
}

// State when there is no connectivity
class ConnectivityFailure extends ConnectivityState {
  @override
  List<Object> get props => [];
}