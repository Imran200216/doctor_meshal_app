import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_selected_type_state.dart';

class AuthSelectedTypeCubit extends Cubit<AuthSelectedTypeState> {
  AuthSelectedTypeCubit() : super(AuthSelectedTypeInitial());

  String? selectedAuthType;

  void selectAuthType (String authType) {
    selectedAuthType = authType;

    emit(AuthSelectedType(selectedAuthType: authType));
  }
}
