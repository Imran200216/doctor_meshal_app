import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meshal_doctor_booking_app/di/service_locator.dart';
import 'package:meshal_doctor_booking_app/features/auth/view_model/bloc/email_auth/email_auth_bloc.dart';
import 'package:meshal_doctor_booking_app/features/auth/view_model/bloc/user_auth/user_auth_bloc.dart';
import 'package:meshal_doctor_booking_app/features/auth/view_model/cubit/auth_selected_type_cubit.dart';
import 'package:meshal_doctor_booking_app/features/bottom_nav/presentation/cubit/bottom_nav_cubit.dart';
import 'package:meshal_doctor_booking_app/features/change_password/view_model/bloc/change_password/change_password_bloc.dart';
import 'package:meshal_doctor_booking_app/features/education/view_model/education/education_bloc.dart';
import 'package:meshal_doctor_booking_app/features/education/view_model/education_sub_title/education_sub_title_bloc.dart';
import 'package:meshal_doctor_booking_app/features/localization/cubit/localization_cubit.dart';
import 'package:meshal_doctor_booking_app/features/peri_operative/presentation/cubit/operative_selected_chip_cubit.dart';

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

  // Operative Selected Chip Cubit
  BlocProvider<OperativeSelectedChipCubit>(
    create: (context) => getIt<OperativeSelectedChipCubit>(),
  ),

  // Email Auth Bloc
  BlocProvider<EmailAuthBloc>(create: (context) => getIt<EmailAuthBloc>()),

  // User Auth Bloc
  BlocProvider<UserAuthBloc>(create: (context) => getIt<UserAuthBloc>()),

  // Education Bloc
  BlocProvider<EducationBloc>(create: (context) => getIt<EducationBloc>()),

  // Education Sub Title Bloc
  BlocProvider<EducationSubTitleBloc>(
    create: (context) => getIt<EducationSubTitleBloc>(),
  ),

  // Change Password Bloc
  BlocProvider<ChangePasswordBloc>(
    create: (context) => getIt<ChangePasswordBloc>(),
  ),
];
