import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meshal_doctor_booking_app/core/bloc/connectivity/connectivity_bloc.dart';
import 'package:meshal_doctor_booking_app/di/service_locator.dart';
import 'package:meshal_doctor_booking_app/features/auth/view_model/bloc/email_auth/email_auth_bloc.dart';
import 'package:meshal_doctor_booking_app/features/auth/view_model/bloc/user_auth/user_auth_bloc.dart';
import 'package:meshal_doctor_booking_app/features/auth/view_model/cubit/auth_selected_type_cubit.dart';
import 'package:meshal_doctor_booking_app/features/bottom_nav/view_model/cubit/bottom_nav_cubit.dart';
import 'package:meshal_doctor_booking_app/features/change_password/view_model/bloc/change_password/change_password_bloc.dart';
import 'package:meshal_doctor_booking_app/features/chat/view_model/bloc/doctor_list/doctor_list_bloc.dart';
import 'package:meshal_doctor_booking_app/features/chat/view_model/bloc/subscribe_chat_message/subscribe_chat_message_bloc.dart';
import 'package:meshal_doctor_booking_app/features/chat/view_model/bloc/view_user_chat_room_message/view_user_chat_room_message_bloc.dart';
import 'package:meshal_doctor_booking_app/features/doctor_peri_operative/view_model/bloc/operative_form/view_doctor_operative_form_bloc.dart';
import 'package:meshal_doctor_booking_app/features/doctor_peri_operative/view_model/bloc/submitted_patient_form_details_section/submitted_patient_form_details_section_bloc.dart';
import 'package:meshal_doctor_booking_app/features/edit_personal_details/view_model/bloc/update_user_profile_details_bloc.dart';
import 'package:meshal_doctor_booking_app/features/edit_personal_details/view_model/cubit/profile_image/profile_image_cubit.dart';
import 'package:meshal_doctor_booking_app/features/education/view_model/education/education_bloc.dart';
import 'package:meshal_doctor_booking_app/features/education/view_model/education_articles/education_articles_bloc.dart';
import 'package:meshal_doctor_booking_app/features/education/view_model/education_full_view_article/education_full_view_article_bloc.dart';
import 'package:meshal_doctor_booking_app/features/education/view_model/education_sub_title/education_sub_title_bloc.dart';
import 'package:meshal_doctor_booking_app/features/home/view_model/bloc/doctor_dashboard_summary_counts/doctor_dashboard_summary_counts_bloc.dart';
import 'package:meshal_doctor_booking_app/features/home/view_model/bloc/operative_summary_counts/operative_summary_counts_bloc.dart';
import 'package:meshal_doctor_booking_app/features/home/view_model/bloc/user_chat_room/view_user_chat_room_bloc.dart';
import 'package:meshal_doctor_booking_app/features/localization/view_model/cubit/localization_cubit.dart';
import 'package:meshal_doctor_booking_app/features/peri_operative/view_model/bloc/operative_form/operative_form_bloc.dart';
import 'package:meshal_doctor_booking_app/features/peri_operative/view_model/bloc/status/status_form_bloc.dart';
import 'package:meshal_doctor_booking_app/features/peri_operative/view_model/bloc/survey_operative_form/survey_operative_form_bloc.dart';
import 'package:meshal_doctor_booking_app/features/peri_operative/view_model/cubit/operation_selected_chip/operative_selected_chip_cubit.dart';
import 'package:meshal_doctor_booking_app/features/peri_operative/view_model/cubit/survey_form/survey_form_selection_cubit.dart';

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

  // Education Articles Bloc
  BlocProvider<EducationArticlesBloc>(
    create: (context) => getIt<EducationArticlesBloc>(),
  ),

  // Education Full View Articles Bloc
  BlocProvider<EducationFullViewArticleBloc>(
    create: (context) => getIt<EducationFullViewArticleBloc>(),
  ),

  // Update User Profile Details Bloc
  BlocProvider<UpdateUserProfileDetailsBloc>(
    create: (context) => getIt<UpdateUserProfileDetailsBloc>(),
  ),

  // Operative Form Bloc
  BlocProvider<OperativeFormBloc>(
    create: (context) => getIt<OperativeFormBloc>(),
  ),

  // Connectivity Bloc
  BlocProvider<ConnectivityBloc>(
    create: (context) => getIt<ConnectivityBloc>(),
  ),

  // Survey Form Bloc
  BlocProvider<SurveyFormSelectionCubit>(
    create: (context) => getIt<SurveyFormSelectionCubit>(),
  ),

  // Survey Operative Form Bloc
  BlocProvider<SurveyOperativeFormBloc>(
    create: (context) => getIt<SurveyOperativeFormBloc>(),
  ),

  // Status Form Bloc
  BlocProvider<StatusFormBloc>(create: (context) => getIt<StatusFormBloc>()),

  // Doctor List Bloc
  BlocProvider<DoctorListBloc>(create: (context) => getIt<DoctorListBloc>()),

  // Operative Summary Counts Bloc
  BlocProvider<OperativeSummaryCountsBloc>(
    create: (context) => getIt<OperativeSummaryCountsBloc>(),
  ),

  // View User Chat Room Bloc
  BlocProvider<ViewUserChatRoomBloc>(
    create: (context) => getIt<ViewUserChatRoomBloc>(),
  ),

  // View User Chat Room Message Bloc
  BlocProvider<ViewUserChatRoomMessageBloc>(
    create: (context) => getIt<ViewUserChatRoomMessageBloc>(),
  ),

  // Subscribe Chat Message Bloc
  BlocProvider<SubscribeChatMessageBloc>(
    create: (context) => getIt<SubscribeChatMessageBloc>(),
  ),

  // View Doctor Peri Operative Form Bloc
  BlocProvider<ViewDoctorOperativeFormBloc>(
    create: (context) => getIt<ViewDoctorOperativeFormBloc>(),
  ),

  // Profile Image Cubit
  BlocProvider<ProfileImageCubit>(
    create: (context) => getIt<ProfileImageCubit>(),
  ),

  // SubmittedPatientFormDetailsSectionBloc
  BlocProvider<SubmittedPatientFormDetailsSectionBloc>(
    create: (context) => getIt<SubmittedPatientFormDetailsSectionBloc>(),
  ),

  // Doctor Dashboard summary Counts Bloc
  BlocProvider<DoctorDashboardSummaryCountsBloc>(
    create: (context) => getIt<DoctorDashboardSummaryCountsBloc>(),
  ),
];
