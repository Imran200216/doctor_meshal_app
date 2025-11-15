import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

part 'connectivity_event.dart';

part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  ConnectivityBloc() : super(ConnectivityInitial()) {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      // Get first connection type (or none)
      final result = results.isNotEmpty
          ? results.first
          : ConnectivityResult.none;

      bool isConnected = result != ConnectivityResult.none;

      add(ConnectivityChanged(isConnected));
    });

    on<ConnectivityChanged>((event, emit) {
      if (event.isConnected) {
        emit(ConnectivitySuccess(event.isConnected));
      } else {
        emit(ConnectivityFailure());
      }
    });
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }
}
