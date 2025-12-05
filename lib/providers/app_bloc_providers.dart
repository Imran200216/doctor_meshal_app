import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meshal_doctor_booking_app/core/bloc/connectivity/connectivity_bloc.dart';
import 'package:meshal_doctor_booking_app/features/auth/auth.dart';
import 'package:meshal_doctor_booking_app/features/bio/bio.dart';
import 'package:meshal_doctor_booking_app/features/bottom_nav/bottom_nav.dart';
import 'package:meshal_doctor_booking_app/features/change_password/change_password.dart';
import 'package:meshal_doctor_booking_app/features/chat/chat.dart';
import 'package:meshal_doctor_booking_app/features/doctor_peri_operative/doctor_peri_operative.dart';
import 'package:meshal_doctor_booking_app/features/edit_personal_details/edit_personal_details.dart';
import 'package:meshal_doctor_booking_app/features/education/education.dart';
import 'package:meshal_doctor_booking_app/features/feedback/feedback.dart';
import 'package:meshal_doctor_booking_app/features/home/home.dart';
import 'package:meshal_doctor_booking_app/features/localization/localization.dart';
import 'package:meshal_doctor_booking_app/features/peri_operative/peri_operative.dart';
import 'package:meshal_doctor_booking_app/features/notification/notification.dart';

final GetIt getIt = GetIt.instance;

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

  // Send Chat Message Bloc
  BlocProvider<SendChatMessageBloc>(
    create: (context) => getIt<SendChatMessageBloc>(),
  ),

  // View User Chat Bloc
  BlocProvider<ViewUserChatHomeBloc>(
    create: (context) => getIt<ViewUserChatHomeBloc>(),
  ),

  // Query View User Chat Home Bloc
  BlocProvider<QueryViewUserChatHomeBloc>(
    create: (context) => getIt<QueryViewUserChatHomeBloc>(),
  ),

  // View Submitted Form Details Section Bloc
  BlocProvider<ViewSubmittedFormDetailsSectionBloc>(
    create: (context) => getIt<ViewSubmittedFormDetailsSectionBloc>(),
  ),

  // Doctor Review Patient Submitted Operation Forms Bloc
  BlocProvider<DoctorReviewPatientSubmittedOperationFormsBloc>(
    create: (context) =>
        getIt<DoctorReviewPatientSubmittedOperationFormsBloc>(),
  ),

  // Doctor Bio Bloc
  BlocProvider<ViewDoctorBioBloc>(
    create: (context) => getIt<ViewDoctorBioBloc>(),
  ),

  // Doctor Feedback Bloc
  BlocProvider<DoctorFeedbackBloc>(
    create: (context) => getIt<DoctorFeedbackBloc>(),
  ),

  // View All Notification Bloc
  BlocProvider<ViewAllNotificationBloc>(
    create: (context) => getIt<ViewAllNotificationBloc>(),
  ),

  // View All Notification Un Read Count Bloc
  BlocProvider<ViewNotificationUnReadCountBloc>(
    create: (context) => getIt<ViewNotificationUnReadCountBloc>(),
  ),
];
