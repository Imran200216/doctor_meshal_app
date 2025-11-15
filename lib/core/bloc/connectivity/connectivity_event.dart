part of 'connectivity_bloc.dart';

sealed class ConnectivityEvent extends Equatable {
  const ConnectivityEvent();
}

// Event triggered when connectivity changes
class ConnectivityChanged extends ConnectivityEvent {
  final bool isConnected;

  const ConnectivityChanged(this.isConnected);

  @override
  List<Object> get props => [isConnected];
}
