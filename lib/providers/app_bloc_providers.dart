import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meshal_doctor_booking_app/di/service_locator.dart';
import 'package:meshal_doctor_booking_app/features/auth/presentation/cubit/auth_selected_type_cubit.dart';
import 'package:meshal_doctor_booking_app/features/bottom_nav/presentation/cubit/bottom_nav_cubit.dart';
import 'package:meshal_doctor_booking_app/features/localization/cubit/localization_cubit.dart';

List<BlocProvider> appBlocProviders = [
  // Localization Cubit
  BlocProvider<LocalizationCubit>(
    create: (context) => getIt<LocalizationCubit>(),
  ),

  // Auth Selected Cubit
  BlocProvider<AuthSelectedTypeCubit>(
    create: (context) => getIt<AuthSelectedTypeCubit>(),
  ),

  // Bottom Nav Cubit
  BlocProvider<BottomNavCubit>(create: (context) => getIt<BottomNavCubit>()),
];
