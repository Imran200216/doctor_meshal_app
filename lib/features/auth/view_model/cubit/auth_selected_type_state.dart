part of 'auth_selected_type_cubit.dart';

sealed class AuthSelectedTypeState extends Equatable {
  const AuthSelectedTypeState();
}

final class AuthSelectedTypeInitial extends AuthSelectedTypeState {
  @override
  List<Object> get props => [];
}

final class AuthSelectedType extends AuthSelectedTypeState {
  final String selectedAuthType;

  const AuthSelectedType({required this.selectedAuthType});

  @override
  // TODO: implement props
  List<Object?> get props => [selectedAuthType];
}
