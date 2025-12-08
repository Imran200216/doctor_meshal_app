import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meshal_doctor_booking_app/core/router/app_router.dart';
import 'package:meshal_doctor_booking_app/core/service/service.dart';
import 'package:meshal_doctor_booking_app/di/service_locator.dart';
import 'package:meshal_doctor_booking_app/firebase_options.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';
import 'package:meshal_doctor_booking_app/providers/app_bloc_providers.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/features/localization/localization.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// ========== Background Message Handler ==========
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase in background isolate
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  AppLoggerHelper.logInfo(
    "📱 Background message received: ${message.messageId}",
  );

  // Handle notification data
  final notification = message.notification;
  final data = message.data;

  AppLoggerHelper.logInfo("📦 Notification Title: ${notification?.title}");
  AppLoggerHelper.logInfo("📦 Notification Body: ${notification?.body}");
  AppLoggerHelper.logInfo("📦 Custom Data: $data");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase Initialize
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Register background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Hive Initialization
  await Hive.initFlutter();

  // Service Locator
  setUpServiceLocators();

  // Lock orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());

  // Firebase Messaging Service
  FCMService.initialize();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      // App Bloc Providers
      providers: appBlocProviders,

      child: BlocBuilder<LocalizationCubit, LocalizationState>(
        builder: (context, state) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: "Doctor Meshal App",

            // Localization
            locale: state is LocalizationSelected
                ? Locale(state.selectedLanguage)
                : const Locale("en"),
            supportedLocales: const [Locale('en'), Locale('ar')],
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],

            // Themes
            theme: ThemeData(
              fontFamily: 'OpenSans',
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColorConstants.primaryColor,
              ),
            ),

            // Router
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
